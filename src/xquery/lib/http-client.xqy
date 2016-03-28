(::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::)
(:  File:       marklogic/http-client.xq                                    :)
(:  Author:     F. Georges - fgeorges.org                                   :)
(:  Date:       2009-03-04                                                  :)
(:  Tags:                                                                   :)
(:      Copyright (c) 2009 Florent Georges (see end of file.)               :)
(: ------------------------------------------------------------------------ :)

xquery version "1.0";


(:~
 : Implementation for MarkLogic of the EXPath HTTP Client module.
 :
 : @author Florent Georges - fgeorges.org
 : @version 0.1
 : @see http://expath.org/modules/http-client/
 :)
module namespace http = "http://www.exslt.org/v2/http-client";
declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare namespace xdmp = "http://marklogic.com/xdmp";
declare namespace err  = "urn:X-FGeorges:expath:httpclient:marklogic:err";
declare namespace ml   = "xdmp:http";

declare variable $http:timeout-seconds as xs:integer := 5;


(:~
 : Call the MarkLogic HTTP Client extension functions to actually send the request.
 :
 : <p>Send the request through MarkLogic extensions, corresponding to the params.
 : The request is sent to <code>$href</code> (a URI as an <code>xs:string</code>).
 : The exact function used depends on the value of <code>$method</code>.  The
 : options passed to this function are those in <code>$options</code>.</p>
 :
 : @param $href The URI to send the request to.
 :
 : @param $method One of the string 'delete', 'get', 'head', 'options', 'post'
 :    or 'put'.  It is case insensitive.
 :
 : @param $options The <code>ml:options</code> element, as expected by MarkLogic
 :    HTTP functions.
 :
 : @return The return value of the MarkLogic extension function actually called.
 :)
declare function http:do-send-request($href as xs:string,
                                      $method as xs:string,
                                      $options as element(ml:options))
      as item()+
{
   let $m := lower-case($method)
      return
         if ( $m eq 'delete' ) then
            xdmp:http-delete($href, $options)
         else if ( $m eq 'get' ) then
            xdmp:http-get($href, $options)
         else if ( $m eq 'head' ) then
            xdmp:http-head($href, $options)
         else if ( $m eq 'options' ) then
            xdmp:http-options($href, $options)
         else if ( $m eq 'post' ) then
            xdmp:http-post($href, $options)
         else if ( $m eq 'put' ) then
            xdmp:http-put($href, $options)
         else
            error(xs:QName('err:TODO'), concat('Unknown or absent method:', $method))
};

(:~
 : Return a enumeration value from the Content-Type header.
 :
 : <p>The value returned is a string, either 'MULTIPART', 'HTML', 'XML',
 : 'TEXT', or 'BINARY'.</p>
 :)
declare function http:decode-content-type($header as xs:string)
      as xs:string
{
   let $type := normalize-space((substring-before($header, ';'), $header)[. ne ''][1])
      return
         if ( starts-with($type, 'multipart/') ) then
            'MULTIPART'
         else if ( $type eq 'text/html' ) then
            'HTML'
         else if ( ends-with($type, '+xml')
                      or $type eq 'text/xml'
                      or $type eq 'application/xml'
                      or $type eq 'text/xml-external-parsed-entity'
                      or $type eq 'application/xml-external-parsed-entity' ) then
            'XML'
         else if ( starts-with($type, 'text/')
                      or $type eq 'application/x-www-form-urlencoded'
                      or $type eq 'application/xml-dtd' ) then
            'TEXT'
         else
            'BINARY'
};

(:~
 : Return the EXPath HTTP response content items from a MarkLogic HTTP response.
 :)
declare function http:make-content-items($resp as item()+)
      as item()
{
   let $type := http:decode-content-type($resp[1]/ml:headers/ml:content-type)
      return
         if ( $type eq 'MULTIPART' ) then
            error(xs:QName('err:TODO'), 'Not implemented yet.')
         else if ( $type = ('XML', 'TEXT') ) then
            $resp[2]
         else if ( $type eq 'HTML' ) then
            xdmp:tidy($resp[2],<options xmlns="xdmp:tidy">
             <output-xhtml>no</output-xhtml><tidy-mark>no</tidy-mark><doctype>omit</doctype>
                 <output-xml>yes</output-xml></options>)[2]
         else if ( $type eq 'BINARY' ) then
            xs:base64Binary($resp[2])
         else
            error(xs:QName('err:TODO'), 'Could not happen.')
};

(:~
 : If <code>$value</code> exists, return an attribute with given name and value.
 :
 : <p>The attribute has the name <code>$name</code> and value <code>$value</code>.
 : If <code>$value</code> is the empty sequence, returns the empty sequence.</p>
 :)
declare function http:make-attribute($name as xs:string, $value as xs:string?)
      as attribute()?
{
   if ( exists($value) ) then
      attribute { $name } { $value }
   else
      ()
};

(:~
 : If <code>$value</code> exists, return a MarkLogic HTTP request header element.
 :
 : <p>The header has the name <code>$name</code> and value <code>$value</code>.
 : If <code>$value</code> is the empty sequence, returns the empty sequence.</p>
 :)
declare function http:make-element($name as xs:string, $value as xs:string?)
      as element()?
{
   if ( exists($value) ) then
      element { QName('xdmp:http', $name) } { $value }
   else
      ()
};

(:~
 : Make a ml:content-type header element for a MarkLogic HTTP request.
 :
 : <p>Make a header element as expected by MarkLogic HTTP Client extension
 : functions.  It takes encoding and boundary into account, if any.  If
 : <code>$body</code> is the empty sequence, the result itself is the empty
 : sequence.</p>
 :
 : <p>TODO: Clarify the role of <code>@encoding</code>.  It does not correspond
 : to the use here in this function.  It should generate another header
 : instead, IMHO.</p>
 :
 : @param $body The EXPath HTTP request body element to generate a Content-Type
 :    header for, either an <code>http:body</code> or an <code>http:multipart</code>
 :    element.
 :)
declare function http:make-element-type($body as element()?)
      as element(ml:content-type)?
{
   $body/
      <ml:content-type> {
         concat(
            @content-type,
            if ( exists(@encoding) ) then '; encoding=' else '', @encoding,
            if ( exists(@boundary) ) then '; boundary=' else '', @boundary
         )
      }
      </ml:content-type>
};

(:~
 : Make the EXPath HTTP response body element from the MarkLogic HTTP response.
 :
 : <p>Multipart responses are not supported.</p>
 :
 : <p>TODO: How can I find the value of @encoding?</p>
 :
 : @param $resp The response element as returned by the MarkLogic HTTP functions.
 :)
declare function http:make-body($resp as item()+)
      as item()
{
   let $type := $resp[1]/ml:headers/ml:content-type
   let $id   := $resp[1]/ml:headers/ml:content-id
   let $desc := $resp[1]/ml:headers/ml:content-description
      return
         if ( http:decode-content-type($type) eq 'MULTIPART' ) then
            <http:multipart> {
               error(xs:QName('err:TODO'), 'Not implemented yet.')
            }
            </http:multipart>
         else
            <http:body content-type="{ $type }"> {
               http:make-attribute('encoding', (: TODO: What?... :) ()),
               http:make-attribute('id', $id),
               http:make-attribute('description', $desc)
            }
            </http:body>
};

(:~
 : Serialize the entity body from an <code>http:multipart</code> element.
 :
 : <p>This function is a following-sibling-recursive function.  It must be
 : called initially with the first <code>http:*</code> child of
 : <code>http:multipart</code> (a header or a body.)  It will then recurse on
 : the following elements (in the http: namespace.)</p>
 :
 : @param $elem The child of multipart to serialize.  The initial caller must
 :    use the first child (the function will recurse on its following siblings.)
 :    Must be either an <code>http:header</code> or an <code>http:body</code>
 :    element.
 :
 : @param $boundary The boundary to use (must begin with the two additional
 :    dashes '--' and end with the newline characters '\r\n'.
 :
 : @return The serialized entity, as a sequence of strings.  The actual entity
 :    can be retrieved by joining the strings all together.
 :)
declare function http:serialize-multipart($elem as element()?, $boundary as xs:string)
      as xs:string*
{
   $elem/(
      if ( $elem[self::http:header] ) then
         (: Is it the first header of a part? :)
         if ( empty($elem/preceding-sibling::http:*[1][self::http:header]) ) then
            concat($boundary, $elem/@name, ': ', $elem/@value, '&#13;&#10;')
         else
            concat($elem/@name, ': ', $elem/@value, '&#13;&#10;')
      else if ( $elem[self::http:body] ) then
         ('&#13;&#10;', http:serialize-data(.), '&#13;&#10;')
      else
         error(xs:QName('err:TODO'), 'Could not happen.'),
      http:serialize-multipart(following-sibling::http:*[1], $boundary)
   )
};

(:~
 : Serialize the entity body from an EXPath HTTP body.
 :
 : @param $elem The child of multipart to serialize.  The initial caller must
 :    use the first child (the function will recurse on its following siblings.)
 :    Must be either an <code>http:header</code> or an <code>http:body</code>
 :    element.
 :
 : @param $boundary The boundary to use (must begin with the two additional
 :    dashes '--' and end with the newline characters '\r\n'.
 :
 : @return The serialized entity, as a string, suitable as content of the
 :    <code>ml:options/ml:data</code> element.
 :)
declare function http:serialize-data($body as element()?)
      as xs:string
{
   if ( $body[self::http:multipart] ) then
      let $boundary := concat('--', $body/@boundary, '&#13;&#10;')
      let $res := http:serialize-multipart($body/http:*[1], $boundary)
         return
            string-join(($res, '--', $body/@boundary, '--&#13;&#10;'), '')
   else if ( $body[self::http:body] ) then
      let $type := http:decode-content-type($body/@content-type)
         return
            if ( $type eq 'MULTIPART' ) then
               error(xs:QName('err:TODO'), 'Could not happen.')
            else if ( $type eq 'TEXT' ) then
               string($body)
            else if ( $type eq 'XML' ) then
               xdmp:quote($body/node())
            else if ( $type eq 'HTML' ) then
               (: TODO: For now, handled as XML... :)
               xdmp:quote($body/node())
            else if ( $type eq 'BINARY' ) then
               xdmp:base64-encode(string($body))
            else
               error(xs:QName('err:TODO'), 'Could not happen.')
   else
      error(xs:QName('err:TODO'), 'Could not happen.')
};

(:~
 : Implementation for MarkLogic of the EXPath HTTP Client function.
 : 
 : <p>TODO: Add additional arities.</p>
 :
 : <p>TODO: Handle authentication.</p>
 :
 : <p>TODO: Handle @override-content-type.</p>
 :
 : <p>TODO: Handle @follow-redirect.</p>
 :
 : <p>TODO: Handle @status-only.</p>
 :
 : @see http://expath.org/modules/http-client/
 :
 : @param $req The EXPath request element, as defined in the spec.
 :)
declare function http:send-request($req as element(http:request))
      as item()+
{
   let $body := $req/zero-or-one(http:multipart|http:body),
       $headers := <ml:headers> {
                      http:make-element-type($body),
                      http:make-element('content-id', $body/@id),
                      http:make-element('content-description', $body/@description),
                      (: TODO: Handle @href... :)
                      $req/http:header/element { QName('xdmp:http', @name) } { string(@value) }
                   }
                   </ml:headers>,
       $options := <ml:options> {
                      $headers,

                       if ( $req/@auth-method ne "" and $req/@username ne "" and $req/@password ne "" ) then
                      <ml:authentication method="{lower-case($req/@auth-method)}">
                        <ml:username>{$req/@username/data(.)}</ml:username>
                        <ml:password>{$req/@password/data(.)}</ml:password>
                      </ml:authentication>
                      else (),
                      if ( exists($body) ) then
                         <ml:data>{ http:serialize-data($body) }</ml:data>
                      else
                         (),
                      <ml:timeout>{ $http:timeout-seconds }</ml:timeout>
                   }
                   </ml:options>,
       $r1 := http:do-send-request($req/@href, $req/@method, $options),
       (: Follow at most one redirect.  TODO: Only 302?  And other 3xx codes? :)
       $resp := if ( xs:integer($r1[1]/ml:code) eq 302 ) then
                   http:do-send-request($r1[1]/ml:headers/ml:location, $req/@method, $options)
                else
                   $r1
      return (
         <http:response status="{ $resp[1]/ml:code }" message="{ $resp[1]/ml:message }"> {
            (:
            for $h in $resp[1]/ml:headers/* return
               <http:header name="{ local-name($h) }" value="{ string($h) }"/>,
            :)
            $resp[1]/ml:headers/*
               /<http:header name="{ local-name(.) }" value="{ string(.) }"/>,
            http:make-body($resp)
         }
         </http:response>,
         http:make-content-items($resp)
       )
};


(: ------------------------------------------------------------------------ :)
(:  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS COMMENT.               :)
(:                                                                          :)
(:  The contents of this file are subject to the Mozilla Public License     :)
(:  Version 1.0 (the "License"); you may not use this file except in        :)
(:  compliance with the License. You may obtain a copy of the License at    :)
(:  http://www.mozilla.org/MPL/.                                            :)
(:                                                                          :)
(:  Software distributed under the License is distributed on an "AS IS"     :)
(:  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.  See    :)
(:  the License for the specific language governing rights and limitations  :)
(:  under the License.                                                      :)
(:                                                                          :)
(:  The Original Code is: all this file.                                    :)
(:                                                                          :)
(:  The Initial Developer of the Original Code is Florent Georges.          :)
(:                                                                          :)
(:  Contributor(s): none.                                                   :)
(: ------------------------------------------------------------------------ :)

(: ------------------------------------------------------------------------------------- 

	std.xqm - Implements all standard xproc steps.
	
---------------------------------------------------------------------------------------- :)
xquery version "1.0-ml" encoding "UTF-8";

module namespace std = "http://xproc.net/xproc/std";

(: declare namespaces :)
declare namespace xproc = "http://xproc.net/xproc";
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";

(: module imports :)
import module namespace const = "http://xproc.net/xproc/const" at "const.xqy";
import module namespace u = "http://xproc.net/xproc/util" at "util.xqy";
declare namespace http = "http://www.expath.org/mod/http-client";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

(: declare functions :)
declare variable $std:add-attribute         := std:add-attribute#4;
declare variable $std:add-xml-base          := std:add-xml-base#4;
declare variable $std:count                 := std:count#4;
declare variable $std:compare               := std:compare#4;
declare variable $std:delete                := std:delete#4;
declare variable $std:error                 := std:error#4;
declare variable $std:filter                := std:filter#4;
declare variable $std:directory-list        := std:directory-list#4;
declare variable $std:escape-markup         := std:escape-markup#4;
declare variable $std:http-request          := ();
declare variable $std:identity              := std:identity#4;
declare variable $std:insert                := std:insert#4;
declare variable $std:label-elements        := std:label-elements#4;
declare variable $std:load                  := std:load#4;
declare variable $std:make-absolute-uris    := std:make-absolute-uris#4;
declare variable $std:namespace-rename      := std:namespace-rename#4;
declare variable $std:pack                  := std:pack#4;
declare variable $std:parameters            := ();
declare variable $std:rename                := std:rename#4;
declare variable $std:replace               := std:replace#4;
declare variable $std:set-attributes        := std:set-attributes#4;
declare variable $std:sink                  := std:sink#4;
declare variable $std:split-sequence        := std:split-sequence#4;
declare variable $std:store                 := std:store#4;
declare variable $std:string-replace        := std:string-replace#4;
declare variable $std:unescape-markup       := std:unescape-markup#4;
declare variable $std:xinclude              := std:xinclude#4;
declare variable $std:wrap                  := std:wrap#4;
declare variable $std:wrap-sequence         := std:wrap-sequence#4;
declare variable $std:unwrap                := std:unwrap#4;
declare variable $std:xslt                  := std:xslt#4;

(: -------------------------------------------------------------------------- :)
declare function std:add-attribute($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $ns := u:get-secondary('xproc:namespaces',$secondary)/*
let $match  := u:get-option('match',$options,$primary)
let $attribute-name as xs:string := u:get-option('attribute-name',$options,$primary)
let $attribute-value := u:get-option('attribute-value',$options,$primary)
let $attribute-prefix := u:get-option('attribute-prefix',$options,$primary)
let $attribute-namespace := u:get-option('attribute-namespace',$options,$primary)
let $template := <xsl:stylesheet version="2.0">
       {for $n in $ns return
       namespace {$n/@prefix} {$n/@URI}
       }
{$const:xslt-output}
{for $option in $options[@name]
return
<xsl:param name="{$option/@name}" select="{if($option/@select ne'') then string($option/@select) else concat('&quot;',$option/@value,'&quot;')}"/>
}
<xsl:template match=".">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="{$match}">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="{$attribute-name}" select="'{$attribute-value}'"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
</xsl:stylesheet>      
return
  u:transform($template,$primary)
};


(: -------------------------------------------------------------------------- :)
declare function std:add-xml-base($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
(:
let $ns := u:get-secondary('xproc:namespaces',$secondary)/*
let $all as xs:string := u:get-option('add',$options,$primary)
let $relative as xs:string := u:get-option('relative',$options,$primary)
let $template := <xsl:stylesheet version="2.0">
       {for $n in $ns return
        namespace {$n/@prefix} {$n/@URI}
       }
{$const:xslt-output}
{for $option in $options[@name]
return
<xsl:param name="{$option/@name}" select="{if($option/@select ne'') then string($option/@select) else concat('&quot;',$option/@value,'&quot;')}"/>
}
<xsl:template match=".">
<xsl:copy>
    <xsl:apply-templates/>
</xsl:copy>
</xsl:template>

<xsl:template match="node()|@*">
  <xsl:copy>
    <xsl:apply-templates select="node()|@*"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="node()">
  <xsl:copy>
    <xsl:attribute name="xml:base" select="base-uri(.)"/>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
</xsl:stylesheet>      
return
  u:transform($template,$primary)
:)
};


(: -------------------------------------------------------------------------- :)
declare function std:compare($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $alternate := u:getInputMap("!1.0#alternate")
(: let $strict := u:get-option('xproc:strict',$options,$v)  ext attribute xproc:strict:) 
let $fail-if-not-equal as xs:string := u:get-option('fail-if-not-equal',$options,$primary)
let $result := deep-equal( document{$primary}, document{$alternate})
return
  if($fail-if-not-equal eq "true") then
    if ($result) then          
      u:outputResultElement('true')
    else
      u:stepError('err:XC0019','p:compare fail-if-not-equal option is enabled and documents were not equal')
    else
      u:outputResultElement($result)
};


(: --------------------------------------------------------------------------------------- :)
declare function std:count($primary,$secondary,$options,$variables) as element(c:result){
(: --------------------------------------------------------------------------------------- :)
let $limit as xs:integer := xs:integer(u:get-option('limit',$options,$primary)) 
let $count as xs:integer := if(name($primary[1]) eq '') then count($primary/*)  else count($primary)
return
    if ($limit eq 0 or $count lt $limit ) then
      u:outputResultElement($count)
    else
      u:outputResultElement($limit)
};


(: -------------------------------------------------------------------------- :)
declare function std:delete($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
(: let $ns := u:enum-ns(<dummy>{$primary}</dummy>) :)
let $ns := u:get-secondary('xproc:namespaces',$secondary)/*

let $match  as xs:string := u:get-option('match',$options,$primary)
let $template := <xsl:stylesheet version="2.0">
       {for $n in $ns return
       namespace {$n/@prefix} {$n/@URI}
       }
{$const:xslt-output}
{for $option in $options[@name]
return
<xsl:param name="{$option/@name}" select="{if($option/@select ne'') then string($option/@select) else concat('&quot;',$option/@value,'&quot;')}"/>
}
<xsl:template match="/">
        <xsl:apply-templates select="@*|node()"/>
</xsl:template>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="{$match}"/>

</xsl:stylesheet>
return
  u:transform($template,$primary)
};


(: -------------------------------------------------------------------------- :)
declare function std:directory-list($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $path := u:get-option('path',$options,$primary)
let $include-filter := u:get-option('include-filter',$options,$primary)
let $exclude-filter := u:get-option('exclude-filter',$options,$primary)

let $segment := substring-after($path,'file://')
let $dirname := tokenize($path, '/')[last()]
let $result :=
                     let $files :=  u:dirlist($path)
                     return
                     <c:directory name="{$dirname}">
                     {for $file in $files return <c:file name="{document-uri($file)}"/>}
                     </c:directory>
  return
    u:outputResultElement($result)
};


(: -------------------------------------------------------------------------- :)
declare function std:escape-markup($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $cdata-section-elements := u:get-option('cdata-section-elements',$options,$primary)
let $doctype-public         := u:get-option('doctype-public',$options,$primary)
let $doctype-system         := u:get-option('doctype-system',$options,$primary)
let $escape-uri-attributes  := u:get-option('escape-uri-attributes',$options,$primary)
let $include-content-type   := u:get-option('include-content-type',$options,$primary)
let $indent                 := u:get-option('indent',$options,$primary)
let $media-type             := u:get-option('media-type',$options,$primary)
let $method                 := u:get-option('method',$options,$primary)
let $omit-xml-declaration   := u:get-option('omit-xml-declaration',$options,$primary)
let $standalone             := u:get-option('standalone',$options,$primary)
let $undeclare-prefixes     := u:get-option('undeclare-prefixes',$options,$primary)
let $version                := u:get-option('version',$options,$primary)
return
  u:serialize($primary) 
};


(: -------------------------------------------------------------------------- :)
declare function std:error($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $code := u:get-option('code',$options,$primary)
let $err := <c:errors>
<c:error href="" column="" offset="" name="step-name" type="p:error" code="{$code}">
  <message>{$primary}</message>
</c:error>
</c:errors>
return
  u:dynamicError('err:XD0030',concat(": p:error throw custom error code - ",$code))
};


(: -------------------------------------------------------------------------- :)
declare function std:filter($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $select := u:get-option('select',$options,$primary)
return
  try {
    u:evalXPATH($select,$primary,$options[@name])
  }
  catch * {
    u:dynamicError('err:XD0016',": p:filter did not select anything - ")
  }
};


(: -------------------------------------------------------------------------- :)
declare function std:http-request($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $byte-order-mark        := u:get-option('byte-order-mark',$options,$primary)
let $cdata-section-elements := u:get-option('cdata-section-elements',$options,$primary)
let $doctype-public         := u:get-option('doctype-public',$options,$primary)
let $doctype-system         := u:get-option('doctype-system',$options,$primary)
let $encoding               := u:get-option('encoding',$options,$primary)
let $escape-uri-attributes  := u:get-option('escape-uri-attributes',$options,$primary)
let $include-content-type   := u:get-option('include-content-type',$options,$primary)
let $indent                 := u:get-option('indent',$options,$primary)
let $media-type             := u:get-option('media-type',$options,$primary)
let $method                 := u:get-option('method',$options,$primary)
let $normalization-form     := u:get-option('normalization-form',$options,$primary)
let $omit-xml-declaration   := u:get-option('omit-xml-declaration',$options,$primary)
let $standalone             := u:get-option('standalone',$options,$primary)
let $undeclare-prefixes     := u:get-option('undeclare-prefixes',$options,$primary)
let $version                := u:get-option('version',$options,$primary)

let $href := $primary/c:request/@href
let $method := $primary/c:request/@method
let $content-type := $primary/c:request/c:body/@content-type
let $body := $primary/c:request/c:body
let $status-only := $primary/c:request/@status-only
let $detailed := $primary/c:request/@detailed
let $username := ''
let $password := ''
let $auth-method := ''
let $send-authorization := ''
let $override-content-type := ''
let $follow-redirect := ''
let $http-request := <http:request href="{$href}" method="{$method}">{
            for $header in $primary/c:request/c:header
            return
                <http:header name="{$header/@name}" value="{$header/@value}"/>,

            if (empty($body)) then
                ()
            else
              <http:body content-type="{$content-type}">
                 {$body}
              </http:body>
        }
           </http:request>
           
let $raw-response := () (: http:send-request($http-request) :)

let $response-headers := for $header in $raw-response//http:header return <c:header name="{$header/@name}" value="{$header/@value}"/>

let $response-body := if ($status-only) then
            ()
         else if ($detailed) then
            <c:body>{$raw-response/*[not(name(.) eq 'http:body')][not(name(.) eq 'http:header')]}</c:body>
         else
            $raw-response/*[not(name(.) eq 'http:body')][not(name(.) eq 'http:header')]
      
return
  if (not($primary/c:request)) then
    u:dynamicError('err:XC0040',"source port must contain c:request element")
  else if ($detailed) then
    <c:response status="{$raw-response/@status}">
      {$response-headers}
      {$response-body}
    </c:response>
  else
    $response-body
};


(: -------------------------------------------------------------------------- :)
declare function std:identity($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
$primary
};


(: -------------------------------------------------------------------------- :)
declare function std:insert($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $ns := u:get-secondary('xproc:namespaces',$secondary)/*
let $insertion := u:get-secondary('insertion',$secondary)/*
let $match     := u:get-option('match',$options,$primary)
let $position  := u:get-option('position',$options,$primary)
let $template := <xsl:stylesheet version="2.0">
       {for $n in $ns return
        namespace {$n/@prefix} {$n/@URI}
       }
{$const:xslt-output}
{for $option in $options[@name]
return
<xsl:param name="{$option/@name}" select="{if($option/@select ne'') then string($option/@select) else concat('&quot;',$option/@value,'&quot;')}"/>
}
<xsl:template match=".">
    <xsl:apply-templates/>
</xsl:template>

{
if ($position eq 'before') then

<xsl:template match="{$match}">
  {$insertion}
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

else if ($position eq 'after') then

<xsl:template match="{$match}">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
  {$insertion}
</xsl:template>

else if ($position eq 'first-child') then

<xsl:template match="{$match}[1]">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    {$insertion}
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

else

<xsl:template match="{$match}[last()]">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
    {$insertion}
  </xsl:copy>
</xsl:template>
}

<xsl:template match="@*|node()|comment()|processing-instruction()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()|comment()|processing-instruction()"/>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>      

return
  u:transform($template,$primary)
};


(: -------------------------------------------------------------------------- :)
declare function std:label-elements($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $ns := u:get-secondary('xproc:namespaces',$secondary)/*
let $match  := u:get-option('match',$options,$primary)
let $attribute  := u:get-option('attribute',$options,$primary)
let $label  := u:get-option('label',$options,$primary)
let $replace  := u:get-option('replace',$options,$primary)
let $attribute-prefix  := u:get-option('attribute-prefix',$options,$primary)
let $attribute-namespace  := u:get-option('attribute-namespace',$options,$primary)

let $template := <xsl:stylesheet version="2.0">
       {for $n in $ns return
        namespace {$n/@prefix} {$n/@URI}
       }
{$const:xslt-output}
{for $option in $options[@name]
return
<xsl:param name="{$option/@name}" select="{if($option/@select ne'') then string($option/@select) else concat('&quot;',$option/@value,'&quot;')}"/>
}
<xsl:template match=".">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="{$match}">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:choose>
      <xsl:when test="not(@{$attribute}) or 'true' = '{$replace}'">
        <xsl:attribute name="{$attribute}"><xsl:value-of select="'{$label}'"/></xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>      

return
  u:transform($template,$primary)
};


(: -------------------------------------------------------------------------- :)
declare function std:load($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $href := u:get-option('href',$options,$primary)
let $dtd-validate := u:get-option('dtd-validate',$options,$primary)
let $xproc:output-uri := u:get-option('xproc:output-uri',$options,$primary)
return
try {
    if ($xproc:output-uri eq 'true') then
      u:outputResultElement(doc($href))
    else
      doc($href)
}catch * {
  u:dynamicError('err:XC0026',"p:load option href is empty or could not load document.")
}
};


(: -------------------------------------------------------------------------- :)
declare function std:make-absolute-uris($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $ns := u:get-secondary('xproc:namespaces',$secondary)/*
let $match    := u:get-option('match',$options,$primary)
let $base-uri := u:get-option('base-uri',$options,$primary)
let $new-uri  := if ($base-uri) then <xsl:value-of select="resolve-uri('{$base-uri}', base-uri($closest-element))"/>
else <xsl:value-of select="base-uri($closest-element)"/>

let $template := <xsl:stylesheet version="2.0">
       {for $n in $ns return
        namespace {$n/@prefix} {$n/@URI}
       }
{$const:xslt-output}
{for $option in $options[@name]
return
<xsl:param name="{$option/@name}" select="{if($option/@select ne'') then string($option/@select) else concat('&quot;',$option/@value,'&quot;')}"/>
}
<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>
<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>
<xsl:template match="{$match}">
  <xsl:variable name="closest-element">
    <xsl:choose>
      <xsl:when test=". instance of element()">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:when test=". instance of attribute()">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test=". instance of element()">
      <xsl:element name="{{name(.)}}">{$new-uri}</xsl:element>
    </xsl:when>
    <xsl:when test=". instance of attribute()">
      <xsl:attribute name="{{name(.)}}">{$new-uri}</xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="." />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>      
return
  u:transform($template,$primary)
};


(: -------------------------------------------------------------------------- :)
declare function std:namespace-rename($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $ns        := u:get-secondary('xproc:namespaces',$secondary)/*
let $from      := u:get-option('from',$options,$primary)
let $to        := u:get-option('to',$options,$primary)
let $apply-to  := u:get-option('apply-to',$options,$primary)

let $element-template :=   <xsl:template match="node()">
  <xsl:choose>
  <xsl:when test="namespace-uri(.) eq '{$from}'">
    <xsl:element name="{{name()}}" namespace="{$to}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:when>
  <xsl:otherwise>
  <xsl:copy>
    <xsl:namespace name="" select="string(@targetNamespace)"/>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
  </xsl:otherwise>
  </xsl:choose>
  </xsl:template>

let $attribute-template :=   <xsl:template match="@*">
  <xsl:choose>
  <xsl:when test="namespace-uri(.) eq '{$from}'">
    <xsl:attribute name="{{name()}}" namespace="{$to}">
    <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:when>
  <xsl:otherwise>
    <xsl:attribute name="{{name()}}" namespace="{{namespace-uri()}}">
    <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:otherwise>
  </xsl:choose>
  </xsl:template>


let $template := <xsl:stylesheet version="2.0">
       {for $n in $ns return
        namespace {$n/@prefix} {$n/@URI}
       }
{$const:xslt-output}
{for $option in $options[@name]
return
<xsl:param name="{$option/@name}" select="{if($option/@select ne'') then string($option/@select) else concat('&quot;',$option/@value,'&quot;')}"/>
}
  <xsl:template match="node()|@*">
  <xsl:copy>
    <xsl:apply-templates select="node()|@*"/>
  </xsl:copy>
  </xsl:template>

{if($apply-to eq 'elements') then 
$element-template 
else if($apply-to eq 'attributes') then
$attribute-template 
else
($element-template,$attribute-template)
} 

</xsl:stylesheet>      
return
  u:transform($template,$primary)
};



(: -------------------------------------------------------------------------- :)
declare function std:pack($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $alternate := u:get-secondary('alternate',$secondary)
let $wrapper := u:get-option('wrapper',$options,$primary)
let $wrapper-prefix := u:get-option('wrapper-prefix',$options,$primary)
let $wrapper-namespace := u:get-option('wrapper-namespace',$options,$primary)

let $result := for $child at $count in $primary/*
    return
      document{
	    element {$wrapper}{
	        $child,
	        $alternate/*[$count]
	    }
      }
return
if(count($primary/*) gt 0 and count($alternate/*) gt 0) then
 $result
else if (count($primary/*) eq 0 and count($alternate/*) gt 0) then
  for $a in $alternate/*
  return
    element {$wrapper} {$a}
else if (count($primary/*) gt 0 and count($alternate/*) eq 0) then
  for $a in $primary/*
  return
    element {$wrapper} {$a}
else
()

};



(: -------------------------------------------------------------------------- :)
declare function std:parameters($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:rename($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $ns := u:get-secondary('xproc:namespaces',$secondary)/*
let $match  := u:get-option('match',$options,$primary)
let $new-name  := u:get-option('new-name',$options,$primary)
let $new-prefix  := u:get-option('new-prefix',$options,$primary)
let $new-namespace  := u:get-option('new-namespace',$options,$primary)

let $template := <xsl:stylesheet version="2.0" xmlns:p="http://www.w3.org/ns/xproc">
       {for $n in $ns return
        namespace {$n/@prefix} {$n/@URI}
       }
{$const:xslt-output}
{for $option in $options[@name]
return
<xsl:param name="{$option/@name}" select="{if($option/@select ne'') then string($option/@select) else concat('&quot;',$option/@value,'&quot;')}"/>
}
<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="{$match}">
  <xsl:choose>
    <xsl:when test=". instance of element()">
      <xsl:element name="{$new-name}">
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:when>
    <xsl:when test=". instance of attribute()">
      <xsl:attribute name="{$new-name}" select="."/>
    </xsl:when>
    <xsl:when test=". instance of processing-instruction()">
      <xsl:processing-instruction name="{$new-name}" select="."/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="." />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>      

return
  u:transform($template,$primary)
};


(: -------------------------------------------------------------------------- :)
declare function std:replace($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $ns := u:get-secondary('xproc:namespaces',$secondary)/*
let $replacement := u:get-secondary('replacement',$secondary)/*

let $match  := u:get-option('match',$options,$primary)

let $template := <xsl:stylesheet version="2.0">
       {for $n in $ns return
        namespace {$n/@prefix} {$n/@URI}
       }
{$const:xslt-output}
{for $option in $options[@name]
return
<xsl:param name="{$option/@name}" select="{if($option/@select ne'') then string($option/@select) else concat('&quot;',$option/@value,'&quot;')}"/>
}
<xsl:template match=".">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="{$match}">
  <xsl:choose>
    <xsl:when test=". instance of element()">
    {$replacement}
    </xsl:when>
    <xsl:otherwise>
       <error>err:XC0023</error>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>      

let $result :=   u:transform($template,$primary)
return
  if($result//error[. eq 'err:XC0023']) then
    u:dynamicError('err:XC0023',": p:replace cannot replace matching attribute - ")
  else 
    $result
};


(: -------------------------------------------------------------------------- :)
declare function std:set-attributes($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $ns := u:get-secondary('xproc:namespaces',$secondary)/*
let $attributes := u:get-secondary('attributes',$secondary)/*

return

let $match  := u:get-option('match',$options,$primary)

let $template := <xsl:stylesheet version="2.0">
       {for $n in $ns return
       
       if($n/@URI ne '') then namespace {$n/@prefix} {$n/@URI} else ()
       }
{$const:xslt-output}
{for $option in $options[@name]
return
<xsl:param name="{$option/@name}" select="{if($option/@select ne'') then string($option/@select) else concat('&quot;',$option/@value,'&quot;')}"/>
}

<xsl:attribute-set name="attribs">
{for $attr in $attributes/@*
return
<xsl:attribute name="{name($attr)}">{string($attr)}</xsl:attribute>}
</xsl:attribute-set>

<xsl:template match="/">
        <xsl:apply-templates select="@*|*"/>
</xsl:template>

<xsl:template match="{$match}">
<xsl:element name="{{name(.)}}" use-attribute-sets="attribs">
<xsl:apply-templates select="*"/>
</xsl:element>
</xsl:template>


</xsl:stylesheet>      
return
  u:transform($template,$primary)
};


(: -------------------------------------------------------------------------- :)
declare function std:sink($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:split-sequence($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $test         := u:get-option('test',$options,$primary)
let $initial-only := u:get-option('initial-only',$options,$primary)
return
    for $child at $count in $primary/*
    return
      try {
        if(u:evalXPATH(replace($test,'position\(\)',string($count)),document{$primary},$options[@name])) then
          $child
        else
          ()
      }
      catch * {
        u:dynamicError('err:XD0016',": p:split-sequence did not select anything - ")
      }
};


(: -------------------------------------------------------------------------- :)
declare function std:store($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $href                   := u:get-option('href',$options,$primary)
let $byte-order-mark        := u:get-option('byte-order-mark',$options,$primary)
let $cdata-section-elements := u:get-option('cdata-section-elements',$options,$primary)
let $doctype-public         := u:get-option('doctype-public',$options,$primary)
let $doctype-system         := u:get-option('doctype-system',$options,$primary)
let $escape-uri-attributes  := u:get-option('escape-uri-attributes',$options,$primary)
let $include-content-type   := u:get-option('include-content-type',$options,$primary)
let $indent                 := u:get-option('indent',$options,$primary)
let $media-type             := u:get-option('media-type',$options,$primary)
let $method                 := u:get-option('method',$options,$primary)
let $omit-xml-declaration   := u:get-option('omit-xml-declaration',$options,$primary)
let $standalone             := u:get-option('standalone',$options,$primary)
let $undeclare-prefixes     := u:get-option('undeclare-prefixes',$options,$primary)
let $version                := u:get-option('version',$options,$primary)
return
    <c:result>{u:store($href,$primary)}</c:result>
};


(: -------------------------------------------------------------------------- :)
declare function std:string-replace($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $ns := u:get-secondary('xproc:namespaces',$secondary)/*
let $match  := u:get-string-option('match',$options,$primary)
let $replace as xs:string := u:get-string-option('replace',$options,$primary) 

let $template := <xsl:stylesheet version="2.0">
       {for $n in $ns return
        namespace {$n/@prefix} {$n/@URI}
       }
{$const:xslt-output}
{for $option in $options[@name]
return
<xsl:param name="{$option/@name}" select="{if($option/@select ne'') then string($option/@select) else concat('&quot;',$option/@value,'&quot;')}"/>
}

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="{$match}">
  <xsl:choose>
    <xsl:when test=". instance of attribute()">
      <xsl:attribute name="{{name(.)}}">
        <xsl:value-of select="{$replace}"/>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test=". instance of element()">
        <xsl:value-of select="'{$replace}'"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="{$replace}"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>      

return
  u:transform($template,$primary)
};


(: -------------------------------------------------------------------------- :)
declare function std:unescape-markup($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
let $ns := u:get-secondary('xproc:namespaces',$secondary)/*

let $content-type := u:get-option('content-type',$options,$primary)
let $encoding     := u:get-option('encoding',$options,$primary)
let $charset      := u:get-option('charset',$options,$primary)
let $namespace    := u:get-option('namespace',$options,$primary)
return


  element{name(($primary/*,$primary)[1])}{
  for $n in $ns return
        namespace {$n/@prefix} {$n/@URI}
  ,
   u:parse($primary)
  }


};


(: -------------------------------------------------------------------------- :)
declare function std:xinclude($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
()

(:

let $template := <xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:xipr="http://dret.net/projects/xipr/">
	<xsl:template match="/*">
		<!-- if there is no other template handling the document element, this template initiates xinclude processing at the document element of the input document. -->
		<xsl:apply-templates select="." mode="xipr"/>

	</xsl:template>
	<xsl:template match="@* | node()" mode="xipr">
		<xsl:apply-templates select="." mode="xipr-internal">
			<!-- the sequences of included uri/xpointer values need to be initialized with the starting document of the xinclude processing (required for detecting inclusion loops). -->
			<xsl:with-param name="uri-history" select="document-uri(/)" tunnel="yes"/>
			<xsl:with-param name="xpointer-history" select="''" tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="@* | node()" mode="xipr-internal">

		<!-- this template handles all nodes which do not require xinclude processing. -->
		<xsl:copy>
			<!-- the xinclude process recursively processes the document until it finds an xinclude node. -->
			<xsl:apply-templates select="@* | node()" mode="xipr-internal"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="xi:include" mode="xipr-internal">
		<!-- the two parameters are required for detecting inclusion loops, they contain the complete history of href and xpointer attributes as sequences. -->
		<xsl:param name="uri-history" tunnel="yes"/>

		<xsl:param name="xpointer-history" tunnel="yes"/>
		<!-- REC: The children property of the xi:include element may include a single xi:fallback element; the appearance of more than one xi:fallback element, an xi:include element, or any other element from the XInclude namespace is a fatal error. -->
		<xsl:if test="count(xi:fallback) > 1 or exists(xi:include) or exists(xi:*[local-name() ne 'fallback'])">
			<xsl:sequence select="xipr:message('xi:include elements may only have no or one single xi:fallback element as their only xi:* child', 'fatal')"/>
		</xsl:if>
		<xsl:if test="not(matches(@accept, '^[&#x20;-&#x7E;]*$'))">
			<!-- SPEC: Values containing characters outside the range #x20 through #x7E must be flagged as fatal errors. -->
			<xsl:sequence select="xipr:message('accept contains illegal character(s)', 'fatal')"/>
		</xsl:if>

		<xsl:if test="not(matches(@accept-language, '^[&#x20;-&#x7E;]*$'))">
			<!-- SPEC: Values containing characters outside the range #x20 through #x7E are disallowed in HTTP headers, and must be flagged as fatal errors. -->
			<xsl:sequence select="xipr:message('accept-language contains illegal character(s)', 'fatal')"/>
		</xsl:if>
		<xsl:if test="exists(@accept)">
			<xsl:sequence select="xipr:message('XIPr does not support the accept attribute', 'info')"/>
		</xsl:if>
		<xsl:if test="exists(@accept-language)">
			<xsl:sequence select="xipr:message('XIPr does not support the accept-language attribute', 'info')"/>

		</xsl:if>
		<xsl:variable name="include-uri" select="resolve-uri(@href, document-uri(/))"/>
		<xsl:choose>
			<xsl:when test="@parse eq 'xml' or empty(@parse)">
				<!-- SPEC: This attribute is optional. When omitted, the value of "xml" is implied (even in the absence of a default value declaration). -->
				<xsl:if test="empty(@href | @xpointer)">
					<!-- SPEC: If the href attribute is absent when parse="xml", the xpointer attribute must be present. -->
					<xsl:sequence select="xipr:message('For parse=&quot;xml&quot;, at least one the href or xpointer attributes must be present', 'fatal')"/>
				</xsl:if>

				<xsl:if test="( index-of($uri-history, $include-uri ) = index-of($xpointer-history, string(@xpointer)) )">
					<!-- SPEC: When recursively processing an xi:include element, it is a fatal error to process another xi:include element with an include location and xpointer attribute value that have already been processed in the inclusion chain. -->
					<xsl:sequence select="xipr:message(concat('Recursive inclusion (same href/xpointer) of ', @href), 'fatal')"/>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="doc-available($include-uri)">
						<xsl:variable name="include-doc" select="doc($include-uri)"/>
						<xsl:choose>
							<xsl:when test="empty(@xpointer)">

								<!-- SPEC: The inclusion target might be a document information item (for instance, no specified xpointer attribute, or an XPointer specifically locating the document root.) In this case, the set of top-level included items is the children of the acquired infoset's document information item, except for the document type declaration information item child, if one exists. -->
								<xsl:for-each select="$include-doc/node()">
									<xsl:choose>
										<xsl:when test="self::*">
											<!-- for elements, copy the element and perform base uri fixup. -->
											<xsl:copy-of select="xipr:include(., $include-uri, @xpointer, $uri-history, $xpointer-history)"/>
										</xsl:when>
										<xsl:otherwise>
											<!-- copy everything else (i.e., everything which is not an element). -->

											<xsl:copy/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<!-- there is an xpointer attribute... -->
								<xsl:variable name="xpointer-node">
									<xsl:choose>

										<!-- xpointer uses a shorthand pointer (formerly known as barename), NCName regex copied from the schema for schemas. -->
										<xsl:when test="matches(@xpointer, '^[\i-[:]][\c-[:]]*$')">
											<xsl:copy-of select="xipr:include(id(@xpointer, $include-doc), $include-uri, @xpointer, $uri-history, $xpointer-history)"/>
										</xsl:when>
										<!-- xpointer uses the element() scheme; regex derived from XPointer element() scheme spec: http://www.w3.org/TR/xptr-element/#NT-ElementSchemeData (NCName regex copied from the schema for schemas). -->
										<xsl:when test="matches(@xpointer, '^element\([\i-[:]][\c-[:]]*((/[1-9][0-9]*)+)?|(/[1-9][0-9]*)+\)$')">
											<xsl:variable name="element-pointer" select="replace(@xpointer, 'element\((.*)\)', '$1')"/>
											<xsl:choose>
												<xsl:when test="not(contains($element-pointer, '/'))">

													<!-- the pointer is a simple id, which can be located using the id() function. -->
													<xsl:copy-of select="xipr:include(id($element-pointer, $include-doc), $include-uri, @xpointer, $uri-history, $xpointer-history)"/>
												</xsl:when>
												<xsl:otherwise>
													<!-- child sequence evaluation starts from the root or from an element identified by a NCName. -->
													<xsl:copy-of select="xipr:include(xipr:child-sequence( if ( starts-with($element-pointer, '/') ) then $include-doc else id(substring-before($element-pointer, '/'), $include-doc), substring-after($element-pointer, '/')), $include-uri, @xpointer, $uri-history, $xpointer-history)"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>

										<xsl:otherwise>
											<!-- xpointer uses none of the schemes covered in the preceding branches. -->
											<xsl:sequence select="xipr:message('XIPr only supports the XPointer element() scheme (skipping...)', 'warning')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="exists($xpointer-node/node())">
										<!-- xpointer evaluation returned a node. -->

										<xsl:copy-of select="$xpointer-node/node()"/>
									</xsl:when>
									<xsl:otherwise>
										<!-- the xpointer did not return a result, a message is produced and fallback processing is initiated. -->
										<xsl:sequence select="xipr:message(concat('Evaluation of xpointer ', @xpointer, ' returned nothing'), 'resource')"/>
										<xsl:call-template name="fallback"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>

						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<!-- this branch is executed when the doc-available() function returned false(), a message is produced and fallback processing is initiated. -->
						<xsl:sequence select="xipr:message(concat('Could not read document ', $include-uri), 'resource')"/>
						<xsl:call-template name="fallback"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>

			<xsl:when test="@parse eq 'text'">
				<xsl:if test="exists(@xpointer)">
					<!-- SPEC: The xpointer attribute must not be present when parse="text". -->
					<xsl:sequence select="xipr:message('The xpointer attribute is not allowed for parse=&quot;text&quot;', 'warning')"/>			
				</xsl:if>
				<xsl:choose>
					<xsl:when test="unparsed-text-available($include-uri)">
						<xsl:value-of select="if ( empty(@encoding) ) then unparsed-text($include-uri) else unparsed-text($include-uri, string(@encoding))"/>
					</xsl:when>

					<xsl:otherwise>
						<!-- this branch is executed when the unparsed-text-available() function returned false(), a message is produced and fallback processing is initiated. -->
						<xsl:sequence select="xipr:message(concat('Could not read document ', $include-uri), 'resource')"/>
						<xsl:call-template name="fallback"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<!-- SPEC: Values other than "xml" and "text" are a fatal error. -->

				<xsl:sequence select="xipr:message(concat('Unknown xi:include attribute value parse=&quot;', @parse ,'&quot;'), 'fatal')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:function name="xipr:include">
		<xsl:param name="context"/>
		<xsl:param name="include-uri"/>
		<xsl:param name="xpointer"/>
		<xsl:param name="uri-history"/>

		<xsl:param name="xpointer-history"/>
		<xsl:for-each select="$context">
			<xsl:copy>
				<xsl:attribute name="xml:base" select="$include-uri"/>
				<!-- SPEC: If an xml:base attribute information item is already present, it is replaced by the new attribute. -->
				<xsl:apply-templates select="@*[name() ne 'xml:base'] | node()" mode="xipr-internal">
					<xsl:with-param name="uri-history" select="($uri-history, $include-uri)" tunnel="yes"/>
					<xsl:with-param name="xpointer-history" select="($xpointer-history, string($xpointer))" tunnel="yes"/>
				</xsl:apply-templates>

			</xsl:copy>
		</xsl:for-each>
	</xsl:function>
	<xsl:function name="xipr:child-sequence">
		<xsl:param name="context"/>
		<xsl:param name="path"/>
		<xsl:choose>
			<!-- if this is the last path segment, return the node. -->
			<xsl:when test="not(contains($path, '/'))">

				<xsl:sequence select="$context/*[number($path)]"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- go one step along the child sequence by selecting the next node and trimming the path. -->
				<xsl:sequence select="xipr:child-sequence($context/*[number(substring-before($path, '/'))], substring-after($path, '/'))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:template name="fallback">

		<xsl:if test="exists(xi:fallback[empty(parent::xi:include)])">
			<!-- SPEC: It is a fatal error for an xi:fallback  element to appear in a document anywhere other than as the direct child of the xi:include (before inclusion processing on the contents of the element). -->
			<xsl:sequence select="xipr:message('xi:fallback is only allowed as the direct child of xi:include', 'fatal')"/>
		</xsl:if>
		<xsl:if test="exists(xi:fallback[count(xi:include) ne count(xi:*)])">
			<!-- SPEC: It is a fatal error  for the xi:fallback element to contain any elements from the XInclude namespace other than xi:include. -->
			<xsl:sequence select="xipr:message('xi:fallback may not contain other xi:* elements than xi:include', 'fatal')"/>
		</xsl:if>
		<xsl:choose>

			<xsl:when test="count(xi:fallback) = 1">
				<xsl:apply-templates select="xi:fallback/*" mode="xipr-internal"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- SPEC: It is a fatal error if there is zero or more than one xi:fallback element. -->
				<xsl:sequence select="xipr:message('No xi:fallback for resource error', 'fatal')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:function name="xipr:message">
		<xsl:param name="message"/>
		<xsl:param name="level"/>
		<xsl:choose>
			<xsl:when test="$level eq 'info'">
				<xsl:message terminate="no">
					<xsl:value-of select="concat('INFO: ', $message)"/>
				</xsl:message>
			</xsl:when>

			<xsl:when test="$level eq 'warning'">
				<xsl:message terminate="no">
					<xsl:value-of select="concat('WARNING: ', $message)"/>
				</xsl:message>
			</xsl:when>
			<xsl:when test="$level eq 'resource'">
				<xsl:message terminate="no">
					<xsl:value-of select="concat('RESOURCE ERROR: ', $message)"/>
				</xsl:message>

			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">
					<xsl:value-of select="concat('FATAL ERROR: ', $message)"/>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
</xsl:stylesheet>

return
  u:transform($template,$primary)
:)
};


(: -------------------------------------------------------------------------- :)
declare function std:wrap($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $ns := u:get-secondary('xproc:namespaces',$secondary)/*
let $match  := u:get-option('match',$options,$primary)
let $wrapper as xs:string := u:get-option('wrapper',$options,$primary)
let $wrapper-prefix as xs:string := u:get-option('wrapper-prefix',$options,$primary)
let $wrapper-namespace as xs:string := u:get-option('wrapper-namespace',$options,$primary)
let $group-adjacent as xs:string := u:get-option('group-adjacent',$options,$primary)

let $template := <xsl:stylesheet version="2.0"  xmlns:p="http://www.w3.org/ns/xproc">
       {for $n in $ns return
        namespace {$n/@prefix} {$n/@URI}
       }
{$const:xslt-output}
{for $option in $options[@name]
return
<xsl:param name="{$option/@name}" select="{if($option/@select ne'') then string($option/@select) else concat('&quot;',$option/@value,'&quot;')}"/>
}
<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="{$match}">
  <xsl:element name="{$wrapper}">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:element>
</xsl:template>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>      
return
  u:transform($template,document{$primary})
};


(: -------------------------------------------------------------------------- :)
declare function std:wrap-sequence($primary,$secondary,$options,$variables) as item()*{
(: -------------------------------------------------------------------------- :)
let $wrapper           as xs:string  := u:get-option('wrapper',$options,$primary)
let $wrapper-prefix    as xs:string  := (u:get-option('wrapper-prefix',$options,$primary),'')[1]
let $wrapper-namespace as xs:string  := u:get-option('wrapper-namespace',$options,$primary)
let $group-adjacent    as xs:string  := u:get-option('group-adjacent',$options,$primary)
return
if($primary instance of item()*) then 
for $v in $primary
return
  element {$wrapper}{
    if ($wrapper-namespace) then namespace {$wrapper-prefix} {"test"} else (),
      $v
  }
else
  element {$wrapper}{
      $primary
  }

};


(: -------------------------------------------------------------------------- :)
declare function std:unwrap($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)

let $ns := u:get-secondary('xproc:namespaces',$secondary)/*
let $match  := u:get-option('match',$options,$primary)
let $template := <xsl:stylesheet version="2.0">
       {for $n in $ns return
        namespace {$n/@prefix} {$n/@URI}
       }
{$const:xslt-output}
{for $option in $options[@name]
return
<xsl:param name="{$option/@name}" select="{if($option/@select ne'') then string($option/@select) else concat('&quot;',$option/@value,'&quot;')}"/>
}
<xsl:template match=".">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="{$match}">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>      

return
  u:transform($template,$primary)
};

(: -------------------------------------------------------------------------- :)
declare function std:xslt($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
let $stylesheet := u:get-secondary('stylesheet',$secondary)/*
return
  u:transform($stylesheet,$primary) 
};



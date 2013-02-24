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

<xsl:template match="{if (starts-with($match,'/')) then substring-after($match,'/') else $match}">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="{$attribute-name}" select="'{$attribute-value}'"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="element()">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
</xsl:template>
       
<xsl:template match="attribute()|text()|comment()|processing-instruction()">
  <xsl:copy/>
</xsl:template>
       
</xsl:stylesheet>      
return
  u:transform($template,$primary)
};


(: -------------------------------------------------------------------------- :)
declare function std:add-xml-base($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $ns := u:get-secondary('xproc:namespaces',$secondary)/*
let $template := <xsl:stylesheet version="2.0">
       {for $n in $ns return
       namespace {$n/@prefix} {$n/@URI}
       }
{$const:xslt-output}

<xsl:template match="/">
  <xsl:copy>
    <xsl:attribute name="xml:base" select="base-uri(node())"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
    
<xsl:template match="element()">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
</xsl:template>
       
<xsl:template match="attribute()|text()|comment()|processing-instruction()">
  <xsl:copy/>
</xsl:template>
       
</xsl:stylesheet>      
return
  u:transform($template,$primary)
  
};


(: -------------------------------------------------------------------------- :)
declare function std:compare($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $alternate := u:getInputMap($secondary/@step || "#alternate")
let $_ := xdmp:log($secondary)  
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
let $alternate := u:getInputMap($secondary/@step || "#alternate") 
let $wrapper := u:get-option('wrapper',$options,$primary)
let $wrapper-prefix := u:get-option('wrapper-prefix',$options,$primary)
let $wrapper-namespace := u:get-option('wrapper-namespace',$options,$primary)

return
if (count($primary/*) gt 0 and count($alternate/*) eq 0) then
  for $a in $primary/*
  return
    element {$wrapper} {$a}
else
element {$wrapper} {$primary, $alternate}

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
let $stylesheet := u:getInputMap($secondary[@port eq "stylesheet"]/@step || "#stylesheet")
return
  u:transform($stylesheet,$primary) 
};



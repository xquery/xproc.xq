xquery version "1.0-ml";


import module namespace xprocxq = "http://xproc.net/xprocxq"
  at "/xquery/xproc.xq";
import module namespace u = "http://xproc.net/xproc/util"
  at "/xquery/core/util.xqy";

declare boundary-space strip;
declare copy-namespaces no-preserve,no-inherit;


declare namespace error="http://marklogic.com/xdmp/error";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace t="http://xproc.org/ns/testsuite";
declare namespace p="http://www.w3.org/ns/xproc";

let $path := xdmp:get-request-field("path")
let $debug := xdmp:get-request-field("debug","0")
let $format := xdmp:get-request-field("format","xml")

let $results :=
    element tests{

for $uri in subsequence(cts:uri-match('*/' || $path ),1,1000)[not(contains(.,"err-"))]

let $test := fn:doc($uri)
let $pipeline := if ($test/*/t:pipeline/@href/data(.)) then
xdmp:document-get( '/Users/jfuller/Source/Webcomposite/xprocxq/src/test/tests.xproc.org/required/'||  $test/*/t:pipeline/@href/data(.) ,<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
     else $test/*/t:pipeline/*
let $source   := if($test/*/t:input[@port eq "source"]/t:document) then $test/*/t:input[@port eq "source"]/t:document/* else $test/*/t:input[@port eq "source"]/*
let $expected   :=if ($test//@error) then  $test//@error/data(.) else $test/*/t:output[@port eq "result"]/(if (t:document) then t:document/* else *)
let $bindings := for $binding in $test/*/t:input[@port ne "source"]
  return
    <binding name="{$binding/@port/data(.)}">{if ($binding/t:document) then $binding/t:document/* else $binding/*}</binding> 
let $options := ()
let $dflag := xs:integer($debug)
let $tflag :=0
return
    <test uri="{$uri}" error="{$test//@error}">
{

let $result := try{
    xprocxq:xq($pipeline,$source,$bindings,$options,(),$dflag,$tflag)
  }catch($e){
    $e
  }

let $compare := if($test//@error)
    then ()
    else deep-equal(u:strip-whitespace($expected),u:strip-whitespace($result))

return
<test-result pass="{if ($test//@error)
then $test//@error/data(.) eq $result/*:name/data(.)
else $compare}">
  <name>{if ($test/*/@error) then $result/*:name else ()}</name>
  <code>{if ($test/*/@error) then $result/*:code else ()}</code>
  <inputs>{$test/*/t:input}</inputs>
  <pipeline>{$pipeline}</pipeline>
  <source>{$source}</source>
  <result>{if($test//@error) then $result/error:name else $result}</result>
  <expected>{$expected}</expected>
</test-result>
}
</test>

}
return
let $results :=   <results total="{count($results//test)}"
    pass="{count($results//test-result[@pass eq "true"])}"
    fail="{count($results//test-result[@pass eq "false"])}">
    {$results}
  </results>
return
if ($format eq "xml")
    then (xdmp:set-response-content-type("text/xml"), $results)
    else (xdmp:set-response-content-type("text/html"),

let $xslt := <xsl:stylesheet
 xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
 xmlns:fn='http://www.w3.org/2003/05/xpath-functions'
 version="2.0" >

<xsl:output indent="yes"/>

<xsl:template match ='/'>
<html>
<body>
  <xsl:apply-templates select="results"/>
</body>
</html>
</xsl:template>

<xsl:template match="results">
total=<xsl:value-of select="@total"/> | pass=<xsl:value-of select="@pass"/> | fail=<xsl:value-of select="@fail"/>
<table border="1">
  <xsl:apply-templates select="tests/test"/>
</table>
</xsl:template>

<xsl:template match="test">
<tr>
  <td><xsl:value-of select="substring-after(@uri,'/Users/jfuller/Source/Webcomposite/xprocxq/src/test/tests.xproc.org/')"/></td>
  <xsl:apply-templates select="test-result"/>
</tr>
</xsl:template>

<xsl:template match="test-result[@pass eq 'true']">
<td style="color:green">
<xsl:apply-templates select="@pass"/>
</td>
<td>
  <textarea rows="10" cols="80">
  <xsl:copy-of select="pipeline/*"/>
</textarea>
  <textarea rows="10" cols="80">
  <xsl:copy-of select="source"/>
</textarea>
</td>

<td>
<textarea rows="10" cols="80">
  <xsl:copy-of select="result"/>
</textarea>
<textarea rows="10" cols="80">
  <xsl:copy-of select="expected"/>
</textarea>
</td>
</xsl:template>

<xsl:template match="test-result[@pass eq 'false']">
<td style="color:red">
<xsl:apply-templates select="@pass"/>
</td>
<td>
  <textarea rows="10" cols="80">
  <xsl:copy-of select="pipeline/*"/>
</textarea>
  <textarea rows="10" cols="80">
  <xsl:copy-of select="source"/>
</textarea>
</td>

<td>
<textarea rows="10" cols="80">
  <xsl:copy-of select="result"/>
</textarea>
<textarea rows="10" cols="80">
  <xsl:copy-of select="expected"/>
</textarea>
</td>
</xsl:template>

</xsl:stylesheet>
return
    xdmp:xslt-eval($xslt,$results))
  


xquery version "1.0-ml";


import module namespace xprocxq = "http://xproc.net/xprocxq" at "/xquery/xproc.xq";
import module namespace     u  = "http://xproc.net/xproc/util"   at "/xquery/core/util.xqy";

declare boundary-space strip;
declare copy-namespaces no-preserve,no-inherit;


declare namespace error="http://marklogic.com/xdmp/error";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace t="http://xproc.org/ns/testsuite"; 
declare namespace p="http://www.w3.org/ns/xproc";

let $path := xdmp:get-request-field("path")
let $debug := xdmp:get-request-field("debug","0")

let $results := 
element tests{

for $uri in subsequence(cts:uri-match('*/' || $path ),1,1000)
    
let $test := fn:doc($uri)
let $pipeline := $test/*/t:pipeline/*
let $source   := $test/*/t:input[@port eq "source"]/*
let $expected   :=$test/*/t:output[@port eq "result"]/*
let $bindings := ()
let $options := ()
let $dflag := xs:integer($debug)
let $tflag :=0
return
if(contains($uri,"viewport") or contains($uri,"for-each") or contains($uri,"choose")) then
    <test skip="true" uri="{$uri}"/>
 else   
    <test uri="{$uri}" error="{$test//@error}">
{

let $result := try{ xprocxq:xq($pipeline,$source,$bindings,$options,(),$dflag,$tflag) }catch($e){$e}

let $compare := deep-equal(u:strip-whitespace($expected),u:strip-whitespace($result[1]))
        
return
<test-result pass="{if ($test//@error) then string($test//@error) eq string($result/*:name) else $compare}">
<name>{if ($test/*/@error) then $result/*:name else ()}</name>
<code>{if ($test/*/@error) then $result/*:code else ()}</code>
<pipeline>{$pipeline}</pipeline>
<source>{$source}</source>
<result>{$result}</result>
<expected>{$expected}</expected>
</test-result>

}

</test>

}
return
(xdmp:set-response-content-type("text/xml"),
<results total="{count($results//test)}"
pass="{count($results//test-result[@pass eq "true"])}"
fail="{count($results//test-result[@pass eq "false"])}">
{$results}
</results>
)


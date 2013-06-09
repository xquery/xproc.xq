xquery version "1.0-ml";

import module namespace xprocxq = "http://xproc.net/xprocxq" at "/xquery/xproc.xq";
import module namespace     u  = "http://xproc.net/xproc/util"   at "/xquery/core/util.xqy";

declare namespace t="http://xproc.org/ns/testsuite"; 
declare namespace p="http://www.w3.org/ns/xproc";

let $results := 
element tests{

for $uri in cts:uri-match('*/optional/*.xml')
let $test := fn:doc($uri)
let $pipeline := $test/*/t:pipeline/*
let $source   :=$test/*/t:input[@port eq "source"]/*
let $bindings := ()
let $options := ()
let $dflag :=0
let $tflag :=0
return
<test uri="{$uri}">
<pipeline>{$pipeline}</pipeline>
{
try{
let $result := xprocxq:xq($pipeline,$source,$bindings,$options,(),$dflag,$tflag) 
let $compare := deep-equal(u:strip-whitespace($source),u:strip-whitespace($result))
return
<test-result pass="{$compare}"></test-result>

}catch($e){
if($test/@error) then
    <test-result pass="{$test/@error eq $e/error:name}"></test-result>
else $e        
}



}

</test>

}
return
(
"total:" || count($results//test-result),
"pass:" || count($results//test-result[@pass eq "true"]),
"fail:" || count($results//test-result[@pass eq "false"]),
$results
)


xquery version "1.0-ml";

declare boundary-space strip;
declare copy-namespaces no-preserve,no-inherit;


import module namespace xprocxq = "http://xproc.net/xprocxq" at "/xquery/xproc.xq";

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
let $compare := deep-equal(document{$source[1]},document{$result[1]})
return
<test-result pass="{$compare}"></test-result>

}catch($e){
$e
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


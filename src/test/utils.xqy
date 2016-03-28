xquery version "1.0-ml";
module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace assert = "http://github.com/robwhitby/xray/assertions"
    at "/xray/src/assertions.xqy";

import module namespace u="http://xproc.net/xproc/util"
    at "/xquery/lib/util.xqy";

import module namespace   std  = "http://xproc.net/xproc/std"
    at "/xquery/steps/std.xqy";

declare namespace xproc = "http://xproc.net/xproc";
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";

declare namespace http = "xdmp:http";

declare option xdmp:mapping "false";

declare %test:case function test-get-funcs()
{
    let $funcs := u:get-step-functions()
    return assert:equal(count($funcs),31)
};

declare %test:case function test-get-specific-funcs()
{
    let $funcs := u:get-step-functions("test:mywrap")
    return assert:equal(count($funcs),1)
};


declare %xproc:step function test:mywrap(
    $test
)
{
    <wrap>{
    $test
    }</wrap>
};
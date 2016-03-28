xquery version "1.0-ml";
module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace assert = "http://github.com/robwhitby/xray/assertions"
    at "/xray/src/assertions.xqy";

import module namespace parse = "http://xproc.net/xproc/parse"
    at "/xquery/core/parse.xqy";

import module namespace g="grammar"
    at "/xquery/core/grammar.xqy";

declare namespace http = "xdmp:http";

declare option xdmp:mapping "false";

declare variable $valid-xproc := '
xproc version = "2.0";

(: This example is from the XProc 1.0 specification (example 3). :)

inputs $source as document-node();
outputs $result as document-node();

$source => { if (xs:decimal($1/*/@version) < 2.0)
then [$1,"v1schema.xsd"] => validate-with-xml-schema() >> @1
else [$1,"v2schema.xsd"] => validate-with-xml-schema() >> @1}
=> [$1,"stylesheet.xsl"] => xslt()
>> $result';

declare %test:case function test-grammar()
{
    assert:true(g:parse-XProc($valid-xproc) instance of element(XProc))
};


declare %test:case function test-parse()
{
    assert:true(parse:parse($valid-xproc) instance of element(XProc))
};

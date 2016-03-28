xquery version "1.0-ml";
module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace assert = "http://github.com/robwhitby/xray/assertions"
    at "/xray/src/assertions.xqy";

import module namespace const = "http://xproc.net/xproc/const"
  at "/xquery/core/const.xqy";

declare namespace xproc = "http://xproc.net/xproc";
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";

declare namespace http = "xdmp:http";

declare option xdmp:mapping "false";

declare %test:case function test-system-properties()
{
  assert:equal($const:version,"2.0","xproc version"),
  assert:equal($const:product-version,"1.0","product version"),
  assert:equal($const:product-name,"xproc.xq","product name"),
  assert:equal($const:language,"en","product language"),
  assert:equal($const:vendor,"James Fuller", "product vendor"),
  assert:equal($const:vendor-uri,"http://www.xproc.net", "product uri"),
  assert:equal($const:xpath-version,"3.0","xpath version supported"),
  assert:equal($const:psvi-supported,"false","support psvi"),
  assert:true($const:episode instance of xs:unsignedLong,"episode should be instance of xs:unsignedLong")
};

declare %test:case %test:ignore function test-errors()
{
  assert:equal($const:error,"2.0")

};

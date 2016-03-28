xquery version "1.0-ml";
module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";

declare namespace http = "xdmp:http";

declare option xdmp:mapping "false";

declare %test:case function test-test()
{
  assert:equal(1,1)
};

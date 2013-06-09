xquery version "3.0";

module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";

import module namespace std = "http://xproc.net/xproc/std" at "/xquery/steps/std.xqy";

(: declare %test:case namespaces :)
declare namespace xproc = "http://xproc.net/xproc";
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";

declare %test:case function test:loadModuleTest() { 
()
};

declare %test:case function  test:testIdentity() { 
  let $actual := std:identity(<test/>,(),(),())
  return
    assert:equal($actual,document{<test></test>})
};

declare %test:case function  test:testCount() { 
  let $actual := std:count(<test/>,(),<xproc:options><p:with-option name='limit' select="'0'"/></xproc:options>,())
  return
    assert:equal($actual,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result>)
};

declare %test:case function  test:testCount2() { 
  let $input  := (<test/>,<test/>,<test/>,<test/>)
  let $actual := std:count($input,(),<xproc:options><p:with-option name='limit' select='5'/></xproc:options>,())
  return
    assert:equal($actual,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">4</c:result>)
};

declare %test:case function  test:testCount3() { 
  let $input  := (<test/>,<test/>,<test/>,<test/>)
  let $actual := std:count($input,(),<xproc:options><p:with-option name='limit' select='4'/></xproc:options>,())
  return
    assert:equal($actual,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">4</c:result>)
};

declare %test:case function  test:testCount4() { 
  let $input  := (<test/>,<test/>,<test/>,<test/>)
  let $actual := std:count($input,(),<xproc:options><p:with-option name='limit' select='2'/></xproc:options>,())
  return
    assert:equal($actual,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">2</c:result>)
};

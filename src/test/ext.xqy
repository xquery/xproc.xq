xquery version "3.0" encoding "UTF-8";

module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";
         
import module namespace ext = "http://xproc.net/xproc/ext" at "/xquery/ext.xqy";
    
declare function test:loadModuleTest() { 
  let $actual := <test/>
  return
    assert:equal($actual,<test/>) 
};

declare function test:pre() { 
  let $actual := ext:pre(<test/>,(),(),())
  return
    assert:equal($actual,<test xmlns=""></test>)
};

declare function  test:post() { 
  let $actual := ext:post(<test/>,(),(),())
  return
    assert:equal($actual,<test xmlns=""></test>)
};

declare function  test:xproc() { 
  let $actual := ext:xproc(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare function  test:xsltforms() { 
  let $actual := ext:xsltforms(<test/>,(),(),())
  return
    assert:equal($actual,())
};


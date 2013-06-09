xquery version "1.0-ml";

module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";
         
import module namespace opt = "http://xproc.net/xproc/opt" at "/xquery/steps/opt.xqy";

declare namespace error="http://marklogic.com/xdmp/error";

declare %test:case function test:loadModuleTest() { 
  let $actual := <test/>
  return
    assert:equal($actual,<test/>) 
};

declare %test:case function  test:exec() { 
  let $actual := opt:exec(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare %test:case function  test:hash() { 
  let $actual := opt:hash(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare %test:case function  test:uuid() { 
  let $actual := opt:uuid(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare %test:case function  test:www-form-urldecode() { 
  let $actual := opt:www-form-urldecode(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare %test:case function  test:www-form-urlencode() { 
  let $actual := opt:www-form-urlencode(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare %test:case function  test:validate() { 
  let $actual := opt:validate(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare %test:case function  test:xquery1() {
  let $actual := try { opt:xquery(<test/>,(),(),()) } catch ($ex) { $ex }
  return
    assert:error($actual,"xprocxq error - required query input is empty ")
};

declare %test:case function  test:xsl-formatter() { 
  let $actual := opt:xsl-formatter(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare %test:case function  test:zip() { 
  let $actual := opt:zip(<test/>,(),(),())
  return
    assert:equal($actual,    <c:result href="" command="" return-manifest="" options="" xmlns:c="http://www.w3.org/ns/xproc-step"></c:result>)
};

declare %test:case function  test:unzip() { 
  let $actual := opt:unzip(<test/>,(),(),())
  return
    assert:equal($actual,())
};

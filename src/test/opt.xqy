xquery version "3.0";

module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";
         
import module namespace opt = "http://xproc.net/xproc/opt" at "/xquery/opt.xqy";
    
declare function test:loadModuleTest() { 
  let $actual := <test/>
  return
    assert:equal($actual,<test/>) 
};

declare function  test:exec() { 
  let $actual := opt:exec(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare function  test:hash() { 
  let $actual := opt:hash(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare function  test:uuid() { 
  let $actual := opt:uuid(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare function  test:www-form-urldecode() { 
  let $actual := opt:www-form-urldecode(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare function  test:www-form-urlencode() { 
  let $actual := opt:www-form-urlencode(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare function  test:validate() { 
  let $actual := opt:validate(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare function  test:xquery() { 
  let $actual := opt:xquery(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare function  test:xsl-formatter() { 
  let $actual := opt:xsl-formatter(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare function  test:zip() { 
  let $actual := opt:zip(<test/>,(),(),())
  return
    assert:equal($actual,())
};

declare function  test:unzip() { 
  let $actual := opt:unzip(<test/>,(),(),())
  return
    assert:equal($actual,())
};

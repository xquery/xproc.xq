xquery version "3.0";

module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";

import module namespace const = "http://xproc.net/xproc/const" at "/xquery/const.xqy";

declare function test:loadModule() { 
  assert:equal($const:init_unique_id, '!1')
};

declare function test:checkVersion() { 
  assert:equal($const:version, '0.9')
};

declare function test:checkProductVersion() { 
  assert:equal($const:product-version, '0.9')
};

declare function test:checkProductVersioName() { 
  assert:equal($const:product-name, 'xprocxq')
};

declare function test:checkVendor() { 
  assert:equal($const:vendor, 'James Fuller')
};

declare function test:checkLanguage() { 
  assert:equal($const:language, 'en')
};

declare function test:checkVendorURI() { 
  assert:equal($const:vendor-uri, 'http://www.xproc.net')
};

declare function test:checkXpathVersion() { 
  assert:equal($const:xpath-version, '2.0')
};

declare function test:checkPsviSupported() { 
  assert:equal($const:psvi-supported, 'false')
};

(: missing tests for error codes :)


xquery version "1.0-ml"  encoding "UTF-8";

module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";

import module namespace xproc = "http://xproc.net/xproc" at "/xquery/core/xproc-impl.xqy";

import module namespace parse = "http://xproc.net/xproc/parse" at "/xquery/core/parse.xqy";

declare boundary-space strip;

declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace ext ="http://xproc.net/xproc/ext";
                      
declare function  test:loadModuleTest() { 
  let $actual := <test/>
  return
   assert:equal($actual,<test/>) 
};

declare function  test:parseExplicitNames() {
  
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/test.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $result   := parse:explicit-type($pipeline)
  return
    assert:equal($result,<p:declare-step version="1.0" xproc:type="comp-step" xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error">
      <p:input port="source" xproc:type="comp" xproc:func="">
	<p:inline xproc:type="comp">
	  <doc xmlns="">
Congratulations! You've run your first pipeline!
</doc>
	</p:inline>
      </p:input>
      <p:output port="result" xproc:type="comp" xproc:func=""></p:output>
      <p:group xproc:step="true" xproc:type="comp-step" xproc:func="xproc:group#4">
	<p:identity xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4"></p:identity>
      </p:group>
      <p:identity xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4">
	<p:input port="source" select="/test" xproc:type="comp" xproc:func="">
	  <p:inline xproc:type="comp">
	    <test xmlns="">test</test>
	  </p:inline>
	</p:input>
      </p:identity>
      <p:count limit="20" xproc:step="true" xproc:type="std-step" xproc:func="std:count#4">
	<p:with-option xproc:type="comp" name="limit" select="20"></p:with-option>
      </p:count>
    </p:declare-step>)
};

(:
declare function  test:parseExplicitNames1() {   
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/submit-test-report.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $result   := parse:explicit-type($pipeline)
  return
    assert:equal($result,())
};

declare function  test:parseExplicitNames2() {   
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/submit-test-report.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $result   := parse:explicit-type($pipeline)
  return
    assert:equal($result,())
};

:)
declare function  test:addParseNamespace() { 
 let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/test1.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)  
  let $result := parse:explicit-type($pipeline)
  let $r      := (for $n in distinct-values($result/descendant-or-self::*/(.|@*)/namespace-uri(.)) return if($n ne '') then $n else ())
  return
    (
    assert:equal($r[1],'http://www.w3.org/ns/xproc'),
    assert:equal( $r[2],'http://xproc.net/xproc')
    )
};

declare function  test:addParseNamespace1() { 
 let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/test1.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $result := parse:explicit-type($pipeline)
  let $r      := (for $n in distinct-values($result/descendant-or-self::*/(.|@*)/namespace-uri(.)) return if($n ne '') then $n else ())
  return
    (
    assert:equal( $r[1],'http://www.w3.org/ns/xproc'),
    assert:equal( $r[2],'http://xproc.net/xproc')
    )
};

declare function  test:testestType1() { 
  let $result   := parse:type(<p:identity/>)
  return
    assert:equal( $result, 'std-step')
};

declare function  test:testestType2() { 
  let $result   := parse:type(<p:exec/>)
  return
    assert:equal($result,'opt-step')
};

declare function  test:testestType3() { 
  let $result   := parse:type(<ext:pre/>)
  return
    assert:equal( $result, 'ext-step')
};

declare function  test:testestType4() { 
  let $result   := parse:type(<p:input/>)
  return
    assert:equal( $result, 'comp')
};

declare function  test:testestType5() { 
  let $result   := ''
  return
    assert:equal( $result, '')
};

declare function  test:testestType6() { 
  let $result   := parse:type(<p:adsfadsfasdfadsf/>)
  return
    (assert:equal( $result, 'error'))
};

declare function  test:testExplicitName() { 
 let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/submit-test-report.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $result   := parse:explicit-type($pipeline)
  return 
    assert:equal($result, <p:declare-step exclude-inline-prefixes="c cx" name="main" version="1.0" xproc:type="comp-step" xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:cx="http://xmlcalabash.com/ns/extensions" xmlns:xproc="http://xproc.net/xproc" xmlns:ext="http://xproc.net/xproc/ext" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error">
      <p:output port="result" xproc:type="comp" xproc:func=""></p:output>
      <p:option xproc:type="comp" name="host" select="'tests.xproc.org'"></p:option>
      <p:option xproc:type="comp" name="username" select="'calabash'"></p:option>
      <p:option xproc:type="comp" name="password" select="''"></p:option>
      <p:documentation xproc:type="comp" xproc:func="" xmlns="http://www.w3.org/1999/xhtml">
	<div xproc:type="error" xproc:func=""><p xproc:type="error" xproc:func=""></p><p xproc:type="error" xproc:func=""><code xproc:type="error" xproc:func=""></code><code xproc:type="error" xproc:func=""></code><code xproc:type="error" xproc:func=""></code></p><p xproc:type="error" xproc:func=""><code xproc:type="error" xproc:func=""></code><a href="http://tests.xproc.org/" xproc:type="error" xproc:func=""></a></p><p xproc:type="error" xproc:func=""><code xproc:type="error" xproc:func=""></code><code xproc:type="error" xproc:func=""></code><a href="http://tests.xproc.org/" xproc:type="error" xproc:func=""></a></p></div>
      </p:documentation>
      <p:string-replace match="uri/text()" name="patch-test-uris" xproc:step="true" xproc:type="std-step" xproc:func="std:string-replace#4">
	<p:input port="source" xproc:type="comp" xproc:func="">
	  <p:inline xproc:type="comp">
	    <test-suites xmlns="">
	<uri>/tests/required/test-suite.xml</uri>
	<uri>/tests/serialization/test-suite.xml</uri>
	<uri>/tests/optional/test-suite.xml</uri>
	<uri>/tests/extension/test-suite.xml</uri>
      </test-suites>
	  </p:inline>
	</p:input>
	<p:with-option name="replace" select="concat('concat(&quot;http://',$host,'&quot;,.)')" xproc:type="comp" xproc:func="">
	  <p:empty xproc:type="comp" xproc:func=""></p:empty>
	</p:with-option>
	<p:with-option xproc:type="comp" name="match" select="uri/text()"></p:with-option>
      </p:string-replace>
      <p:identity name="extract-uri" xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4">
	<p:input port="source" select="/*/uri" xproc:type="comp" xproc:func="">
	  <p:pipe step="patch-test-uris" port="result" xproc:type="comp" xproc:func=""></p:pipe>
	</p:input>
      </p:identity>
      <p:choose xproc:step="true" xproc:type="comp-step" xproc:func="xproc:choose#4">
	<p:xpath-context xproc:type="comp" xproc:func="">
	  <p:empty xproc:type="comp" xproc:func=""></p:empty>
	</p:xpath-context>
	<p:when test="$host = 'tests.xproc.org'" xproc:step="true" xproc:type="comp-step" xproc:func="">
	  <p:wrap-sequence wrapper="test-suites" xproc:step="true" xproc:type="std-step" xproc:func="std:wrap-sequence#4">
	    <p:input port="source" xproc:type="comp" xproc:func="">
	      <p:pipe step="extract-uri" port="result" xproc:type="comp" xproc:func=""></p:pipe>
	    </p:input>
	    <p:with-option xproc:type="comp" name="wrapper" select="test-suites"></p:with-option>
	  </p:wrap-sequence>
	  <p:with-option xproc:type="comp" name="test" select="$host = 'tests.xproc.org'"></p:with-option>
	</p:when>
	<p:otherwise xproc:step="true" xproc:type="comp-step" xproc:func="">
	  <p:wrap-sequence wrapper="test-suites" xproc:step="true" xproc:type="std-step" xproc:func="std:wrap-sequence#4">
	    <p:input port="source" xproc:type="comp" xproc:func="">
	      <p:pipe step="extract-uri" port="result" xproc:type="comp" xproc:func=""></p:pipe>
	      <p:inline xproc:type="comp">
		<uri xmlns="">http://localhost:8130/tests/test-suite.xml</uri>
	      </p:inline>
	    </p:input>
	    <p:with-option xproc:type="comp" name="wrapper" select="test-suites"></p:with-option>
	  </p:wrap-sequence>
	</p:otherwise>
      </p:choose>
      <p:exec command="/projects/src/calabash/generate-test-report" xproc:step="true" xproc:type="opt-step" xproc:func="opt:exec#4">
	<p:input port="source" xproc:type="comp" xproc:func="">
	  <p:empty xproc:type="comp" xproc:func=""></p:empty>
	</p:input>
	<p:with-option name="args" select="string-join(//uri,' ')" xproc:type="comp" xproc:func=""></p:with-option>
	<p:with-option xproc:type="comp" name="command" select="/projects/src/calabash/generate-test-report"></p:with-option>
      </p:exec>
      <p:choose xproc:step="true" xproc:type="comp-step" xproc:func="xproc:choose#4">
	<p:when test="$password = ''" xproc:step="true" xproc:type="comp-step" xproc:func="">
	  <p:identity xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4"></p:identity>
	  <p:with-option xproc:type="comp" name="test" select="$password = ''"></p:with-option>
	</p:when>
	<p:otherwise xproc:step="true" xproc:type="comp-step" xproc:func="">
	  <p:wrap wrapper="c:body" match="/" xproc:step="true" xproc:type="std-step" xproc:func="std:wrap#4">
	    <p:input port="source" select="/c:result/*" xproc:type="comp" xproc:func=""/>
	    <p:with-option xproc:type="comp" name="wrapper" select="c:body"></p:with-option>
	    <p:with-option xproc:type="comp" name="match" select="/"></p:with-option>
	  </p:wrap>
	  <p:add-attribute match="c:body" attribute-name="content-type" attribute-value="application/xml" xproc:step="true" xproc:type="std-step" xproc:func="std:add-attribute#4">
	    <p:with-option xproc:type="comp" name="match" select="c:body"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-name" select="content-type"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-value" select="application/xml"></p:with-option>
	  </p:add-attribute>
	  <p:wrap wrapper="c:request" match="/" xproc:step="true" xproc:type="std-step" xproc:func="std:wrap#4">
	    <p:with-option xproc:type="comp" name="wrapper" select="c:request"></p:with-option>
	    <p:with-option xproc:type="comp" name="match" select="/"></p:with-option>
	  </p:wrap>
	  <p:add-attribute attribute-name="password" match="/c:request" xproc:step="true" xproc:type="std-step" xproc:func="std:add-attribute#4">
	    <p:with-option name="attribute-value" select="$password" xproc:type="comp" xproc:func=""></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-name" select="password"></p:with-option>
	    <p:with-option xproc:type="comp" name="match" select="/c:request"></p:with-option>
	  </p:add-attribute>
	  <p:add-attribute attribute-name="username" match="/c:request" xproc:step="true" xproc:type="std-step" xproc:func="std:add-attribute#4">
	    <p:with-option name="attribute-value" select="$username" xproc:type="comp" xproc:func=""></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-name" select="username"></p:with-option>
	    <p:with-option xproc:type="comp" name="match" select="/c:request"></p:with-option>
	  </p:add-attribute>
	  <p:add-attribute attribute-name="href" match="/c:request" xproc:step="true" xproc:type="std-step" xproc:func="std:add-attribute#4">
	    <p:with-option name="attribute-value" select="concat('http://',$host,'/results/submit/report')" xproc:type="comp" xproc:func=""></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-name" select="href"></p:with-option>
	    <p:with-option xproc:type="comp" name="match" select="/c:request"></p:with-option>
	  </p:add-attribute>
	  <p:set-attributes match="c:request" xproc:step="true" xproc:type="std-step" xproc:func="std:set-attributes#4">
	    <p:input port="attributes" xproc:type="comp" xproc:func="">
	      <p:inline xproc:type="comp">
		<c:request method="post" auth-method="Basic" send-authorization="true"></c:request>
	      </p:inline>
	    </p:input>
	    <p:with-option xproc:type="comp" name="match" select="c:request"></p:with-option>
	  </p:set-attributes>
	  <p:http-request xproc:step="true" xproc:type="std-step" xproc:func="std:http-request#4"></p:http-request>
	</p:otherwise>
      </p:choose>
    </p:declare-step>)
};

declare function  test:testExplicitName1() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/test.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $result   := parse:explicit-name(parse:explicit-type($pipeline))
  return 
     assert:equal(document{$result},<p:declare-step version="1.0" xproc:type="comp-step" xproc:default-name="!1" xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error">
      <p:input port="source" xproc:type="comp" xproc:func="">
	<p:inline xproc:type="comp">
	  <doc xmlns="">
Congratulations! You've run your first pipeline!
</doc>
	</p:inline>
      </p:input>
      <p:output port="result" xproc:type="comp" xproc:func=""></p:output>
      <p:group xproc:step="true" xproc:type="comp-step" xproc:func="xproc:group#4" xproc:default-name="!1.1">
	<p:identity xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.1.1"></p:identity>
      </p:group>
      <p:identity xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.2">
	<p:input port="source" select="/test" xproc:type="comp" xproc:func="">
	  <p:inline xproc:type="comp">
	    <test xmlns="">test</test>
	  </p:inline>
	</p:input>
      </p:identity>
      <p:count limit="20" xproc:step="true" xproc:type="std-step" xproc:func="std:count#4" xproc:default-name="!1.3">
	<p:with-option xproc:type="comp" name="limit" select="20"></p:with-option>
      </p:count>
    </p:declare-step>
) 
};

declare function  test:testAST() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/test.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $result   := parse:AST(parse:explicit-name(parse:explicit-type($pipeline)))
  return 
     assert:equal($result, <p:declare-step version="1.0" xproc:type="comp-step" xproc:default-name="!1" xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error">
      <ext:pre xproc:default-name="!1.0" xproc:step="true" xproc:func="ext:pre#4">
	<p:input xproc:type="comp" port="source" primary="true" select="/">
	  <p:inline xproc:type="comp">
	    <doc xmlns="">
Congratulations! You've run your first pipeline!
</doc>
	  </p:inline>
	</p:input>
	<p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
      </ext:pre>
      <p:group xproc:step="true" xproc:type="comp-step" xproc:func="xproc:group#4" xproc:default-name="!1.1">
	<ext:pre xproc:default-name="!1.1.0" xproc:step="true" xproc:func="ext:pre#4">
	  <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	  <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	</ext:pre>
	<p:identity xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.1.1">
	  <p:input xproc:type="comp" port="source" sequence="true" primary="true" select="/"/>
	  <p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
	</p:identity>
      </p:group>
      <p:identity xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.2">
	<p:input xproc:type="comp" port="source" sequence="true" primary="true" select="/test">
	  <p:inline xproc:type="comp">
	    <test xmlns="">test</test>
	  </p:inline>
	</p:input>
	<p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
      </p:identity>
      <p:count limit="20" xproc:step="true" xproc:type="std-step" xproc:func="std:count#4" xproc:default-name="!1.3">
	<p:input xproc:type="comp" port="source" primary="true" sequence="true" select="/"/>
	<p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	<p:with-option xproc:type="comp" name="limit" select="20"></p:with-option>
      </p:count>
    </p:declare-step>) 
};

declare function  test:testAST1() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/submit-test-report.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $result   := parse:AST(parse:explicit-name(parse:explicit-type($pipeline)))
  return 
     assert:equal(document{$result},<p:declare-step exclude-inline-prefixes="c cx" name="main" version="1.0" xproc:type="comp-step" xproc:default-name="!1" xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns:cx="http://xmlcalabash.com/ns/extensions">
      <ext:pre xproc:default-name="!1.0" xproc:step="true" xproc:func="ext:pre#4">
	<p:input xproc:type="comp" port="source" primary="true" select="/"/>
	<p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	<p:option xproc:type="comp" name="host" value="" select="'tests.xproc.org'"></p:option>
	<p:option xproc:type="comp" name="username" value="" select="'calabash'"></p:option>
	<p:option xproc:type="comp" name="password" value="" select="''"></p:option>
      </ext:pre>
      <p:string-replace match="uri/text()" name="patch-test-uris" xproc:step="true" xproc:type="std-step" xproc:func="std:string-replace#4" xproc:default-name="!1.1">
	<p:input xproc:type="comp" port="source" primary="true" select="/">
	  <p:inline xproc:type="comp">
	    <test-suites xmlns="">    <uri>/tests/required/test-suite.xml</uri>
	      <uri>/tests/serialization/test-suite.xml</uri>
	      <uri>/tests/optional/test-suite.xml</uri>
	      <uri>/tests/extension/test-suite.xml</uri>
	    </test-suites>
	  </p:inline>
	</p:input>
	<p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	<p:with-option xproc:type="comp" name="match" select="uri/text()"></p:with-option>
	<p:with-option xproc:type="comp" name="replace" select="concat('concat(&quot;http://',$host,'&quot;,.)')"></p:with-option>
      </p:string-replace>
      <p:identity name="extract-uri" xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.2">
	<p:input xproc:type="comp" port="source" sequence="true" primary="true" select="/*/uri">
	  <p:pipe step="patch-test-uris" port="result" xproc:type="comp" xproc:func=""></p:pipe>
	</p:input>
	<p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
      </p:identity>
      <p:choose xproc:step="true" xproc:type="comp-step" xproc:func="xproc:choose#4" xproc:default-name="!1.3">
	<ext:pre xproc:default-name="!1.3.0" xproc:step="true" xproc:func="ext:pre#4">
	  <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	  <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	  <p:xpath-context xproc:type="comp" xproc:func="">
	    <p:empty xproc:type="comp" xproc:func=""></p:empty>
	  </p:xpath-context>
	</ext:pre>
	<p:when test="$host = 'tests.xproc.org'" xproc:step="true" xproc:type="comp-step" xproc:func="" xproc:default-name="!1.3.2">
	  <ext:pre xproc:default-name="!1.3.2.0" xproc:step="true" xproc:func="ext:pre#4">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	  </ext:pre>
	  <p:wrap-sequence wrapper="test-suites" xproc:step="true" xproc:type="std-step" xproc:func="std:wrap-sequence#4" xproc:default-name="!1.3.2.1">
	    <p:input xproc:type="comp" port="source" sequence="true" primary="true" select="/">
	      <p:pipe step="extract-uri" port="result" xproc:type="comp" xproc:func=""></p:pipe>
	    </p:input>
	    <p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="wrapper" select="test-suites"></p:with-option>
	    <p:with-option xproc:type="comp" name="wrapper-prefix"></p:with-option>
	    <p:with-option xproc:type="comp" name="wrapper-namespace"></p:with-option>
	    <p:with-option xproc:type="comp" name="group-adjacent"></p:with-option>
	  </p:wrap-sequence>
	</p:when>
	<p:otherwise xproc:step="true" xproc:type="comp-step" xproc:func="" xproc:default-name="!1.3.3">
	  <ext:pre xproc:default-name="!1.3.3.0" xproc:step="true" xproc:func="ext:pre#4">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	  </ext:pre>
	  <p:wrap-sequence wrapper="test-suites" xproc:step="true" xproc:type="std-step" xproc:func="std:wrap-sequence#4" xproc:default-name="!1.3.3.1">
	    <p:input xproc:type="comp" port="source" sequence="true" primary="true" select="/">
	      <p:pipe step="extract-uri" port="result" xproc:type="comp" xproc:func=""></p:pipe>
	      <p:inline xproc:type="comp">
		<uri xmlns="">http://localhost:8130/tests/test-suite.xml</uri>
	      </p:inline>
	    </p:input>
	    <p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="wrapper" select="test-suites"></p:with-option>
	    <p:with-option xproc:type="comp" name="wrapper-prefix"></p:with-option>
	    <p:with-option xproc:type="comp" name="wrapper-namespace"></p:with-option>
	    <p:with-option xproc:type="comp" name="group-adjacent"></p:with-option>
	  </p:wrap-sequence>
	</p:otherwise>
      </p:choose>
      <p:exec command="/projects/src/calabash/generate-test-report" xproc:step="true" xproc:type="opt-step" xproc:func="opt:exec#4" xproc:default-name="!1.4">
	<p:input xproc:type="comp" port="source" primary="true" sequence="true" select="/">
	  <p:empty xproc:type="comp" xproc:func=""></p:empty>
	</p:input>
	<p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	<p:output xproc:type="comp" port="errors" select="/"></p:output>
	<p:with-option xproc:type="comp" name="command" select="/projects/src/calabash/generate-test-report"></p:with-option>
	<p:with-option xproc:type="comp" name="args" select="string-join(//uri,' ')"></p:with-option>
	<p:with-option xproc:type="comp" name="cwd"></p:with-option>
	<p:with-option xproc:type="comp" name="source-is-xml" select="'true'"></p:with-option>
	<p:with-option xproc:type="comp" name="result-is-xml" select="'true'"></p:with-option>
	<p:with-option xproc:type="comp" name="wrap-result-lines" select="'false'"></p:with-option>
	<p:with-option xproc:type="comp" name="errors-is-xml" select="'false'"></p:with-option>
	<p:with-option xproc:type="comp" name="wrap-error-lines" select="'false'"></p:with-option>
	<p:with-option xproc:type="comp" name="fix-slashes" select="'false'"></p:with-option>
	<p:with-option xproc:type="comp" name="byte-order-mark"></p:with-option>
	<p:with-option xproc:type="comp" name="cdata-section-elements"></p:with-option>
	<p:with-option xproc:type="comp" name="doctype-public"></p:with-option>
	<p:with-option xproc:type="comp" name="doctype-system"></p:with-option>
	<p:with-option xproc:type="comp" name="encoding"></p:with-option>
	<p:with-option xproc:type="comp" name="escape-uri-attributes"></p:with-option>
	<p:with-option xproc:type="comp" name="include-content-type"></p:with-option>
	<p:with-option xproc:type="comp" name="indent" select="'false'"></p:with-option>
	<p:with-option xproc:type="comp" name="media-type"></p:with-option>
	<p:with-option xproc:type="comp" name="method" select="'xml'"></p:with-option>
	<p:with-option xproc:type="comp" name="normalization-form"></p:with-option>
	<p:with-option xproc:type="comp" name="omit-xml-declaration"></p:with-option>
	<p:with-option xproc:type="comp" name="standalone"></p:with-option>
	<p:with-option xproc:type="comp" name="undeclare-prefixes"></p:with-option>
	<p:with-option xproc:type="comp" name="version" select="'1.0'"></p:with-option>
      </p:exec>
      <p:choose xproc:step="true" xproc:type="comp-step" xproc:func="xproc:choose#4" xproc:default-name="!1.5">
	<ext:pre xproc:default-name="!1.5.0" xproc:step="true" xproc:func="ext:pre#4">
	  <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	  <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	</ext:pre>
	<p:when test="$password = ''" xproc:step="true" xproc:type="comp-step" xproc:func="" xproc:default-name="!1.5.1">
	  <ext:pre xproc:default-name="!1.5.1.0" xproc:step="true" xproc:func="ext:pre#4">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	  </ext:pre>
	  <p:identity xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.5.1.1">
	    <p:input xproc:type="comp" port="source" sequence="true" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
	  </p:identity>
	</p:when>
	<p:otherwise xproc:step="true" xproc:type="comp-step" xproc:func="" xproc:default-name="!1.5.2">
	  <ext:pre xproc:default-name="!1.5.2.0" xproc:step="true" xproc:func="ext:pre#4">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	  </ext:pre>
	  <p:wrap wrapper="c:body" match="/" xproc:step="true" xproc:type="std-step" xproc:func="std:wrap#4" xproc:default-name="!1.5.2.1">
	    <p:input xproc:type="comp" port="source" primary="true" select="/c:result/*"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="wrapper" select="c:body"></p:with-option>
	    <p:with-option xproc:type="comp" name="match" select="/"></p:with-option>
	    <p:with-option xproc:type="comp" name="group-adjacent"></p:with-option>
	  </p:wrap>
	  <p:add-attribute match="c:body" attribute-name="content-type" attribute-value="application/xml" xproc:step="true" xproc:type="std-step" xproc:func="std:add-attribute#4" xproc:default-name="!1.5.2.2">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="match" select="c:body"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-name" select="content-type"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-prefix"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-namespace"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-value" select="application/xml"></p:with-option>
	  </p:add-attribute>
	  <p:wrap wrapper="c:request" match="/" xproc:step="true" xproc:type="std-step" xproc:func="std:wrap#4" xproc:default-name="!1.5.2.3">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="wrapper" select="c:request"></p:with-option>
	    <p:with-option xproc:type="comp" name="match" select="/"></p:with-option>
	    <p:with-option xproc:type="comp" name="group-adjacent"></p:with-option>
	  </p:wrap>
	  <p:add-attribute attribute-name="password" match="/c:request" xproc:step="true" xproc:type="std-step" xproc:func="std:add-attribute#4" xproc:default-name="!1.5.2.4">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="match" select="/c:request"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-name" select="password"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-prefix"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-namespace"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-value" select="$password"></p:with-option>
	  </p:add-attribute>
	  <p:add-attribute attribute-name="username" match="/c:request" xproc:step="true" xproc:type="std-step" xproc:func="std:add-attribute#4" xproc:default-name="!1.5.2.5">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="match" select="/c:request"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-name" select="username"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-prefix"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-namespace"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-value" select="$username"></p:with-option>
	  </p:add-attribute>
	  <p:add-attribute attribute-name="href" match="/c:request" xproc:step="true" xproc:type="std-step" xproc:func="std:add-attribute#4" xproc:default-name="!1.5.2.6">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="match" select="/c:request"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-name" select="href"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-prefix"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-namespace"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-value" select="concat('http://',$host,'/results/submit/report')"></p:with-option>
	  </p:add-attribute>
	  <p:set-attributes match="c:request" xproc:step="true" xproc:type="std-step" xproc:func="std:set-attributes#4" xproc:default-name="!1.5.2.7">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:input xproc:type="comp" port="attributes" primary="false" select="/">
	      <p:inline xproc:type="comp">
		<c:request method="post" auth-method="Basic" send-authorization="true"></c:request>
	      </p:inline>
	    </p:input>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="match" select="c:request"></p:with-option>
	  </p:set-attributes>
	  <p:http-request xproc:step="true" xproc:type="std-step" xproc:func="std:http-request#4" xproc:default-name="!1.5.2.8">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="byte-order-mark"></p:with-option>
	    <p:with-option xproc:type="comp" name="cdata-section-elements"></p:with-option>
	    <p:with-option xproc:type="comp" name="doctype-public"></p:with-option>
	    <p:with-option xproc:type="comp" name="doctype-system"></p:with-option>
	    <p:with-option xproc:type="comp" name="encoding"></p:with-option>
	    <p:with-option xproc:type="comp" name="escape-uri-attributes"></p:with-option>
	    <p:with-option xproc:type="comp" name="include-content-type"></p:with-option>
	    <p:with-option xproc:type="comp" name="indent" select="'false'"></p:with-option>
	    <p:with-option xproc:type="comp" name="media-type"></p:with-option>
	    <p:with-option xproc:type="comp" name="method" select="'xml'"></p:with-option>
	    <p:with-option xproc:type="comp" name="normalization-form"></p:with-option>
	    <p:with-option xproc:type="comp" name="omit-xml-declaration"></p:with-option>
	    <p:with-option xproc:type="comp" name="standalone"></p:with-option>
	    <p:with-option xproc:type="comp" name="undeclare-prefixes"></p:with-option>
	    <p:with-option xproc:type="comp" name="version" select="'1.0'"></p:with-option>
	  </p:http-request>
	</p:otherwise>
      </p:choose>
    </p:declare-step>) 
};

declare function  test:testExplicitBindings1() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/test1.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $result   := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))
  return 
     assert:equal($result,<p:declare-step version="1.0" xproc:type="comp-step" xproc:default-name="!1" xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc">
      <ext:pre xproc:default-name="!1.0" xproc:step="true" xproc:func="ext:pre#4" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error">
	<p:input port="source" select="/" xproc:type="comp" primary="true">
	  <p:inline xproc:type="comp">
	    <doc xmlns="">
Congratulations! You've run your first pipeline!
</doc>
	  </p:inline>
	</p:input>
	<p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
      </ext:pre>
      <p:identity xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.1" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error">
	<p:input port="source" select="/" xproc:type="comp" primary="true">
	  <p:pipe port="result" xproc:type="comp" step="!1.0" xproc:step-name="!1.0"></p:pipe>
	</p:input>
	<p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
      </p:identity>
    </p:declare-step>) 
};

declare function  test:testExplicitBindings2() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/submit-test-report.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $result   := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))
  return 
     assert:equal($result,<p:declare-step exclude-inline-prefixes="c cx" name="main" version="1.0" xproc:type="comp-step" xproc:default-name="!1" xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc">
      <ext:pre xproc:default-name="!1.0" xproc:step="true" xproc:func="ext:pre#4" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns:cx="http://xmlcalabash.com/ns/extensions">
	<p:input port="source" select="/" xproc:type="comp" primary="true">
	  <p:pipe port="result" xproc:type="comp" step="!1" xproc:step-name="!1"></p:pipe>
	</p:input>
	<p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	<p:option xproc:type="comp" name="host" value="" select="'tests.xproc.org'"></p:option>
	<p:option xproc:type="comp" name="username" value="" select="'calabash'"></p:option>
	<p:option xproc:type="comp" name="password" value="" select="''"></p:option>
      </ext:pre>
      <p:string-replace match="uri/text()" name="patch-test-uris" xproc:step="true" xproc:type="std-step" xproc:func="std:string-replace#4" xproc:default-name="!1.1" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns:cx="http://xmlcalabash.com/ns/extensions">
	<p:input port="source" select="/" xproc:type="comp" primary="true">
	  <p:inline xproc:type="comp">
	    <test-suites xmlns="">    <uri>/tests/required/test-suite.xml</uri>
	      <uri>/tests/serialization/test-suite.xml</uri>
	      <uri>/tests/optional/test-suite.xml</uri>
	      <uri>/tests/extension/test-suite.xml</uri>
	    </test-suites>
	  </p:inline>
	</p:input>
	<p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	<p:with-option xproc:type="comp" name="match" select="uri/text()"></p:with-option>
	<p:with-option xproc:type="comp" name="replace" select="concat('concat(&quot;http://',$host,'&quot;,.)')"></p:with-option>
      </p:string-replace>
      <p:identity name="extract-uri" xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.2" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns:cx="http://xmlcalabash.com/ns/extensions">
	<p:input port="source" select="/*/uri" xproc:type="comp" primary="true">
	  <p:pipe port="result" xproc:type="comp" step="!1.1" xproc:step-name="!1.1"></p:pipe>
	</p:input>
	<p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
      </p:identity>
      <p:choose xproc:step="true" xproc:type="comp-step" xproc:func="xproc:choose#4" xproc:default-name="!1.3">
	<ext:pre xproc:default-name="!1.3.0" xproc:step="true" xproc:func="ext:pre#4" xmlns:ext="http://xproc.net/xproc/ext">
	  <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	  <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	  <p:xpath-context xproc:type="comp" xproc:func="">
	    <p:empty xproc:type="comp" xproc:func=""></p:empty>
	  </p:xpath-context>
	</ext:pre>
	<p:when test="$host = 'tests.xproc.org'" xproc:step="true" xproc:type="comp-step" xproc:func="" xproc:default-name="!1.3.2">
	  <ext:pre xproc:default-name="!1.3.2.0" xproc:step="true" xproc:func="ext:pre#4" xmlns:ext="http://xproc.net/xproc/ext">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	  </ext:pre>
	  <p:wrap-sequence wrapper="test-suites" xproc:step="true" xproc:type="std-step" xproc:func="std:wrap-sequence#4" xproc:default-name="!1.3.2.1">
	    <p:input xproc:type="comp" port="source" sequence="true" primary="true" select="/">
	      <p:pipe step="extract-uri" port="result" xproc:type="comp" xproc:func=""></p:pipe>
	    </p:input>
	    <p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="wrapper" select="test-suites"></p:with-option>
	    <p:with-option xproc:type="comp" name="wrapper-prefix"></p:with-option>
	    <p:with-option xproc:type="comp" name="wrapper-namespace"></p:with-option>
	    <p:with-option xproc:type="comp" name="group-adjacent"></p:with-option>
	  </p:wrap-sequence>
	</p:when>
	<p:otherwise xproc:step="true" xproc:type="comp-step" xproc:func="" xproc:default-name="!1.3.3">
	  <ext:pre xproc:default-name="!1.3.3.0" xproc:step="true" xproc:func="ext:pre#4" xmlns:ext="http://xproc.net/xproc/ext">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	  </ext:pre>
	  <p:wrap-sequence wrapper="test-suites" xproc:step="true" xproc:type="std-step" xproc:func="std:wrap-sequence#4" xproc:default-name="!1.3.3.1">
	    <p:input xproc:type="comp" port="source" sequence="true" primary="true" select="/">
	      <p:pipe step="extract-uri" port="result" xproc:type="comp" xproc:func=""></p:pipe>
	      <p:inline xproc:type="comp">
		<uri xmlns="">http://localhost:8130/tests/test-suite.xml</uri>
	      </p:inline>
	    </p:input>
	    <p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="wrapper" select="test-suites"></p:with-option>
	    <p:with-option xproc:type="comp" name="wrapper-prefix"></p:with-option>
	    <p:with-option xproc:type="comp" name="wrapper-namespace"></p:with-option>
	    <p:with-option xproc:type="comp" name="group-adjacent"></p:with-option>
	  </p:wrap-sequence>
	</p:otherwise>
      </p:choose>
      <p:exec command="/projects/src/calabash/generate-test-report" xproc:step="true" xproc:type="opt-step" xproc:func="opt:exec#4" xproc:default-name="!1.4" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns:cx="http://xmlcalabash.com/ns/extensions">
	<p:input port="source" select="/" xproc:type="comp" primary="true">
	  <p:empty xproc:type="comp" xproc:func=""></p:empty>
	</p:input>
	<p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	<p:output xproc:type="comp" port="errors" select="/"></p:output>
	<p:with-option xproc:type="comp" name="command" select="/projects/src/calabash/generate-test-report"></p:with-option>
	<p:with-option xproc:type="comp" name="args" select="string-join(//uri,' ')"></p:with-option>
	<p:with-option xproc:type="comp" name="cwd"></p:with-option>
	<p:with-option xproc:type="comp" name="source-is-xml" select="'true'"></p:with-option>
	<p:with-option xproc:type="comp" name="result-is-xml" select="'true'"></p:with-option>
	<p:with-option xproc:type="comp" name="wrap-result-lines" select="'false'"></p:with-option>
	<p:with-option xproc:type="comp" name="errors-is-xml" select="'false'"></p:with-option>
	<p:with-option xproc:type="comp" name="wrap-error-lines" select="'false'"></p:with-option>
	<p:with-option xproc:type="comp" name="fix-slashes" select="'false'"></p:with-option>
	<p:with-option xproc:type="comp" name="byte-order-mark"></p:with-option>
	<p:with-option xproc:type="comp" name="cdata-section-elements"></p:with-option>
	<p:with-option xproc:type="comp" name="doctype-public"></p:with-option>
	<p:with-option xproc:type="comp" name="doctype-system"></p:with-option>
	<p:with-option xproc:type="comp" name="encoding"></p:with-option>
	<p:with-option xproc:type="comp" name="escape-uri-attributes"></p:with-option>
	<p:with-option xproc:type="comp" name="include-content-type"></p:with-option>
	<p:with-option xproc:type="comp" name="indent" select="'false'"></p:with-option>
	<p:with-option xproc:type="comp" name="media-type"></p:with-option>
	<p:with-option xproc:type="comp" name="method" select="'xml'"></p:with-option>
	<p:with-option xproc:type="comp" name="normalization-form"></p:with-option>
	<p:with-option xproc:type="comp" name="omit-xml-declaration"></p:with-option>
	<p:with-option xproc:type="comp" name="standalone"></p:with-option>
	<p:with-option xproc:type="comp" name="undeclare-prefixes"></p:with-option>
	<p:with-option xproc:type="comp" name="version" select="'1.0'"></p:with-option>
      </p:exec>
      <p:choose xproc:step="true" xproc:type="comp-step" xproc:func="xproc:choose#4" xproc:default-name="!1.5">
	<ext:pre xproc:default-name="!1.5.0" xproc:step="true" xproc:func="ext:pre#4" xmlns:ext="http://xproc.net/xproc/ext">
	  <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	  <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	</ext:pre>
	<p:when test="$password = ''" xproc:step="true" xproc:type="comp-step" xproc:func="" xproc:default-name="!1.5.1">
	  <ext:pre xproc:default-name="!1.5.1.0" xproc:step="true" xproc:func="ext:pre#4" xmlns:ext="http://xproc.net/xproc/ext">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	  </ext:pre>
	  <p:identity xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.5.1.1">
	    <p:input xproc:type="comp" port="source" sequence="true" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
	  </p:identity>
	</p:when>
	<p:otherwise xproc:step="true" xproc:type="comp-step" xproc:func="" xproc:default-name="!1.5.2">
	  <ext:pre xproc:default-name="!1.5.2.0" xproc:step="true" xproc:func="ext:pre#4" xmlns:ext="http://xproc.net/xproc/ext">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	  </ext:pre>
	  <p:wrap wrapper="c:body" match="/" xproc:step="true" xproc:type="std-step" xproc:func="std:wrap#4" xproc:default-name="!1.5.2.1">
	    <p:input xproc:type="comp" port="source" primary="true" select="/c:result/*"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="wrapper" select="c:body"></p:with-option>
	    <p:with-option xproc:type="comp" name="match" select="/"></p:with-option>
	    <p:with-option xproc:type="comp" name="group-adjacent"></p:with-option>
	  </p:wrap>
	  <p:add-attribute match="c:body" attribute-name="content-type" attribute-value="application/xml" xproc:step="true" xproc:type="std-step" xproc:func="std:add-attribute#4" xproc:default-name="!1.5.2.2">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="match" select="c:body"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-name" select="content-type"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-prefix"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-namespace"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-value" select="application/xml"></p:with-option>
	  </p:add-attribute>
	  <p:wrap wrapper="c:request" match="/" xproc:step="true" xproc:type="std-step" xproc:func="std:wrap#4" xproc:default-name="!1.5.2.3">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="wrapper" select="c:request"></p:with-option>
	    <p:with-option xproc:type="comp" name="match" select="/"></p:with-option>
	    <p:with-option xproc:type="comp" name="group-adjacent"></p:with-option>
	  </p:wrap>
	  <p:add-attribute attribute-name="password" match="/c:request" xproc:step="true" xproc:type="std-step" xproc:func="std:add-attribute#4" xproc:default-name="!1.5.2.4">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="match" select="/c:request"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-name" select="password"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-prefix"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-namespace"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-value" select="$password"></p:with-option>
	  </p:add-attribute>
	  <p:add-attribute attribute-name="username" match="/c:request" xproc:step="true" xproc:type="std-step" xproc:func="std:add-attribute#4" xproc:default-name="!1.5.2.5">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="match" select="/c:request"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-name" select="username"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-prefix"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-namespace"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-value" select="$username"></p:with-option>
	  </p:add-attribute>
	  <p:add-attribute attribute-name="href" match="/c:request" xproc:step="true" xproc:type="std-step" xproc:func="std:add-attribute#4" xproc:default-name="!1.5.2.6">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="match" select="/c:request"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-name" select="href"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-prefix"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-namespace"></p:with-option>
	    <p:with-option xproc:type="comp" name="attribute-value" select="concat('http://',$host,'/results/submit/report')"></p:with-option>
	  </p:add-attribute>
	  <p:set-attributes match="c:request" xproc:step="true" xproc:type="std-step" xproc:func="std:set-attributes#4" xproc:default-name="!1.5.2.7">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:input xproc:type="comp" port="attributes" primary="false" select="/">
	      <p:inline xproc:type="comp">
		<c:request method="post" auth-method="Basic" send-authorization="true" xmlns:c="http://www.w3.org/ns/xproc-step"></c:request>
	      </p:inline>
	    </p:input>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="match" select="c:request"></p:with-option>
	  </p:set-attributes>
	  <p:http-request xproc:step="true" xproc:type="std-step" xproc:func="std:http-request#4" xproc:default-name="!1.5.2.8">
	    <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	    <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	    <p:with-option xproc:type="comp" name="byte-order-mark"></p:with-option>
	    <p:with-option xproc:type="comp" name="cdata-section-elements"></p:with-option>
	    <p:with-option xproc:type="comp" name="doctype-public"></p:with-option>
	    <p:with-option xproc:type="comp" name="doctype-system"></p:with-option>
	    <p:with-option xproc:type="comp" name="encoding"></p:with-option>
	    <p:with-option xproc:type="comp" name="escape-uri-attributes"></p:with-option>
	    <p:with-option xproc:type="comp" name="include-content-type"></p:with-option>
	    <p:with-option xproc:type="comp" name="indent" select="'false'"></p:with-option>
	    <p:with-option xproc:type="comp" name="media-type"></p:with-option>
	    <p:with-option xproc:type="comp" name="method" select="'xml'"></p:with-option>
	    <p:with-option xproc:type="comp" name="normalization-form"></p:with-option>
	    <p:with-option xproc:type="comp" name="omit-xml-declaration"></p:with-option>
	    <p:with-option xproc:type="comp" name="standalone"></p:with-option>
	    <p:with-option xproc:type="comp" name="undeclare-prefixes"></p:with-option>
	    <p:with-option xproc:type="comp" name="version" select="'1.0'"></p:with-option>
	  </p:http-request>
	</p:otherwise>
      </p:choose>
    </p:declare-step>) 
};

declare function  test:testExplicitBindings3() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/test.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $result   := parse:explicit-bindings(parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))
  return 
     assert:equal($result, <p:declare-step version="1.0" xproc:type="comp-step" xproc:default-name="!1" xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc">
      <ext:pre xproc:default-name="!1.0" xproc:step="true" xproc:func="ext:pre#4" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error">
	<p:input port="source" select="/" xproc:type="comp" primary="true">
	  <p:inline xproc:type="comp">
	    <doc xmlns="">
Congratulations! You've run your first pipeline!
</doc>
	  </p:inline>
	</p:input>
	<p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
      </ext:pre>
      <p:group xproc:step="true" xproc:type="comp-step" xproc:func="xproc:group#4" xproc:default-name="!1.1">
	<ext:pre xproc:default-name="!1.1.0" xproc:step="true" xproc:func="ext:pre#4" xmlns:ext="http://xproc.net/xproc/ext">
	  <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	  <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	</ext:pre>
	<p:identity xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.1.1">
	  <p:input xproc:type="comp" port="source" sequence="true" primary="true" select="/"/>
	  <p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
	</p:identity>
      </p:group>
      <p:identity xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.2" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error">
	<p:input port="source" select="/test" xproc:type="comp" primary="true">
	  <p:inline xproc:type="comp">
	    <test xmlns="">test</test>
	  </p:inline>
	</p:input>
	<p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
      </p:identity>
      <p:count limit="20" xproc:step="true" xproc:type="std-step" xproc:func="std:count#4" xproc:default-name="!1.3" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error">
	<p:input port="source" select="/" xproc:type="comp" primary="true">
	  <p:pipe port="result" xproc:type="comp" step="!1.2" xproc:step-name="!1.2"></p:pipe>
	</p:input>
	<p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	<p:with-option xproc:type="comp" name="limit" select="20"></p:with-option>
      </p:count>
    </p:declare-step>) 
};

declare function  test:testExplicitBindings4() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/test2.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $result   := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))    
  return 
     assert:equal($result,<p:declare-step version="1.0" name="main" xproc:type="comp-step" xproc:default-name="!1" xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc">
      <ext:pre xproc:default-name="!1.0" xproc:step="true" xproc:func="ext:pre#4" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error">
	<p:input port="source" select="/" xproc:type="comp" primary="true">
	  <p:pipe port="result" xproc:type="comp" step="!1" xproc:step-name="!1"></p:pipe>
	</p:input>
	<p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
      </ext:pre>
      <p:identity name="step1" xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.1" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error">
	<p:input port="source" select="/" xproc:type="comp" primary="true">
	  <p:pipe port="result" xproc:type="comp" step="!1.0" xproc:step-name="!1.0"></p:pipe>
	</p:input>
	<p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
      </p:identity>
      <p:identity name="step3" xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.2" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error">
	<p:input port="source" select="/" xproc:type="comp" primary="true">
	  <p:pipe port="result" xproc:type="comp" step="!1.3" xproc:step-name="!1.3"></p:pipe>
	</p:input>
	<p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
      </p:identity>
      <p:count limit="20" name="step2" xproc:step="true" xproc:type="std-step" xproc:func="std:count#4" xproc:default-name="!1.3" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error">
	<p:input port="source" select="/" xproc:type="comp" primary="true">
	  <p:pipe port="result" xproc:type="comp" step="!1.1" xproc:step-name="!1.1"></p:pipe>
	</p:input>
	<p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	<p:with-option xproc:type="comp" name="limit" select="20"></p:with-option>
      </p:count>
    </p:declare-step>)
};


declare function  test:testStepSort() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/test2.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
 let $parse      := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))
 let $b          := $parse/*
 let $expected := <go> <ext:pre xproc:default-name="!1.0" xproc:step="true" xproc:func="ext:pre#4" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns:xproc="http://xproc.net/xproc">
      <p:input port="source" select="/" xproc:type="comp" primary="true" xmlns:p="http://www.w3.org/ns/xproc">
	<p:pipe port="result" xproc:type="comp" step="!1" xproc:step-name="!1"></p:pipe>
      </p:input>
      <p:output xproc:type="comp" port="result" primary="true" select="/" xmlns:p="http://www.w3.org/ns/xproc"></p:output>
    </ext:pre>
    <p:identity name="step1" xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.1" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc">
      <p:input port="source" select="/" xproc:type="comp" primary="true">
	<p:pipe port="result" xproc:type="comp" step="!1.0" xproc:step-name="!1.0"></p:pipe>
      </p:input>
      <p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
    </p:identity>
    <p:count limit="20" name="step2" xproc:step="true" xproc:type="std-step" xproc:func="std:count#4" xproc:default-name="!1.3" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc">
      <p:input port="source" select="/" xproc:type="comp" primary="true">
	<p:pipe port="result" xproc:type="comp" step="!1.1" xproc:step-name="!1.1"></p:pipe>
      </p:input>
      <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
      <p:with-option xproc:type="comp" name="limit" select="20"></p:with-option>
    </p:count>
    <p:identity name="step3" xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.2" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc">
      <p:input port="source" select="/" xproc:type="comp" primary="true">
	<p:pipe port="result" xproc:type="comp" step="!1.3" xproc:step-name="!1.3"></p:pipe>
      </p:input>
      <p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
    </p:identity>
    <ext:post xproc:step="true" xproc:func="ext:post#4" xproc:default-name="!1!" xmlns:ext="http://xproc.net/xproc/ext" xmlns:xproc="http://xproc.net/xproc">
      <p:input port="source" primary="true" select="/" xproc:type="comp" xmlns:p="http://www.w3.org/ns/xproc">
	<p:pipe port="result" step="!1.2" xproc:step-name="!1.2"></p:pipe>
      </p:input>
      <p:output primary="true" port="result" xproc:type="comp" select="/" xmlns:p="http://www.w3.org/ns/xproc"></p:output>
    </ext:post></go>
 let $ast        := parse:pipeline-step-sort( $b, <p:declare-step version="1.0"  xproc:default-name="!1"/> )
  return 
     assert:equal($ast,$expected/*)
};


declare function  test:testStepSort1() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source"/>
  <p:output port="result"/>
 
  <p:identity name="step1"/>

  <p:count name="step3">
    <p:input port="source">
      <p:pipe step="step2" port="result"/>
    </p:input>
  </p:count>
  
  <p:identity name="step2">
    <p:input port="source">
      <p:pipe step="step1" port="result"/>
    </p:input>
  </p:identity>


  <p:identity name="step4"/>
</p:declare-step>

 let $pre    := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">{parse:pipeline-pre-step-sort( $pipeline/* , <p:declare-step version="1.0" name="main" xproc:default-name="!1"/> )}</p:declare-step>
 let $parse  := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pre))))
 let $b      := $parse/*  
  let $ast   := parse:pipeline-step-sort( $b, <p:declare-step version="1.0"  xproc:default-name="!1"/> )
  
  return 
     assert:equal((), <should>throw error - Unbound primary output: [output result on step3]</should>)
};


declare function  test:testStepSort2() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/test2.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $parse   := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pipeline/.))))
  let $result   := element p:declare-step {$parse/@*,
    namespace xproc {"http://xproc.net/xproc"},
    namespace ext {"http://xproc.net/xproc/ext"},
    namespace c {"http://www.w3.org/ns/xproc-step"},
    namespace err {"http://www.w3.org/ns/xproc-error"},
    namespace xxq-error {"http://xproc.net/xproc/error"},
    parse:pipeline-step-sort( $parse/*,  <p:declare-step version="1.0" name="main" xproc:type="comp-step" xproc:default-name="!1" xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc"/> )
    }
  return 
     assert:equal((), ())
};


declare function  test:testXProcSteps() { 
  let $pipeline :=  <p:declare-step name="main">
<p:input port="source"/><p:output port="result"/>
<p:group>
<p:identity/>
<p:count/>
</p:group>
<p:identity/>
</p:declare-step>
  let $parse   := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))
  return 
     assert:equal($parse,  <p:declare-step name="main" xproc:type="comp-step" xproc:default-name="!1" xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc">
      <ext:pre xproc:default-name="!1.0" xproc:step="true" xproc:func="ext:pre#4" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error">
	<p:input port="source" select="/" xproc:type="comp" primary="true">
	  <p:pipe port="result" xproc:type="comp" step="!1" xproc:step-name="!1"></p:pipe>
	</p:input>
	<p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
      </ext:pre>
      <p:group xproc:step="true" xproc:type="comp-step" xproc:func="xproc:group#4" xproc:default-name="!1.1">
	<ext:pre xproc:default-name="!1.1.0" xproc:step="true" xproc:func="ext:pre#4" xmlns:ext="http://xproc.net/xproc/ext">
	  <p:input xproc:type="comp" port="source" primary="true" select="/"/>
	  <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	</ext:pre>
	<p:identity xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.1.1">
	  <p:input xproc:type="comp" port="source" sequence="true" primary="true" select="/"/>
	  <p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
	</p:identity>
	<p:count xproc:step="true" xproc:type="std-step" xproc:func="std:count#4" xproc:default-name="!1.1.2">
	  <p:input xproc:type="comp" port="source" primary="true" sequence="true" select="/"/>
	  <p:output xproc:type="comp" port="result" primary="true" select="/"></p:output>
	  <p:with-option xproc:type="comp" name="limit" select="'0'"></p:with-option>
	</p:count>
      </p:group>
      <p:identity xproc:step="true" xproc:type="std-step" xproc:func="std:identity#4" xproc:default-name="!1.2" xmlns:ext="http://xproc.net/xproc/ext" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error">
	<p:input port="source" select="/" xproc:type="comp" primary="true">
	  <p:pipe port="result" xproc:type="comp" step="!1.1" xproc:step-name="!1.1"></p:pipe>
	</p:input>
	<p:output xproc:type="comp" port="result" sequence="true" primary="true" select="/"></p:output>
      </p:identity>
    </p:declare-step>)
};
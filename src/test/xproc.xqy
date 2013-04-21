xquery version "1.0-ml";

module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";

import module namespace xproc = "http://xproc.net/xproc" at "/xquery/core/xproc-impl.xqy";

import module namespace parse = "http://xproc.net/xproc/parse" at "/xquery/core/parse.xqy";

declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace ext ="http://xproc.net/xproc/ext";
declare namespace foo="http://acme.com/test";

declare namespace test1="http://test.com";
declare namespace test2="http://test2.com";

declare function  test:loadModuleTest() { 
  let $actual := <test/>
  return
    assert:equal($actual,<test/>) 
};


declare function  test:enumNSTest() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/submit-test-report.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $result := xproc:enum-namespaces($pipeline)
  return
    assert:equal($result,<namespace name="" xmlns="">
	<ns prefix="cx" URI="http://xmlcalabash.com/ns/extensions"></ns>
	<ns prefix="c" URI="http://www.w3.org/ns/xproc-step"></ns>
	<ns prefix="p" URI="http://www.w3.org/ns/xproc"></ns>
	<ns prefix="xml" URI="http://www.w3.org/XML/1998/namespace"></ns>
	<ns prefix="" URI=""></ns>
      </namespace>)
};

declare function test:runEntryPointTestForNewEvala() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:identity name="step1"/>
  <p:identity name="step2"/>
  <p:identity name="step3"/>
  <p:identity name="step4"/>
</p:declare-step>
  let $stdin    := (<root>text</root>,<root/>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $result   := xproc:run($pipeline,$stdin,$bindings,$options,(),$dflag,$tflag)
  return
    assert:equal($result/*,$stdin)
};


declare function test:runEntryPointTestForNewEval1() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:identity name="step1"/>
  <p:identity name="step2"/>
  <p:identity name="step3"/>
  <p:count name="step5"/>
  <p:identity name="step3"/>
</p:declare-step>
  let $stdin    := (<a>adfasdf</a>,<root>text</root>,<root/>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $result   := xproc:run($pipeline,$stdin,$bindings,$options,(),$dflag,$tflag)
  return
    assert:equal($result/*,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">3</c:result>)
};


declare function test:runEntryPointTestForNewEval2() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:identity name="step1"/>
  <p:identity name="step2"/>
  <p:identity name="step3"/>
</p:declare-step>
  let $stdin    := (<a>adfasdf</a>,<root>text</root>,<root/>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $result   := xproc:run($pipeline,$stdin,$bindings,$options,(),$dflag,$tflag)
  return
    assert:equal($result/*,(<a>adfasdf</a>,<root>text</root>,<root/>))
};


(:
declare function test:runEntryPointTestForNewEval3() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:identity name="step1"/>
  <p:count name="step2"/>
  <p:identity name="step3">
    <p:input port="source">
      <p:pipe step="step1" port="result"/>
    </p:input>
  </p:identity>
</p:declare-step>
  let $stdin    := (<a>adfasdf</a>,<root>text</root>,<root/>)
  let $dflag    := 1
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $result   := xproc:run($pipeline,$stdin,$bindings,$options,(),$dflag,$tflag)
  return
    assert:equal((),<should>throw error Unbound primary output: [output result on step2]</should>)
};
:)


declare function  test:runEntryPointTest() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/test2.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $stdin    := <root>text</root>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $result   := xproc:run($pipeline,$stdin,$bindings,$options,(),$dflag,$tflag)
  return
    assert:equal($result/*,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result>)
};


declare function  test:runEntryPointTest1() { 
  let $pipeline :=  xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/simple.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $stdin    := ()
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $result   := xproc:run($pipeline,$stdin,$bindings,$options,(),$dflag,$tflag)
  return
    assert:equal($result/*,())
};

declare function  test:runEntryPointTest2() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/test2.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $stdin    := (<test/>,<test/>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,(),$dflag,$tflag)
  return
    assert:equal($result/*,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">2</c:result>)

};

declare function test:runEntryPointTest3() { 
  let $pipeline :=  xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/test2.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $stdin    := ()
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,(),$dflag,$tflag)
    return
      assert:equal($result/*,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">0</c:result>)
};


declare function  test:runEntryPointTest4() { 
  let $pipeline := <p:declare-step name="main">
<p:input port="source"/><p:output port="result"/>
<p:identity/><p:count/></p:declare-step>
  let $stdin    := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result>)
};

declare function  test:runDynamicError() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/error.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $stdin    := <test/>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := try {$xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag) } catch($e) {$e//error:code}
  return
      assert:equal($result,<error:code xmlns:error="http://marklogic.com/xdmp/error">err:XD0030: XProc Dynamic Error - : p:error throw custom error code - 999999 It is a dynamic error if a step is unable or incapable of performing its function.
</error:code>)
};


declare function  test:runComplexSingleBranch() { 
  let $pipeline :=  xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/complex-single-branch.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $stdin    := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $output   := ()
  let $result := $xproc:run-step($pipeline,$stdin,$bindings,$options,$output,$dflag,$tflag)
  return
  assert:equal($result,<packed xmlns="">
	<newwrapper xmlns:p="http://www.w3.org/ns/xproc"></newwrapper>
	<a xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc" xmlns:ext="http://xproc.net/xproc/ext" xmlns:opt="http://xproc.net/xproc/opt" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:xprocerr="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns:err="http://www.w3.org/ns/xproc-error">test</a>
      </packed>)
};


declare function  test:inlineIdentity() { 
  let $pipeline := <p:declare-step name="main" version="1.0" xmlns:p="http://www.w3.org/ns/xproc">
<p:input port="source"/>
<p:output port="result"/>
<p:identity><p:input port="source"><p:inline><test/></p:inline></p:input></p:identity>
<p:identity/>
</p:declare-step>
  let $stdin    := (<a/>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag) 
    return
      assert:equal($result, document{<test xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc" xmlns:ext="http://xproc.net/xproc/ext" xmlns:opt="http://xproc.net/xproc/opt" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:xprocerr="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns=""></test>})
      
};

declare function  test:runGroup() { 
  let $pipeline := <p:declare-step name="main">
<p:input port="source"/><p:output port="result"/>
<p:group>
<p:identity/>
<p:count/>
</p:group>
<p:identity/></p:declare-step>
  let $stdin    := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag) 
    return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result>)
      
};

declare function  test:runTryCatch() { 
  let $pipeline := <p:declare-step name="main">
<p:input port="source"/>
<p:output port="result"/>
<p:try>
  <p:wrap wrapper="trywrap" match="/"/>
<p:catch>
  <p:wrap wrapper="catchwrap" match="/"/>
</p:catch>
</p:try>
<p:identity/>
</p:declare-step>
  let $stdin    := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
  return
  assert:equal($result,document{<trywrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<c>aaa<a id="1">
	    <b id="2">test</b>
	  </a></c>
      </trywrap>})
};


declare function  test:runTryCatch1() { 
  let $pipeline := <p:declare-step name="main">
<p:input port="source"/>
<p:output port="result"/>
<p:try>
  <p:wrap wrapper="trywrap" match="" adfadfa=""/> <!-- throw error //-->
<p:catch>
  <p:wrap wrapper="catchwrap" match="/"/>
</p:catch>
</p:try>
<p:identity/>
</p:declare-step>
  let $stdin    := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
  return
  assert:equal($result,document{<catchwrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<c>aaa<a id="1">
	    <b id="2">test</b>
	  </a></c>
      </catchwrap>})
};


declare function  test:runForEach1() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
<p:input port="source"/>
  <p:output port="result" sequence="true"/>
<p:for-each>
<p:iteration-source select="/c/a"/>
<p:wrap wrapper="wrap" match="/"/>
</p:for-each>
</p:declare-step>
  let $stdin    := <c><a>1</a><a>2</a><a>3</a><a>4</a><a>5</a><a>6</a><a>7</a><a>8</a><a>9</a><b>10</b></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
  return
     assert:equal(document{$result},document{(<wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>1</a>
      </wrap>,
      <wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>2</a>
      </wrap>,
      <wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>3</a>
      </wrap>,
      <wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>4</a>
      </wrap>,
      <wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>5</a>
      </wrap>,
      <wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>6</a>
      </wrap>,
      <wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>7</a>
      </wrap>,
      <wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>8</a>
      </wrap>,
      <wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>9</a>
      </wrap>)})
};


declare function  test:runForEach2() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
<p:input port="source"/>
  <p:output port="result" sequence="true"/>
<p:for-each>
<p:iteration-source select="/c/a"/>
<p:wrap wrapper="wrap" match="/"/>
</p:for-each>
</p:declare-step>
  let $stdin    := <c><a>1</a><a>2</a><a>3</a><a>4</a><a>5</a><a>6</a><a>7</a><a>8</a><a>9</a><b>10</b></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
  return
     assert:equal(document{$result},document{(<wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>1</a>
      </wrap>,
      <wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>2</a>
      </wrap>,
      <wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>3</a>
      </wrap>,
      <wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>4</a>
      </wrap>,
      <wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>5</a>
      </wrap>,
      <wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>6</a>
      </wrap>,
      <wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>7</a>
      </wrap>,
      <wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>8</a>
      </wrap>,
      <wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
	<a>9</a>
      </wrap>)})
};



declare function  test:runIdentity() { 
  let $pipeline := <p:declare-step version="1.0" xmlns:p="http://www.w3.org/ns/xproc" name="main">

    <p:identity>
      <p:input port="source">
        <p:inline><foo/></p:inline>
      </p:input>
    </p:identity>

</p:declare-step>

  let $stdin    := ()
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
 let $result := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
  return
     assert:equal($result,document{<test/>})
};


declare function  test:runViewPort() { 
  let $pipeline := <p:declare-step version="1.0" xmlns:p="http://www.w3.org/ns/xproc" name="main">
<p:input port="source" sequence="true">
<p:inline>
<doc>
<para>Some paragraph.</para>
<para>Some paragraph.</para>
<para>Some paragraph.</para>
<para>
<para>Nested paragraph.</para>
</para>
</doc>
</p:inline>
</p:input>
<p:output port="result" sequence="true" />

<p:viewport match="para" name="step1">
<p:identity name="step2">
<p:input port="source">
<p:inline><foo/></p:inline>
</p:input>
</p:identity>
</p:viewport>

</p:declare-step>

  let $stdin    := ()
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
 let $result := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
  return
     assert:equal($result,document{<doc xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc" xmlns:ext="http://xproc.net/xproc/ext" xmlns:opt="http://xproc.net/xproc/opt" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:xprocerr="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns="">
	<foo></foo>
	<foo></foo>
	<foo></foo>
	<foo></foo>
      </doc>})
};


declare function  test:runChoose1() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:choose>
    <p:xpath-context>
      <p:pipe step="main" port="source"/>
    </p:xpath-context>
    <p:when test="count(//*) gt 1">
    <p:identity><p:input port="source"><p:inline><result>greater then 2 </result></p:inline></p:input></p:identity>
    </p:when>
    <p:otherwise>
    <p:identity><p:input port="source"><p:inline><result>less then 2</result></p:inline></p:input></p:identity>
  </p:otherwise>
  </p:choose>
</p:declare-step>
  let $stdin    := (<a>afdsfsadf<b/><c/><c>test1</c></a>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result, document{<result xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc" xmlns:ext="http://xproc.net/xproc/ext" xmlns:opt="http://xproc.net/xproc/opt" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:xprocerr="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns="">greater then 2</result>})
};


declare function  test:runChoose2() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:choose>
    <p:xpath-context>
      <p:pipe step="main" port="source"/>
    </p:xpath-context>
    <p:when test="count(.) gt 4">
    <p:identity><p:input port="source"><p:inline><result>greater then 2 </result></p:inline></p:input></p:identity>
    </p:when>
    <p:otherwise>
    <p:identity><p:input port="source"><p:inline><result>less then 2</result></p:inline></p:input></p:identity>
  </p:otherwise>
  </p:choose>
</p:declare-step>
  let $stdin    := <c><a>test1</a><a>test2</a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result,document{<result xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc" xmlns:ext="http://xproc.net/xproc/ext" xmlns:opt="http://xproc.net/xproc/opt" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:xprocerr="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns="">less then 2</result>})
};


declare function  test:runChoose3() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:choose>
    <p:xpath-context>
      <p:pipe step="main" port="source"/>
    </p:xpath-context>
    <p:when test="count(//*) gt 2">
    <p:identity><p:input port="source"><p:inline><result>greater then 2 </result></p:inline></p:input></p:identity>
    </p:when>
    <p:when test="count(//*) eq 2">
    <p:identity><p:input port="source"><p:inline><result>equal 2 </result></p:inline></p:input></p:identity>
    </p:when>
    <p:otherwise>
    <p:identity><p:input port="source"><p:inline><result>less then 2</result></p:inline></p:input></p:identity>
  </p:otherwise>
  </p:choose>
</p:declare-step>
  let $stdin    := <a><b/><c/></a>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result,document{<result xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc" xmlns:ext="http://xproc.net/xproc/ext" xmlns:opt="http://xproc.net/xproc/opt" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:xprocerr="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns="">equal 2</result>})
};


declare function  test:runCompare1() { 
  let $pipeline := <p:pipeline version='1.0' name="main"
	    xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source" primary="true"/>
  <p:input port="alternate" primary="false">
    <p:inline>
      <c><a>test1</a><a>test2</a></c>
    </p:inline>
  </p:input>

  <p:output port="result" primary="true"/>

  <p:compare name="compare">
    <p:input port="source">
      <p:pipe step="main" port="source"/>
    </p:input>
    <p:input port="alternate">
      <p:pipe step="main" port="alternate"/>
    </p:input>
  </p:compare>
</p:pipeline>

  let $stdin    := <c><a>test1</a><a>test2</a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">true</c:result>)    
};


declare function  test:runCompare2() { 
  let $pipeline := <p:pipeline version='1.0' name="main"
	    xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source" primary="true"/>
  <p:input port="alternate" primary="false">
    <p:inline>
      <c>here2<a/></c>
    </p:inline>
  </p:input>

  <p:output port="result" primary="true"/>

  <p:compare name="compare">
    <p:input port="source">
      <p:pipe step="main" port="source"/>
    </p:input>
    <p:input port="alternate">
      <p:pipe step="main" port="alternate"/>
    </p:input>
  </p:compare>
</p:pipeline>

  let $stdin    := <c>here2<a/></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">true</c:result>)    
};


declare function  test:runCompare3() { 
  let $pipeline := <p:pipeline version='1.0' name="main"
	    xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source" primary="true"/>
  <p:input port="alternate" primary="false">
    <p:inline>
      <c>here2<a/></c>
    </p:inline>
  </p:input>

  <p:output port="result" primary="true"/>

  <p:compare name="compare">
    <p:input port="source">
      <p:pipe step="main" port="source"/>
    </p:input>
    <p:input port="alternate">
      <p:pipe step="main" port="alternate"/>
    </p:input>
  </p:compare>
</p:pipeline>

  let $stdin    := <c>here1<a/></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">false</c:result>)    
};

declare function  test:runCount1() { 
  let $pipeline :=   <p:declare-step version='1.0'>
    <p:input port="source" sequence="true"/>
    <p:output port="result"/>

    <p:count/>

  </p:declare-step>

  let $stdin    :=  (<document>
    <doc xmlns=""/>
  </document>,
  <document>
    <doc xmlns=""/>
  </document>,
  <document>
    <doc xmlns=""/>
  </document>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   :=  ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">3</c:result>)    
};



declare function  test:runCount2() { 
  let $pipeline :=     <p:declare-step version='1.0'>
    <p:input port="source" sequence="true"/>
    <p:output port="result"/>
    <p:count>
        <p:input port="source" select="/node()"/>
    </p:count>
  </p:declare-step>

  let $stdin    :=  <doc>
    <p>This is a para</p>
    <p>This is a para</p>
    <p>This is a para</p>
    <p>This is a para</p>
    <p>This is a para</p>
</doc>

  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   :=  ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
  return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result>)
};


declare function  test:runDelete1() { 
  let $pipeline := <pipeline version='1.0' name="pipeline" xmlns="http://www.w3.org/ns/xproc">

<delete match="p:delete"/>

</pipeline>


  let $stdin    := <pipeline name="pipeline" xmlns="http://www.w3.org/ns/xproc">

<delete>
  <option name="target" value="delete"/>
</delete>

</pipeline>

  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   :=  ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result,<pipeline name="pipeline" xmlns="http://www.w3.org/ns/xproc">
      </pipeline>)    
};



declare function  test:runPack1() { 
  let $pipeline := <p:declare-step version='1.0' name="pipeline"
	    xmlns:p="http://www.w3.org/ns/xproc">
<p:input port="source" sequence="true"/>
    <p:input port="alt" sequence="true">
    <p:inline><root>inline alt</root></p:inline>
    </p:input>
<p:output port="result"/>

<p:pack wrapper="wrapper">
  <p:input port="source">
    <p:pipe step="pipeline" port="source"/>
  </p:input>
  <p:input port="alternate">
    <p:pipe step="pipeline" port="alt"/>
  </p:input>
</p:pack>

<p:wrap-sequence wrapper="sequence-wrapper"/>

</p:declare-step>
  let $stdin    := (<doc1/>,<doc2/>,<doc3/>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := <xproc:output port="alt" port-type="external" xproc:default-name="!1" step="!1">{
    (<doc-a/>,<doc-b/>,<doc-c/>)
}</xproc:output> 
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result,<sequence-wrapper xmlns:xs="" xmlns:xsi="" xmlns:map="" xmlns:xproc="" xmlns="">
		  <wrapper>
		    <doc1></doc1>
		    <doc2></doc2>
		    <doc3></doc3>
		    <root xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc" xmlns:ext="http://xproc.net/xproc/ext" xmlns:opt="http://xproc.net/xproc/opt" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:xprocerr="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns:err="http://www.w3.org/ns/xproc-error">inline alt</root>
		  </wrapper>
		</sequence-wrapper>)
};


declare function  test:runDeclareStep1() { 
  let $pipeline := <p:declare-step version='1.0' xmlns:foo="http://acme.com/test">
      <p:input port="source" sequence="true"/>
      <p:output port="result"/>
      <p:declare-step type="foo:test">
        <p:input port="source" sequence="true"/>
        <p:output port="result"/>
        <p:count/>
      </p:declare-step>
      <foo:test/>
    </p:declare-step>

  let $stdin    := (<doc/>,<doc/>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result,())
};

(:
declare function  test:runRename1() { 
  let $pipeline := 
    <p:pipeline version='1.0'  xmlns:test1="http://test.com" xmlns:test2="http://test2.com">

      <p:rename match="@test1:foo" new-name="test2:bar"
                xmlns:test1="http://test.com" xmlns:test2="http://test2.com"/>

    </p:pipeline>

  let $stdin    := <doc test1:foo="value" xmlns:test1="http://test.com"/>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result,(<doc xmlns=""></doc>,<doc xmlns=""></doc>))
};
:)
(:)
declare function  test:runExtest1() { 
  let $pipeline := 
    <p:pipeline version='1.0'>

      <ext:xproc>
      <p:input port="pipeline">
      <p:inline>
        <p:pipeline version='1.0'>
          <p:identity/>
          <p:count/>
        </p:pipeline>
      </p:inline>
      </p:input>
      </ext:xproc>

    </p:pipeline>

  let $stdin    := (<doc test:foo="value" xmlns:test="http://test.com"/>,<test/>,1)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">3</c:result>)    
};
:)


declare function  test:runAddAttribute1() { 
  let $pipeline := 
  <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
	    <p:input port="source"/>
	    <p:output port="result"/>
	    <p:add-attribute attribute-name="gender" attribute-value="Male" match="/people/person"/>
	</p:declare-step>

  let $stdin    := <people><person/><person/></people>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result,document{<people xmlns="">
	<person gender="Male"></person>
	<person gender="Male"></person>
      </people>})    
};

declare function  test:runAddAttribute2() { 
  let $pipeline := 
  <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
	    <p:input port="source"/>
	    <p:output port="result"/>
	    <p:add-attribute attribute-name="gender" attribute-value="Male" match="person"/>
	</p:declare-step>

  let $stdin    := <people><person/><person/></people>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result,document{<people xmlns="">
	<person gender="Male"></person>
	<person gender="Male"></person>
      </people>})    
};


(:

declare function  test:runAddXMLBase() { 
  let $pipeline :=
    <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
	   <p:input port="source">
	      <p:document href="file:///Users/jfuller/Source/Webcomposite/xproc.xq/src/test/data/people.xml"/>
	   </p:input>
	   <p:output port="result"/>
	   <p:add-xml-base/>
	   <p:identity/>
	</p:declare-step>
  let $stdin    := ()
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result,document{<people xml:base="file:///Users/jfuller/Source/Webcomposite/xproc.xq/src/test/data/people.xml"><person/><person/></people>})    
};

:)


declare function  test:runPack2() { 
  let $pipeline :=
    <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
      <p:input port="source"/>
      <p:output port="result"/>
      <p:pack wrapper="NewFilmElement">
        <p:input port="alternate">
          <p:inline><b>asdfsdaF</b></p:inline>
        </p:input>
   </p:pack>
</p:declare-step>

  let $stdin    := <people><person/><person/></people>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
    return
      assert:equal($result,<NewFilmElement><people><person/><person/></people><b xmlns:c="http://www.w3.org/ns/xproc-step">asdfsdaF</b></NewFilmElement>)
};


declare function  test:runXSLT1() { 
  let $pipeline :=
    <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
      <p:input port="source"/>
      <p:output port="result"/>
      <p:xslt>
      <p:input port="stylesheet">
      <p:inline>
        <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  version="2.0">
          <xsl:template match="node()">
            <html>
              <body>
                <h1>Film list</h1>
                <ul>
                  <xsl:apply-templates select="//title"/>
                </ul>
              </body>
            </html>
          </xsl:template>
          <xsl:template match="title">
            <li>
              <xsl:value-of select="node()"/>
            </li>
          </xsl:template>
        </xsl:stylesheet>
      </p:inline>
      </p:input>
      <p:input port="parameters">
         <p:empty/>
      </p:input>
   </p:xslt>
</p:declare-step>
  let $stdin    := <films><title>One who did not fly</title><title>Great Unexpectations</title></films>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
  return
    assert:equal($result,document{<html xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc" xmlns:ext="http://xproc.net/xproc/ext" xmlns:opt="http://xproc.net/xproc/opt" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:xprocerr="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns="">
	<body>
	  <h1>Film list</h1>
	  <ul>
	    <li>One who did not fly</li>
	    <li>Great Unexpectations</li>
	  </ul>
	</body>
      </html>})
};


declare function  test:runZip() { 
  let $pipeline :=
    <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
      <p:input port="source"/>
      <p:output port="result"/>
      <p:zip name="test1">
        <p:with-option name="href" select="'/usr/local/bin/test.zip'"/>  
        <p:with-option name="command" select="'create'"/>
        <p:with-option name="return-manifest" select="'true''"/> 
        <p:with-option name="options" select="'nothing'"/>
      </p:zip>
    </p:declare-step>
  let $stdin    := <films><title>One who did not fly</title><title>Great Unexpectations</title></films>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
  return
    assert:equal($result,<c:result href="/usr/local/bin/test.zip" command="create" return-manifest="true" options="nothing" xmlns:c="http://www.w3.org/ns/xproc-step">
</c:result>)
};

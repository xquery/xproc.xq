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
declare namespace cx="http://xmlcalabash.com/ns/extensions";

declare namespace test1="http://test.com";
declare namespace test2="http://test2.com";

declare function  test:loadModuleTest() { 
  let $actual := <test/>
  return
    assert:equal($actual,<test/>) 
};

declare %test:case function test:enumNSTest1() { 
  let $pipeline := <test xmlns:test1="http://www.test.org/1">
    <a xmlns:test2="http://www.test.org/2"><test2:b/></a>
    <b xmlns:test3="http://www.test.org/3"><test3:b/></b>
    </test>
    
  let $result := xproc:enum-namespaces($pipeline)
  return
    assert:equal($result,       <namespace name="" xmlns="">
      <ns prefix="test2">http://www.test.org/2</ns>
      <ns prefix="test1">http://www.test.org/1</ns>
      <ns prefix="test3">http://www.test.org/3</ns>
    </namespace>)
};

declare %test:case function test:enumNSTest2() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/submit-test-report.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $result := xproc:enum-namespaces($pipeline)
  return
    assert:equal($result,    <namespace name="" xmlns="">
      <ns prefix="cx">http://xmlcalabash.com/ns/extensions</ns>
      <ns prefix="c">http://www.w3.org/ns/xproc-step</ns>
      <ns prefix="p">http://www.w3.org/ns/xproc</ns>
    </namespace>)
};


declare %test:case function test:enumNSTest3() { 
  let $pipeline :=  <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0" xmlns:h="http://www.w3.org/1999/xhtml">
      <p:input port="source"/>
      <p:output port="result"/>
     <p:add-attribute match="h:div[h:pre]"
                       attribute-name="class"
                       attribute-value="example"/>
    </p:declare-step>

  let $result := xproc:enum-namespaces($pipeline)
  return
    assert:equal($result,    <namespace name="" xmlns="">
      <ns prefix="h">http://www.w3.org/1999/xhtml</ns>
      <ns prefix="c">http://www.w3.org/ns/xproc-step</ns>
      <ns prefix="p">http://www.w3.org/ns/xproc</ns>
    </namespace>)
};


declare %test:case function test:runEntryPointTestForNewEvala() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:identity name="step1"/>
  <p:identity name="step2"/>
  <p:identity name="step3"/>
  <p:identity name="step4"/>
</p:declare-step>
  let $stdin    := (<root>text</root>,<test/>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
  return
    assert:equal($result,$stdin)
};


declare %test:ignore function test:runEntryPointTestForNewEval1() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source"/>
  <p:output port="result"/>
    
  <p:identity name="step1"/>
  <p:identity name="step2"/>
  <p:identity name="step3"/>
  <p:count name="step5"/>
  <p:identity name="step6"/>
</p:declare-step>
  let $stdin    := (<a>adfasdf</a>,<root>text</root>,<root/>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
  return
    assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">3</c:result>)
};


declare %test:ignore function test:runEntryPointTestForNewEval2() { 
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
  let $result   := xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
  return
    assert:equal($result,(<a>adfasdf</a>,<root>text</root>,<root/>))
};


(:
declare %test:ignore function test:runEntryPointTestForNewEval3() { 
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


declare %test:case function test:runEntryPointTest() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/test2.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $stdin    := <root>text</root>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $result   := xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
  return
    assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result>)
};


declare %test:case function test:runEntryPointTest1() { 
  let $pipeline :=  xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/simple.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $stdin    := ()
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $result   := xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
  return
    assert:equal($result,    <doc xmlns="">
        Congratulations! You've run your first pipeline!
      </doc>)
};

declare %test:case function test:runEntryPointTest2() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/test2.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $stdin    := (<test/>,<test/>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
  return
    assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">2</c:result>)

};

declare %test:case function test:runEntryPointTest3() { 
  let $pipeline :=  xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xprocxq_new/src/test/data/test2.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $stdin    := <test/>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
    return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result>)
};


declare %test:case function test:runEntryPointTest4() { 
  let $pipeline := <p:declare-step name="main">
<p:input port="source"/><p:output port="result"/>
<p:identity/><p:count/></p:declare-step>
  let $stdin    := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
    return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result>)
};

declare %test:case function  test:runDynamicError() { 
  let $pipeline := xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xproc.xq/src/test/data/error.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $stdin    := <test/>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := try { xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func) } catch($e) {$e//error:code}
  return
      assert:equal($result,<error:code xmlns:error="http://marklogic.com/xdmp/error">err:XD0030: XProc Dynamic Error - : p:error throw custom error code - 999999 It is a dynamic error if a step is unable or incapable of performing its function.
</error:code>)
};

(: failing :)
declare %test:case function  test:runComplexSingleBranch() { 
  let $pipeline :=  xdmp:document-get('file:///Users/jfuller/Source/Webcomposite/xproc.xq/src/test/data/complex-single-branch.xpl',<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)
  let $stdin    := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $output   := ()
  let $result := xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
  return
  assert:equal($result,<packed><newwrapper><a new-id="this is a new string"/></newwrapper><a>test</a></packed>)
};


(: failing :)
declare %test:case function  test:inlineIdentity() { 
  let $pipeline := <p:declare-step name="main" version="1.0" xmlns:p="http://www.w3.org/ns/xproc">
<p:input port="source"/>
<p:output port="result"/>
<p:identity><p:input port="source"><p:inline><test/></p:inline></p:input></p:identity>
</p:declare-step>
  let $stdin    := (<a/>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
let $result   := xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func) 
    return
      assert:equal($result, <test/>)
};

declare %test:case function  test:runGroup() {
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
let $result   := xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func) 
    return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result>)
      
};

declare %test:case function  test:runTryCatch1() { 
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
  let $result   := xproc:run($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
  return
  assert:equal($result,<trywrap xmlns="">
	<c>aaa<a id="1">
	    <b id="2">test</b>
	  </a></c>
      </trywrap>)
};


declare %test:case function  test:runTryCatch2() { 
  let $pipeline := <p:declare-step name="main">
<p:input port="source"/>
<p:output port="result"/>
<p:try>
  <p:group>
    <p:http-request>
      <p:input port="source">
        <p:inline>
          <c:request method="post" href="http://example.com/form-action">
            <c:body content-type="application/x-www-form-urlencoded">name=W3C&amp;spec=XProc</c:body>
          </c:request>
        </p:inline>
      </p:input>
    </p:http-request>
  </p:group>
  <p:catch>
    <p:wrap wrapper="catchwrap" match="/"/>
  </p:catch>
</p:try>
  
</p:declare-step>
  let $stdin    := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  let $result   := xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
  return
  assert:equal($result,<catchwrap xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:err="http://www.w3.org/ns/xproc-error">
      <c>aaa<a id="1">
	  <b id="2">test</b>
	</a></c>
    </catchwrap>)
};



declare %test:ignore function test:runForEach1() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
<p:input port="source"/>
  <p:output port="result" sequence="true"/>
<p:for-each>
<p:iteration-source select="/c/a"/>
<p:wrap wrapper="wrap" match="/"/>
</p:for-each>
</p:declare-step>
  let $stdin    := <c><a>1</a><a>2</a><a>3</a><a>4</a><a>5</a><a>6</a><a>7</a><a>8</a><a>9</a><b>10</b></c>
  let $dflag    := 1
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result := xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
  return
     assert:equal($result,(<wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
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
      </wrap>))
};

declare %test:ignore %test:ignore function test:runForEach2() { 
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
  let $result := xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
  return
     assert:equal($result,(<wrap xmlns:p="http://www.w3.org/ns/xproc" xmlns="">
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
      </wrap>))
};


declare %test:case function  test:runIdentity1() { 
  let $pipeline := <p:declare-step version="1.0" xmlns:p="http://www.w3.org/ns/xproc" name="main">

  <p:input port="source"/>
  <p:output port="result"/>
      
    <p:identity>
      <p:input port="source">
        <p:inline><foo/></p:inline>
      </p:input>
    </p:identity>

</p:declare-step>

  let $stdin    := <a/>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
 let $result := xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
  return
     assert:equal($result,<foo/>)
};

declare %test:case function  test:runIdentity2() { 
  let $pipeline := <p:declare-step version="1.0" xmlns:p="http://www.w3.org/ns/xproc" name="main">

  <p:input port="source"/>
  <p:output port="result"/>
          
    <p:identity>
      <p:input port="source">
        <p:inline><foo/></p:inline>
      </p:input>
    </p:identity>

    <p:identity/>
    
</p:declare-step>

  let $stdin    := <a/>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
 let $result := xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
  return
     assert:equal($result,<foo/>)
};

(: should throw err :)
declare %test:case function  test:runIdentity3() { 
  let $pipeline := <p:declare-step version="1.0" xmlns:p="http://www.w3.org/ns/xproc" name="main">

  <p:input port="source"/>
  <p:output port="result"/>

  <p:identity>
    <p:input port="source">
      <p:inline><foo/></p:inline>
    </p:input>
  </p:identity>

</p:declare-step>

  let $stdin    := <a/>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
 let $result := xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
  return
     assert:equal($result,<foo/>)
};


declare %test:case function  test:runIdentity4() { 
  let $pipeline := <p:declare-step version="1.0" xmlns:p="http://www.w3.org/ns/xproc" name="main">

  <p:input port="source"/>
  <p:output port="result"/>

  <p:identity/>

  <p:sink/>

  <!--p:identity>
    <p:input port="source">
      <p:inline><foo/></p:inline>
    </p:input>
  </p:identity-->

</p:declare-step>

  let $stdin    := <a/>
  let $dflag    := 1
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
 let $result := xproc:run($pipeline,$stdin,(),(),(),0,$dflag,$xproc:eval-step-func)
  return
     assert:equal($result,<foo/>)
};


(: faiing :)
declare %test:case function test:runViewPort() { 
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
 let $result := xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
  return
     assert:equal($result,<doc xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc" xmlns:ext="http://xproc.net/xproc/ext" xmlns:opt="http://xproc.net/xproc/opt" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:xprocerr="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns="">
	<foo></foo>
	<foo></foo>
	<foo></foo>
	<foo></foo>
      </doc>)
};

(: faiing :)
declare %test:case function  test:runChoose1() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:choose>
    <p:xpath-context>
      <p:pipe step="main" port="source"/>
    </p:xpath-context>
    <p:when test="count(//*) gt 1">
    <p:wrap wrapper="when"/>
    </p:when>
    <p:otherwise>
    <p:wrap wrapper="otherwise"/>
  </p:otherwise>
  </p:choose>
</p:declare-step>
  let $stdin    := (<a>afdsfsadf<b/><c/><c>test1</c></a>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
    return
      assert:equal($result, <when>
      <a>afdsfsadf<b></b><c></c><c>test1</c></a>
    </when>)
};


declare %test:case function  test:runChoose2() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:choose>
    <p:xpath-context>
      <p:pipe step="main" port="source"/>
    </p:xpath-context>
    <p:when test="count(.) gt 4">
    <p:wrap wrapper="when"/>
    </p:when>
    <p:otherwise>
    <p:wrap wrapper="otherwise"/>
  </p:otherwise>
  </p:choose>
</p:declare-step>
  let $stdin    := <c><a>test1</a><a>test2</a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  let $result   := xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
    return
      assert:equal($result,<otherwise>
      <c>
	<a>test1</a>
	<a>test2</a>
      </c>
    </otherwise>)
};


declare %test:case function  test:runChoose3() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:choose>
    <p:xpath-context>
      <p:pipe step="main" port="source"/>
    </p:xpath-context>
    <p:when test="count(//*) gt 2">
    <p:wrap match="/" wrapper="when1"/>
    </p:when>
    <p:when test="count(//*) eq 2">
    <p:wrap match="/" wrapper="when2"/>
    </p:when>
    <p:otherwise>
    <p:wrap wrapper="otherwise"/>
  </p:otherwise>
  </p:choose>
</p:declare-step>
  let $stdin    := <a><b/><c/></a>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
    return
      assert:equal($result, <when1><a><b/><c/></a></when1>)
};

declare %test:case function  test:runChoose4() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:choose>
    <p:xpath-context>
      <p:pipe step="main" port="source"/>
    </p:xpath-context>
    <p:when test="count(//*) lt 2">
    <p:wrap match="/" wrapper="when1"/>
    </p:when>
    <p:when test="count(//*) eq 2">
    <p:wrap match="/" wrapper="when2"/>
    </p:when>
    <p:otherwise>
    <p:wrap match="/" wrapper="otherwise"/>
  </p:otherwise>
  </p:choose>
</p:declare-step>
  let $stdin    := (<a><b/><c/><d/></a>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
    return
      assert:equal($result, <otherwise><a><b/><c/><d/></a></otherwise>)
};

declare %test:case function  test:runChoose5() { 
  let $pipeline := <p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:choose>
    <p:xpath-context>
    <p:inline>
    <doc><p>Para about XML</p></doc>
    </p:inline>
    </p:xpath-context>
    <p:when test="//*[contains(.,'XML')]">
      <p:identity>
        <p:input port="source">
          <p:inline>
            <result>Correct</result>
          </p:inline>
        </p:input>
      </p:identity>
    </p:when>
    <p:otherwise>
      <!--p:identity>
        <p:input port="source">
          <p:inline>
            <result>Otherwise Incorrect</result>
          </p:inline>
        </p:input>
      </p:identity-->
      <p:identity/>
  </p:otherwise>
  </p:choose>
</p:declare-step>
  let $stdin    := (<a><b/><c/><d/></a>,<b/>,<c/>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
    return
      assert:equal($result,  <result xmlns="">Correct</result>)
};


declare %test:case function  test:runCompare1() { 
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
  let $result   := xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
    return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">true</c:result>)    
};


declare %test:case function  test:runCompare2() { 
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
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
    return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">true</c:result>)    
};


declare %test:case function  test:runCompare3() { 
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
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
    return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">false</c:result>)    
};

declare %test:case function  test:runCount1() { 
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
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
    return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">3</c:result>)    
};



declare %test:case function test:runCount2() { 
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

  let $dflag    := 1
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   :=  ()
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
  return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result>)
};


declare %test:case function test:runDelete1() { 
  let $pipeline := <p:pipeline version='1.0' name="pipeline" xmlns:p="http://www.w3.org/ns/xproc">

<p:delete match="p:delete"/>

</p:pipeline>


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
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
    return
      assert:equal($result,<pipeline name="pipeline" xmlns="http://www.w3.org/ns/xproc">
      </pipeline>)    
};



declare %test:case function test:runPack1() { 
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
  let $outputs   := ()
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
    return
      assert:equal($result,<sequence-wrapper><wrapper><doc1/><doc2/><doc3/><root>inline alt</root></wrapper></sequence-wrapper>)
};

declare %test:case function test:runPack2() { 
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
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
    return
      assert:equal($result,<NewFilmElement><people><person/><person/></people><b xmlns:c="http://www.w3.org/ns/xproc-step">asdfsdaF</b></NewFilmElement>)
};


(:failing:)
declare %test:case function  test:runDeclareStep1() { 
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
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
    return
      assert:equal($result,())
};


declare %test:case function test:runLabel1() { 
  let $pipeline := 
    <p:pipeline version='1.0'  xmlns:test1="http://test.com" xmlns:test2="http://test2.com">

      <p:label-elements match="element"
                        attribute="foo"
                        attribute-namespace="http://baz.com"/>
                      
    </p:pipeline>

  let $stdin    := <doc test1:foo="value" xmlns:test1="http://test.com"/>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
    return
      assert:equal($result,<doc test2:bar="value" xmlns:test2="http://test2.com" xmlns=""></doc>)
};


declare %test:case function test:runRename1() { 
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
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
    return
      assert:equal($result,<doc test2:bar="value" xmlns:test2="http://test2.com" xmlns=""></doc>)
};

(:)
declare %test:ignore function  test:runExtest1() { 
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
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
    return
      assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">3</c:result>)    
};
:)


declare %test:case function test:runAddAttribute1() { 
  let $pipeline := 
  <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
	    <p:input port="source"/>
	    <p:output port="result"/>
	    <p:add-attribute attribute-name="attr1" attribute-value="value1" match="/people/person"/>
	    <p:add-attribute attribute-name="attr2" attribute-value="value2" match="/people/person"/>
	</p:declare-step>

  let $stdin    := <people><person/><person/></people>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
    return
      assert:equal($result,<people xmlns="">
      <person attr1="value1" attr2="value2"></person>
      <person attr1="value1" attr2="value2"></person>
      </people>)
};

declare %test:case function test:runAddAttribute2() { 
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
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
    return
      assert:equal($result,<people xmlns="">
	<person gender="Male"></person>
	<person gender="Male"></person>
      </people>)    
};

declare %test:ignore function  test:runAddXMLBase() { 
  let $pipeline :=
    <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
	   <p:input port="source" primary="true">
	      <p:document href="/Users/jfuller/Source/Webcomposite/xprocxq/src/test/tests.xproc.org/doc/chaps/div.xml"/>
	   </p:input>
	   <p:output port="result" primary="true"/>
	   <p:identity/>
	</p:declare-step>
  let $stdin    := ()
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
    return
      assert:equal($result,<div xml:base="/Users/jfuller/Source/Webcomposite/xprocxq/src/test/tests.xproc.org/doc/chaps/div.xml" xmlns="">
    <p>This is a <a href="link.xml">link test</a>.</p>
</div>)
};

declare %test:case function  test:runXSLT1() { 
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
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
  return
    assert:equal($result,<html xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc" xmlns:ext="http://xproc.net/xproc/ext" xmlns:opt="http://xproc.net/xproc/opt" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:xprocerr="http://www.w3.org/ns/xproc-error" xmlns:xxq-error="http://xproc.net/xproc/error" xmlns:err="http://www.w3.org/ns/xproc-error" xmlns="">
	<body>
	  <h1>Film list</h1>
	  <ul>
	    <li>One who did not fly</li>
	    <li>Great Unexpectations</li>
	  </ul>
	</body>
      </html>)
};


declare %test:case function  test:runZip() { 
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
  let $result   :=  xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
  return
    assert:equal($result,<c:result href="/usr/local/bin/test.zip" command="create" return-manifest="true" options="nothing" xmlns:c="http://www.w3.org/ns/xproc-step">
</c:result>)
};

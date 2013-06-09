xquery version "1.0-ml";

module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";

import module namespace xproc = "http://xproc.net/xproc" at "/xquery/core/xproc-impl.xqy";
import module namespace xprocxq = "http://xproc.net/xprocxq" at "/xquery/xproc.xq";

import module namespace parse = "http://xproc.net/xproc/parse" at "/xquery/core/parse.xqy";

declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace ext ="http://xproc.net/xproc/ext";
declare namespace foo="http://acme.com/test";
declare namespace cx="http://xmlcalabash.com/ns/extensions";

declare namespace test1="http://test.com";
declare namespace test2="http://test2.com";

declare copy-namespaces no-preserve, no-inherit;

declare %test:case function  test:goTest() { 
  let $pipeline :=
    <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0" xmlns:h="http://www.w3.org/1999/xhtml">
      <p:input port="source"/>
      <p:output port="result"/>
     <p:add-attribute match="h:div[h:pre]"
                       attribute-name="class"
                       attribute-value="example"/>
    </p:declare-step>
  let $stdin    := <films><title>One who did not fly</title><title>Great Unexpectations</title></films>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
  return
    assert:equal($result,    <films xmlns="">
      <title>One who did not fly</title>
      <title>Great Unexpectations</title>
    </films>)
};


declare %test:case function  test:runtest1() { 
  let $pipeline :=
    <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
      <p:input port="source"/>
      <p:output port="result"/>
      <p:wrap wrapper="test"/>
    </p:declare-step>
  let $stdin    := <films><title>One who did not fly</title><title>Great Unexpectations</title></films>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)

 (:   function($a,$b,$c,$d){
    (
      xdmp:log(name($d//*[@xproc:default-name eq $a]))
    )
 :)
  return
    assert:equal($result,    <films xmlns="">
      <title>One who did not fly</title>
      <title>Great Unexpectations</title>
    </films>)
  
};


declare %test:case function  test:runtest2() { 
  let $pipeline :=
    <p:declare-step name="test" xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
      <p:input port="source"/>
      <p:output port="result"/>
      <p:count/>
    </p:declare-step>
  let $stdin    := <films><title>One who did not fly</title><title>Great Unexpectations</title></films>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs  := ()
  let $result   := xproc:run($pipeline,$stdin,(),(),(),$dflag,0,$xproc:eval-step-func)
  return
    assert:equal($result,<c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result>)
  
};

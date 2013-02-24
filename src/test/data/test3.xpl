<?xml version="1.0"?>
<p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
<p:input port="source"/>
<p:output port="result"/>

<p:identity name="step1"/>

<p:identity name="step2">
  <p:input port="source">
    <p:empty/>
  </p:input>
</p:identity>

<p:identity name="step2">
  <p:input port="source">
    <p:document href="/Users/jfuller/Source/Webcomposite/xprocxq/src/test/tests/data/test1.xml"/>
  </p:input>
</p:identity>

<p:identity name="step3">
  <p:input port="source">
    <p:data href="/Users/jfuller/Source/Webcomposite/xprocxq/src/test/tests/data/test1.xml"/>
  </p:input>
  <p:log port="result" href="/tmp/test.txt"/>
</p:identity>

<p:identity name="step4">
  <p:input port="source">
    <p:document href="/Users/jfuller/Source/Webcomposite/xprocxq/src/test/tests/data/test1.xml"/>
  </p:input>
  <p:log port="source" href="/test.txt"/>
</p:identity>

</p:declare-step>

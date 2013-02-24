<?xml version="1.0"?>
<p:declare-step version="1.0" xmlns:p="http://www.w3.org/ns/xproc">
<p:input port="source">
  <p:inline><doc>
Congratulations! You've run your first pipeline!
</doc></p:inline>
</p:input>
<p:output port="result"/>
<p:group>
<p:identity/>
</p:group>
<p:identity>
  <p:input port="source" select="/test"><p:inline><test>test</test></p:inline></p:input>
</p:identity>
<p:count limit="20"/>
</p:declare-step>

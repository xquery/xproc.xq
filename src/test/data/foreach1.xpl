<p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
<p:input port="source"/>
  <p:output port="result" sequence="true"/>
<p:for-each>
<p:iteration-source select="//a"/>
<p:wrap wrapper="wrap" match="/"/>
</p:for-each>
</p:declare-step>

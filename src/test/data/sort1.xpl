<p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
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

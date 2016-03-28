xquery version "1.0" encoding "UTF-8";

import module namespace p="grammar" at "test.xqy";

let $tests :=
<tests>
<test>
<![CDATA[
xproc version "2.0";

(: This example is from the XProc 1.0 specification (example 3). :)

 inputs $source as document-node();
outputs $result as document-node();

$source >> $result
]]></test>
<test>
<![CDATA[
xproc version "2.0";

(: This example is from the XProc 1.0 specification (example 3). :)

 inputs $source as document-node();
outputs $result as document-node();

        option $test = '1';

$source => xslt()

]]></test>
<test><![CDATA[
xproc version "2.0";

inputs $source as document-node();
outputs $result as document-node();

$source => { if ( xs:decimal(./*/@version) < 2.0)
            then [$1,"v1schema.xsd"] => validate-with-xml-schema() >> @1
            else [$1,"v2schema.xsd"] => validate-with-xml-schema() >> @1}
        => [$1,"stylesheet.xsl"] => xslt()
>> $result
]]></test>
<test><![CDATA[
        $in => xinclude()
        ]]>
</test>
<test><![CDATA[
        [$in,"stylesheet.xsl"] => xslt() => [($1,$2),"query.xq"] => xquery()
        ]]></test>
<test><![CDATA[
        $in//section => count() >> $out
]]>
</test>
</tests>

return  p:parse-XProc($tests/test[6])

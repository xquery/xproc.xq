xquery version "1.0-ml";

module namespace r="http://xproc.org/resource";

(: imports :)

import module namespace p="grammar"
    at "../test.xqy";

(: utility imports  :)

import module namespace rxq="http://exquery.org/ns/restxq"
     at "../lib/rxq.xqy";

import module namespace xxq = "http://xproc.net/xprocxq"
     at "../lib/xprocv2/xproc.xq";

(: declarations :)

declare namespace xproc = "http://xproc.net/xproc";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare option xdmp:mapping "false";

(: tests :)
declare variable $r:tests := xdmp:document-get("/Users/jfuller/Source/2_webcomposite/xprocv2/src/app/endpoints/tests.xml")/*;

declare variable $style := <xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:strip-space elements="*" />
  <xsl:output method="xml" indent="yes" />

  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>;

declare
%rxq:POST
%rxq:path('^/xproc')
function r:parse()
{

    let $body := xdmp:quote(xdmp:get-request-field("code"))
    let $parse := p:parse-XProc(xdmp:get-request-field("code"))
    let $debug := if (xdmp:get-request-field("debug","0") eq "on") then true() else false()
    let $parsetree := if (xdmp:get-request-field("parsetree","0") eq "on") then true() else false()
    return
    <html>
    <head>
    <script src="http://cdnjs.cloudflare.com/ajax/libs/prettify/r298/run_prettify.js?autoload=true&amp;skin=sunburst&amp;lang=xml" type="text/javascript">&#160;</script>
<link href="http://cdnjs.cloudflare.com/ajax/libs/prettify/r298/prettify.css" type="text/css"/>
    </head>
    <body>
    <h1>XProc v2 Test</h1>
    <a href="/xproc">parse</a> |
    { $tests/test ! ( <a href="/xproc/ex{position()}">ex{position()}</a>," | " )}
    <form action="/xproc" method="POST">
    <textarea rows="10" cols= "200" id="code" name="code">
    {$body}
    </textarea>
    <input type="submit" value="run" class="submitButton"/>
    <br/>
    {if($debug) then <input type="checkbox" name="debug" checked="checked"/> else
 <input type="checkbox" name="debug"/>}:debug
    {if($parsetree) then <input type="checkbox" name="parsetree" checked="checked"/> else
        <input type="checkbox" name="parsetree"/>}:parse
    </form>
    {if($parse)
        then
        <div>
        <h3>Run Result</h3>
   { try{ let $flow := $parse/data()
     let $result :=
        xxq:run($flow,(<test>1</test>,<b>2</b>),(),(),(),$debug,false(),())
            return <pre class="prettyprint lang-json"><code>{xdmp:quote($result)}</code></pre>
     }catch($e){<pre>failed to run</pre>}
    }
        </div>
        else ()}

        <div>
         <h3>Parse Result</h3>
        <pre class="prettyprint lang-xml">{
        if($parsetree)
        then
        xdmp:quote(
            xdmp:xslt-eval(<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:strip-space elements="*" />
  <xsl:output method="xml" indent="yes" />

  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
                ,$parse))

        else ()
        }</pre>
    </div>
    </body>
    </html>
};
declare
%rxq:GET
%rxq:path('^/xproc')
function r:index()
{
    <html>
    <body>
    <h1>XProc v2 Test</h1>
    <a href="/xproc">parse</a> |
    { $tests/test ! ( <a href="/xproc/ex{position()}">ex{position()}</a>," | " )}
    <form action="/xproc" method="POST">
    <textarea name="code" rows="10" cols="200">
        {$tests/*[1]/data()}
    </textarea>
    <input type="submit" value="run" class="submitButton"/>

    </form>
    </body>
    </html>
};


declare
%rxq:GET
%rxq:path('^/xproc/ex([^/?&amp;]+)')
function r:examples(
    $example
)
{
    let $parse := p:parse-XProc($tests/test[xs:integer($example)]/data())
    let $debug := if (xdmp:get-request-field("debug","0") eq "on") then true() else false()
    let $parsetree := if (xdmp:get-request-field("parsetree","0") eq "on") then true() else false()
    return

    <html>
    <head>
<script src="http://cdnjs.cloudflare.com/ajax/libs/prettify/r298/run_prettify.js?autoload=true&amp;skin=sunburst&amp;lang=xml" type="text/javascript">&#160;</script>
<link href="http://cdnjs.cloudflare.com/ajax/libs/prettify/r298/prettify.css" type="text/css"/>

    </head>
    <body>
    <h1>XProc v2 Test</h1>
    <a href="/xproc">parse</a> |
    { $tests/test ! ( <a href="/xproc/ex{position()}">ex{position()}</a>," | " )}
    <form action="/xproc" method="POST">
    <textarea name="code" rows="10" cols= "200">
    {$tests/test[xs:integer($example)]/data()}
    </textarea>
    <input type="submit" value="run" class="submitButton"/>
    <br/>
    {if($debug) then <input type="checkbox" name="debug" checked="checked"/> else
 <input type="checkbox" name="debug"/>}:debug
    {if($parsetree) then <input type="checkbox" name="parsetree" checked="checked"/> else
        <input type="checkbox" name="parsetree"/>}:parse
    </form>
    <div>
    <h3>Run Result</h3>
   { try{ let $flow := $tests/test[xs:integer($example)]/data()
     let $result :=
        xxq:run($flow,(<test>1</test>,<b>2</b>),(),(),(),$debug,false(),())
            return <pre class="prettyprint lang-json"><code>{xdmp:quote($result)}</code></pre>
     }catch($e){<pre>failed to run</pre>}
    }
    </div>
    <div>
    <h3>Parse Tree</h3>
    <pre class="prettyprint lang-xml"><code>{
        if($parsetree)
        then
        xdmp:quote(
            xdmp:xslt-eval($style, $parse))
        else ()}</code></pre>
    </div>
    </body>
    </html>
};

declare
%rxq:GET
%rxq:path('^/xproc/ex([^/?&amp;]+)/run')
function r:examples-run(
    $example
)
{

    let $flow := $tests/test[xs:integer($example)]/data()
    let $result :=
        xxq:run($flow,(<test>1</test>,<b>2</b>),(),(),(),false(),false(),())
    return
    <pre class="prettyprint lang-json"><code>{
        xdmp:quote($result)}</code></pre>
};

declare %xproc:step
function r:wg(
    $test
)
{
    <wg>{
    $test
    }</wg>
};

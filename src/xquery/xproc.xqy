xquery version "1.0-ml"  encoding "UTF-8";

module namespace xproc = "http://xproc.net/xproc";

 declare boundary-space strip;
 declare copy-namespaces preserve,no-inherit;

 (:~ declare namespaces :)
 declare namespace p="http://www.w3.org/ns/xproc";
 declare namespace c="http://www.w3.org/ns/xproc-step";
 declare namespace xprocerr="http://www.w3.org/ns/xproc-error";
 declare namespace xsl="http://www.w3.org/1999/XSL/Transform";

 (:~ module imports :)
 import module namespace const = "http://xproc.net/xproc/const" at "const.xqy";
 import module namespace parse = "http://xproc.net/xproc/parse" at "parse.xqy";
 import module namespace     u = "http://xproc.net/xproc/util"  at "util.xqy";
 import module namespace   std = "http://xproc.net/xproc/std"   at "std.xqy";
 import module namespace   opt = "http://xproc.net/xproc/opt"   at "opt.xqy";
 import module namespace   ext = "http://xproc.net/xproc/ext"   at "ext.xqy";

 declare default function namespace "http://www.w3.org/2005/xpath-functions";

 (:~ declare variables :)
 declare variable $xproc:eval-step     := xproc:evalstep#4;

 (:~ declare steps :)
 declare variable $xproc:run-step      := xproc:run#7;
 declare variable $xproc:xproc-run     := xproc:xproc-run#4;
 declare variable $xproc:choose        := xproc:choose#4;
 declare variable $xproc:try           := xproc:try#4;
 declare variable $xproc:group         := xproc:group#4;
 declare variable $xproc:for-each      := xproc:for-each#4;
 declare variable $xproc:viewport      := xproc:viewport#4; 

 declare variable $xproc:declare-step  := ();
 declare variable $xproc:library       := ();
 declare variable $xproc:pipeline      := ();
 declare variable $xproc:variable      := ();


 (:~ xproc:xproc-run impl for ext:xproc extension step
 :
 : @param $primary -
 : @param $secondary -
 : @param $options -
 : @param $currentstep -
s :
 : @returns 
 :)
(: -------------------------------------------------------------------------- :)
declare function xproc:xproc-run($primary,$secondary,$options,$currentstep) {
(: -------------------------------------------------------------------------- :)
let $pipeline := u:get-secondary('pipeline',$secondary)/*
let $bindings := u:get-secondary('binding',$secondary)/*
let $dflag  as xs:integer  := xs:integer(u:get-option('dflag',$options,$primary))
let $tflag  as xs:integer  := xs:integer(u:get-option('tflag',$options,$primary))
return
  $xproc:run-step($pipeline,$primary,$bindings,$options,(),$dflag ,$tflag)
};


 (:~ 
 :
 : @param $sorted -
 :
 : @returns 
 :)
declare function xproc:genExtPost(
  $sorted
) {
<ext:post xproc:step="true" xproc:default-name="{$sorted[1]/@xproc:default-name}!">
  <p:input port="source" primary="true" select="/" xproc:type="comp">
    <p:pipe port="result" step="{$sorted[last()]/@xproc:default-name}" xproc:step-name="{$sorted[last()]/@xproc:default-name}"/>
  </p:input>
<p:output primary="true" port="result" xproc:type="comp" select="/"/>
</ext:post>
};



 (:~ p:group step implementation
 :
 : @param $primary -
 : @param $secondary -
 : @param $options -
 : @param $currentstep -
 :
 : @returns 
 :)
(: -------------------------------------------------------------------------- :)
declare function xproc:group($primary,$secondary,$options,$currentstep) {
(: -------------------------------------------------------------------------- :)
let $namespaces  := xproc:enum-namespaces($currentstep)
let $defaultname as xs:string := string($currentstep/@xproc:default-name)
let $sorted := parse:pipeline-step-sort(  $currentstep/node(), ())  
let $ast := <p:declare-step name="{$defaultname}" xproc:default-name="{$defaultname}" >{$sorted}
{xproc:genExtPost($sorted)}
</p:declare-step>
return
  xproc:output(
   xproc:evalAST($ast,$xproc:eval-step,$namespaces,$primary,(),())
   ,0)
};


 (:~ p:choose step implementation
 :
 :  I have decided to 
 :
 : @param $primary -
 : @param $secondary -
 : @param $options -
 : @param $currentstep -
 :
 : @returns 
 :)
declare function xproc:choose(
  $primary,
  $secondary,
  $options,
  $currentstep
) {
  (:
let $namespaces := xproc:enum-namespaces($currentstep)
  
let $defaultname as xs:string := string($currentstep/@xproc:default-name)

let $when-sorted :=  parse:pipeline-step-sort( $currentstep/p:when[1]/node()  , () )
let $ast-when := <p:declare-step name="{$defaultname}" xproc:default-name="{$defaultname}" >
<p:input port="source"/>
<p:output port="result"/>
{$when-sorted}
{xproc:genExtPost($when-sorted)}
</p:declare-step>

let $when-result :=   xproc:output(xproc:evalAST($ast-when,$xproc:eval-step,$namespaces,$primary,(),()), 0)
return
(xdmp:log($result),$result)

:)
  
let $namespaces := xproc:enum-namespaces($currentstep)
let $defaultname as xs:string := string($currentstep/@xproc:default-name)
let $xpath-context as element(p:xpath-context) := $currentstep/ext:pre/p:xpath-context[1]
let $xpath-context-select as xs:string :=string($xpath-context/@select)
let $xpath-context-binding := $xpath-context[1]/node()[1]
let $xpath-context-data := $primary
let $context := if ($primary ne '') then u:evalXPATH($xpath-context-select,document{$primary})
                else u:evalXPATH($xpath-context-select,document{$xpath-context})
let $when-test := for $when at $count in $currentstep/p:when
          let $check-when-test := u:assert(not($when/@test eq ''),"p:choose when test attribute cannot be empty")
          return
             if ( $primary/xdmp:value( $when/@test ) ) then $count else ()
return
  if($when-test) then
    let $when-sorted :=  parse:pipeline-step-sort( $currentstep/p:when[$when-test]/node()  , () )
    let $ast-when := <p:declare-step name="{$defaultname}" xproc:default-name="{$defaultname}"><p:input port="source"/>
<p:output port="result"/>{$when-sorted}{xproc:genExtPost($when-sorted)}</p:declare-step>
    return
      xproc:output(xproc:evalAST($ast-when,$xproc:eval-step,$namespaces,$primary,(),()), 0)
  else
    let $otherwise-sorted :=  parse:pipeline-step-sort( $currentstep/p:otherwise/node()  , () )
    let $ast-otherwise := <p:declare-step name="{$defaultname}" xproc:default-name="{$defaultname}" ><p:input port="source"/>
<p:output port="result"/>{$otherwise-sorted}{xproc:genExtPost($otherwise-sorted)}</p:declare-step>
    return
      xproc:output(xproc:evalAST($ast-otherwise,$xproc:eval-step,$namespaces,$primary,(),()), 0)

};


 (:~ p:try step implementation
 :
 : @param $primary -
 : @param $secondary -
 : @param $options -
 : @param $currentstep -
 :
 : @returns 
 :)
(: -------------------------------------------------------------------------- :)
declare function xproc:try($primary,$secondary,$options,$currentstep) {
(: -------------------------------------------------------------------------- :)
let $namespaces  := xproc:enum-namespaces($currentstep)
let $defaultname as xs:string := string($currentstep/@xproc:default-name)
let $ast-try := <p:declare-step name="{$defaultname}" xproc:default-name="{$defaultname}" >{parse:pipeline-step-sort($currentstep/*[name(.) ne 'p:catch'],())}</p:declare-step>
let $ast-catch := <p:declare-step name="{$defaultname}" xproc:default-name="{$defaultname}" >{parse:pipeline-step-sort($currentstep/p:catch/node(),())}</p:declare-step>

return
  try{
    xproc:output(xproc:evalAST($ast-try,$xproc:eval-step,$namespaces,$primary,(),()), 0)
  }catch *{
    xproc:output(xproc:evalAST($ast-catch,$xproc:eval-step,$namespaces,$primary,(),()), 0)
  }
};


 (:~ p:for-each step implementation
 :
 : @param $primary -
 : @param $secondary -
 : @param $options -
 : @param $currentstep -
 :
 : @returns 
 :)
(: -------------------------------------------------------------------------- :)
declare function xproc:for-each($primary,$secondary,$options,$currentstep) {
(: -------------------------------------------------------------------------- :)
let $namespaces  := xproc:enum-namespaces($currentstep)
let $defaultname as xs:string := string($currentstep/@xproc:default-name)
let $iteration-select as xs:string := string($currentstep/ext:pre/p:iteration-source/@select)

let $source := if ($currentstep/ext:pre/p:iteration-source/*) then
  $currentstep/ext:pre/p:iteration-source/p:inline/node()
else
  $primary
let $sorted := parse:pipeline-step-sort($currentstep/node(),())  
let $ast := <p:declare-step name="{$defaultname}" xproc:default-name="{$defaultname}" ><p:input port="source"/>
<p:output port="result"/>{$sorted}
</p:declare-step>
return
for $item in u:evalXPATH($iteration-select,document{$source})
return
  xproc:output(xproc:evalAST($ast,$xproc:eval-step,$namespaces,$item,(),()), 0)
};


 (:~ p:viewport step implementation
 :
 : @param $primary -
 : @param $secondary -
 : @param $options -
 : @param $currentstep -
 :
 : @returns 
 :)
(: -------------------------------------------------------------------------- :)
declare function xproc:viewport($primary,$secondary,$options,$currentstep) {
(: -------------------------------------------------------------------------- :)
let $namespaces  := xproc:enum-namespaces($currentstep)
let $defaultname as xs:string := string($currentstep/@xproc:default-name)
let $match as xs:string   := string($currentstep/@match)
  
let $ast := <p:declare-step name="{$defaultname}" xproc:default-name="{$defaultname}" >{parse:pipeline-step-sort($currentstep/node(),())}</p:declare-step>
let $source := if ($currentstep/ext:pre/p:viewport-source/*) then
  $currentstep/ext:pre/p:viewport-source/p:inline/node()
else
  $primary

let $template := <xsl:stylesheet version="2.0">
{$const:xslt-output}

<xsl:template match="{$match}">
<xsl:copy>
<xsl:apply-templates select="@*|*"/>
</xsl:copy>
</xsl:template>

</xsl:stylesheet>      

let $data := (u:transform($template,$source))
let $results := (for $item at $count in $data/*
return
  xproc:output(xproc:evalAST($ast,$xproc:eval-step,$namespaces,$item,(),()), 0)
)

let $final-template := <xsl:stylesheet version="2.0">
{$const:xslt-output}

<xsl:variable name="data" as="item()*">{$results}</xsl:variable>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="{$match}">
<xsl:copy-of select="subsequence($data,1,1)"/>
</xsl:template>

</xsl:stylesheet>  

return
  u:transform($final-template,$source)

};


 (:~ resolve external bindings
 :
 : @param $a -
 : @param $b -
 :
 : @returns 
 :)
 (: --------------------------------------------------------------------------- :)
 declare function xproc:resolve-external-bindings($a,$b) {
 (: -------------------------------------------------------------------------- :)
() 
 };

 (:~ generates a sequence of xs:string containing step names
 :
 : @param $step - 
 :
 : @returns xs:string of xproc:default-name
 :)
 (: --------------------------------------------------------------------------- :)
 declare function xproc:genstepnames($step) as xs:string* {
 (: -------------------------------------------------------------------------- :)
      for $name in  $step/*[@xproc:step eq "true"]
        return
          $name/@xproc:default-name
 };


 (:~ utility function for generating xproc:generate_output
 :
 : @param $step - 
 : @param $port - 
 : @param $port-type - 
 : @param $primary - 
 : @param $content - 
 :
 : @returns xproc:output
 :)
 (: ------------------------------------------------------------------------------------------------------------- :)
 declare function xproc:generate_output($step,$port,$port-type,$primary,$content) as element(xproc:output){
 (: ------------------------------------------------------------------------------------------------------------- :)
 <xproc:output
  step="{$step}"
  xproc:default-name="{$step}"
  port="{$port}"
  port-type="{$port-type}"
  primary="{$primary}"
  func="">{$content}</xproc:output>
 };


 (:~ resolve p:document input port bindings
 :
 : @param $href - href of document you wish to access
 :
 : @returns 
 :)
 (: -------------------------------------------------------------------------- :)
 declare function xproc:resolve-document-binding($href as xs:string) as item(){
 (: -------------------------------------------------------------------------- :)
    if (doc-available($href)) then
        try { 
        let $doc := doc($href) 
        return
          element {name($doc/node())} {
         (:   if ($doc/node()/@xml:base) then () else attribute xml:base {$href}, :)
            $doc/*/*
          }
         } catch * { u:dynamicError('xprocerr:XD0002',concat(" cannot access document ",$href))}
    else
        u:dynamicError('xprocerr:XD0002',concat(" cannot access document ",$href))
 };


(:~ resolve p:data input port bindings
 :
 :
 : @param $href - xs:string
 : @param $wrapper  - xs:string
 :
 : @returns c:data
 :)
 (: -------------------------------------------------------------------------- :)
 declare function xproc:resolve-data-binding($input as element(p:data)*){
 (: -------------------------------------------------------------------------- :)

if($input/@wrapper) then
  element {$input/@wrapper} {
    $input/node()
  }
else if ($input/@href) then
<c:data
  content-type ="{($input/@content-type,'application/octet-stream')[1]}" >{

  if (starts-with($input/@content-type,'text')) then
    fn:unparsed-text(concat('file:///',$input/@href))
  else
    (attribute encoding {"base64"},
    u:string-to-base64(fn:unparsed-text(concat('file:///',$input/@href))))
}</c:data>
else
<c:data
  content-type ="{$input/@content-type}"
   charset ="{$input/@charset}"
  encoding ="{$input/@encoding}">{u:string-to-base64($input/text())}</c:data>

(:
    u:dynamicError('xprocerr:XD0002',concat("cannot access file:  ",$href))
:)
 };


(:~ resolve p:inline input port bindings
 :
 :
 : @param $inline - p:inline
 :
 : @returns item()*
 :)
 (: -------------------------------------------------------------------------- :)
 declare function xproc:resolve-inline-binding($inline as item()*,$currentstep){
 (: -------------------------------------------------------------------------- :)
 let $ns := u:enum-ns(<dummy>{$currentstep}</dummy>)
 let $exclude-result-prefixes as xs:string := string($inline/@exclude-inline-prefixes)

 let $template := <xsl:stylesheet version="2.0" exclude-result-prefixes="{$exclude-result-prefixes}">
       {for $n in $ns return
       if($n/@URI ne '') then namespace {$n/@prefix} {$n/@URI} else ()
       }
       {$const:xslt-output}

       <xsl:template match="element()">
         <xsl:copy>
           <xsl:apply-templates select="@*,node()"/>
         </xsl:copy>
       </xsl:template>

       <xsl:template match="attribute()|text()|comment()|processing-instruction()">
         <xsl:copy/>
       </xsl:template>
    
</xsl:stylesheet>

return
  u:transform($template,$inline)
};


(:~ resolve input port bindings
 :
 : Will process p:empty, p:inline, p:document, p:data, p:pipe
 : or throw xprocerr:XD0001 
 :
 :
 : @param $input - 
 : @param $result  - TODO rename to outputs
 : @param $ast -
 : @param $currentstep 
 : @returns 
 :)
 (: -------------------------------------------------------------------------- :)
 declare function xproc:resolve-port-binding($input,$outputs,$ast,$currentstep){
 (: -------------------------------------------------------------------------- :)
   typeswitch($input)
     case element(p:empty)
       return ()
     case element(p:inline)
       return xproc:resolve-inline-binding($input/*,$currentstep)
     case element(p:document)
       return xproc:resolve-document-binding($input/@href)
     case element(p:data)
       return xproc:resolve-data-binding($input)
     case element(p:pipe)
       return u:getInputMap( if($input/@port eq "source") then $input/@xproc:step-name else $input/@xproc:step-name || "#" || $input/@port )
     default 
       return
         u:dynamicError('xprocerr:XD0001',concat("cannot bind to port: ",$input/@port," step: ",$input/@step,' ',u:serialize($currentstep,$const:TRACE_SERIALIZE)))
};


(:~ evaluates step options
 :
 :
 : @param $ast - 
 : @param $stepname - 
 :
 : @returns xproc:options
 :)
 (: -------------------------------------------------------------------------- :)
 declare function xproc:eval-with-options($ast,$stepname as xs:string) as element(xproc:options){
 (: -------------------------------------------------------------------------- :)
     <xproc:options>
         {$ast/*[@xproc:default-name=$stepname]/p:with-option}
     </xproc:options>
 };


(:~ evaluates secondary input bindings to a step
 :
 :
 : @param $ast - 
 : @param $currentstep
 : @param $primaryinput
 : @param $outputs
 :
 : @returns 
 :)
 (: -------------------------------------------------------------------------- :)
 declare function xproc:eval-secondary($ast as element(p:declare-step),$currentstep,$primaryinput as item()*,$outputs as item()*){
 (: -------------------------------------------------------------------------- :)
 let $step-name as xs:string := string($currentstep/@xproc:default-name)
 return

 for $pinput in $currentstep//p:input[@primary eq "false"]
 return
 <xproc:input port="{$pinput/@port}" select="/">
   {
 let $data :=  if($pinput/*) then
       for $input in $pinput/*
       return
          xproc:resolve-port-binding($input,$outputs,$ast,$currentstep) 
       else         
         u:getInputMap($currentstep/p:input/p:pipe/@xproc:step-name)
                    
let $result :=  u:evalXPATH(string($pinput/@select),$data)
let $_ := u:putInputMap( $step-name || "#" ||  $pinput/@port, $result)
 return
   if ($result) then
     document{$result}
   else
     <xprocerror1 type="eval-secondary"/>
   (:  u:dynamicError('xprocerr:XD0016',concat("xproc step ",$step-name, "did not select anything from p:input")) :)
   }
 </xproc:input>
 };


 (:~ evaluates primary input bindings to a step
  :
  : a) checks to see if there are multiple children to p:input and uses xproc:resolve-port-binding to resolve them
  : b) applies xpath select processesing (if did not select anything this is an xprocerror)
  : c) 
  :
  :
  :
  : @param $ast - we require ast to refer to stuff
  : @param $step - 
  : @param $currentstep - actual current step
  : @param $primaryinput - primary input
  : @param $outputs - all of the previously processed steps outputs, including in scope variables and options
  :
  : @returns item()*
 :)
 (:---------------------------------------------------------------------------:)
 declare function xproc:eval-primary($ast as element(p:declare-step),$currentstep,$primaryinput as item()*,$outputs as item()*){
 (: -------------------------------------------------------------------------- :)
 let $step-name as xs:string := string($currentstep/@xproc:default-name)
 let $pinput as element(p:input)? := $currentstep/p:input[@primary eq 'true']
 let $data :=  if($pinput/*) then
       for $input in $pinput/*
       return
          xproc:resolve-port-binding($input,$outputs,$ast,$currentstep) 
       else         
         u:getInputMap($currentstep/p:input/p:pipe/@xproc:step-name) 
           
let $result :=  $data (: u:evalXPATH(string($pinput/@select),$data) :)
 return
   if ($result) then     
     document{$result}
   else
     ()
     (: u:dynamicError('xprocerr:XD0016',concat("xproc step ",$step-name, "did not select anything from p:input")) :)
};


 (:~ evaluates an xproc step
  :
  : @param $step - step's xproc:default-name
  : @param $namespaces - namespaces in use 
  : @param $primaryinput - standard input into the step
  : @param $ast - full abstract syntax tree of the pipeline being processed
  : @param $outputs - all of the previously processed steps outputs, including in scope variables and options
  :
  : @returns item()*
 :)
 (: -------------------------------------------------------------------------- :)
 declare function xproc:evalstep (
   $step,
   $namespaces,
   $primaryinput as item()*,
   $ast as element(p:declare-step)) {
 (: -------------------------------------------------------------------------- :)
 let $variables    := ()
 let $with-options := xproc:eval-with-options($ast,$step)

 let $currentstep  := $ast/*[@xproc:default-name eq $step]
 let $stepfunction := if ($currentstep/@type) then $std:identity else xproc:getstep( name($currentstep) )

 let $primary      := xproc:eval-primary($ast,$currentstep,$primaryinput, ())
 let $secondary    := xproc:eval-secondary($ast,$currentstep,$primaryinput,())

 let $log-href     := $currentstep/p:log/@href
 let $log-port     := $currentstep/p:log/@port

 let $result       :=$stepfunction( if (empty($primary)) then $primaryinput else $primary,$secondary,$with-options,$currentstep)
 let $_            := u:putInputMap($step, $result)

 return
      $result
 };
  

 (:~
  : DEPRECATE - REPLACE WITH u:enum-ns ... lists all namespaces which are declared and in use within pipeline 
  : @TODO possibly move to util.xqm and delineate between declared and in use
  :
  : @param $pipeline - returns all in use namespaces

  : @returns <namespace/> element
  :)
 (: ------------------------------------------------------------------------------------------------------------- :)
 declare function xproc:enum-namespaces($pipeline) as element(namespace){
 (: ------------------------------------------------------------------------------------------------------------- :)
    <namespace name="{$pipeline/@name}">{u:enum-ns(<dummy>{$pipeline}</dummy>)}</namespace>
 };


 (:~
  : prepares the output from for xproc:stepFoldEngine
  :
  : This is a preprocess before serialization and actual output to standard output
  : or wherever externally from xprocxq
  :
  : @param $result - all outputs from the result of processing pipeline
  : @param $dflag - if true will output full processing trace
  :
  : @returns item()* 
  :)
 (: -------------------------------------------------------------------------- :)
 declare function xproc:output($result,$dflag as xs:integer) as item()*{
 (: -------------------------------------------------------------------------- :)
 let $ast    :=subsequence($result,1,1)
 return
   if($dflag eq 1) then
   <xproc:debug>
     <xproc:pipeline>{$ast}</xproc:pipeline>
     <xproc:outputs>{$u:inputMap}</xproc:outputs>
   </xproc:debug>
 else
  let $map  := xdmp:get-server-field("xproc:input-map")
  let $keys :=  for $key in map:keys($map)
                return
                  if (ends-with(string($key),'!') ) then string($key)
                  else () 
  return u:getInputMap($keys[1])
 };

 (:~
  : xproc pipeline is processed using a step fold function
  : 
  :
  : This is the central mechanism by which xprocxq works. By using a step-fold
  : function we have a flexible method of working with xproc branches, ext:xproc
  : invokes, as well as opening up all sorts of possibilities to work Map/Reduce
  : style.
  :
  :
  :
  :  
  : @param $ast - abstract syntax tree representing pipeline
  : @param $namespaces - all namespaces that are used within pipeline
  : @param $steps - 
  : @param $evalstep-function - 
  : @param $primary - starting input
  : @param $outputs - starting outputs, used for ext:xproc and branching pipelines
  :
  : @returns ($ast, $outputs)
  :)
 (: -------------------------------------------------------------------------- :)
 declare function xproc:stepFoldEngine(
   $ast as element(p:declare-step),
   $namespaces as element(namespace),
   $steps as xs:string*,
   $evalstep-function,
   $primary as item()*
){ 
let $f := $evalstep-function( ?, $namespaces, ?, $ast)
return
(
  $ast,
  fn:fold-left(function($a,$b){ $f($b,$a) }, $primary, $steps)
)
};


 (:~
  : runtime processing wrapper for xproc:stepFoldEngine 
  : @TODO - may push this down back to xproc:run
  :
  : This level of abstraction is probably temporary
  :
  : @param $ast - abstract syntax tree representing pipeline
  : @param $evalstep - function for evaluating each step (allows for flexible processing)
  : @param $namespaces - all namespaces that are used within pipeline
  : @param $stdin - standard input into the pipeline
  : @param $bindings - declared port bindings
  : @param $outputs - starting outputs, used for ext:xproc and branching pipelines
  :
  : @returns 
  :)
 (: ------------------------------------------------------------------------------------------------------------- :)
 declare function xproc:evalAST(
   $ast as element(p:declare-step),
   $evalstep,
   $namespaces as element(namespace),
   $stdin as item()* ,
   $bindings,
   $outputs as item()?
 ) as item()* {
   let $steps := xproc:genstepnames( $ast )
   let $pipeline-name := $ast/@xproc:default-name
   let $_ := u:putInputMap($ast/@xproc:default-name,$stdin)
   return
     xproc:stepFoldEngine(
       $ast,
       $namespaces,
       $steps,
       $evalstep,
       $stdin
     )
 };

 
 (:~
  : entry point into xprocxq returning the final serialized output of pipeline processing
  :
  : @param $pipeline - xproc pipeline
  : @param $stdin - externally defined standard input
  : @param $bindings - externally declared port bindings
  : @param $options - externally declared options
  : @param $outputs - externally declared output
  : @param $dflag - debug flag
  : @param $tflag - timing flag
  :
  : @returns item()*
  :)
 (: ------------------------------------------------------------------------------------------------------------- :)
 declare function xproc:run($pipeline,$stdin as item()*,$bindings,$options,$outputs,$dflag as xs:integer ,$tflag as xs:integer) as item()*{
 (: ------------------------------------------------------------------------------------------------------------- :)
 let $validate   := () (: validation:jing($pipeline,fn:doc($const:xproc-rng-schema)) :)
 let $namespaces := xproc:enum-namespaces($pipeline)
 let $parse      := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type( $pipeline ))))
 let $b          := $parse/*
 let $ast        := element p:declare-step {$parse/@*,
   $parse/namespace::*,
   namespace p {"http://www.w3.org/ns/xproc"},
   namespace xproc {"http://xproc.net/xproc"},
   namespace ext {"http://xproc.net/xproc/ext"},
   namespace opt {"http://xproc.net/xproc/opt"},
   namespace c {"http://www.w3.org/ns/xproc-step"},
   namespace xprocerr {"http://www.w3.org/ns/xproc-error"},
   namespace xxq-error {"http://xproc.net/xproc/error"},
   parse:pipeline-step-sort( $b,  element p:declare-step {$parse/@*[name(.) ne 'xproc:default-name'],  attribute xproc:default-name{$const:init_unique_id} } )
 }
 let $checkAST          := u:assert(not(empty($ast/*[@xproc:step])),"pipeline AST has no steps")
 let $eval_result       := xproc:evalAST($ast,$xproc:eval-step,$namespaces,$stdin,$bindings,())
 let $serialized_result := xproc:output($eval_result,$dflag)
 return
 $serialized_result
};


(:~ waiting for fn:function-lookup() to be supported by XQuery implementations
 :
 : This is a *temporary* function as a dynamic function constructor
 : it eventually will be replaced by the new fn:function-lookup() 
 : function which will make its way into the final xquery/xpath 3.0
 : specs
 :
 : @param $stepname - string containing name of element
 :
 : @returns function
 :
 :)
(: -------------------------------------------------------------------------- :)
declare function xproc:getstep($stepname as xs:string) {
(: -------------------------------------------------------------------------- :)
if ($stepname eq 'p:identity') then
  $std:identity
else if($stepname eq 'p:count') then
  $std:count
else if($stepname eq 'p:pack') then
  $std:pack
else if($stepname eq 'p:delete') then
  $std:delete
else if($stepname eq 'p:add-attribute') then
  $std:add-attribute
else if($stepname eq 'p:add-xml-base') then
  $std:add-xml-base
else if($stepname eq 'p:error') then
  $std:error
else if($stepname eq 'p:escape-markup') then
  $std:escape-markup
else if($stepname eq 'p:unescape-markup') then
  $std:unescape-markup
else if($stepname eq 'p:directory-list') then
  $std:directory-list
else if($stepname eq 'p:load') then
  $std:load
else if($stepname eq 'p:store') then
  $std:store
else if($stepname eq 'p:make-absolute-uris') then
  $std:make-absolute-uris
else if($stepname eq 'p:compare') then
  $std:compare
else if($stepname eq 'p:label-elements') then
  $std:label-elements
else if($stepname eq 'ext:pre') then
  $ext:pre
else if($stepname eq 'p:rename') then
  $std:rename
else if($stepname eq 'p:filter') then
  $std:filter
else if($stepname eq 'p:string-replace') then
  $std:string-replace
else if($stepname eq 'p:split-sequence') then
  $std:split-sequence
else if($stepname eq 'p:sink') then
  $std:sink
else if($stepname eq 'p:set-attributes') then
  $std:set-attributes
else if($stepname eq 'p:rename') then
  $std:rename
else if($stepname eq 'p:wrap') then
  $std:wrap
else if($stepname eq 'p:wrap-sequence') then
  $std:wrap-sequence
else if($stepname eq 'p:unwrap') then
  $std:unwrap
else if($stepname eq 'p:exec') then
  $opt:exec
else if($stepname eq 'p:xslt') then
  $std:xslt
else if($stepname eq 'p:xquery') then
  $opt:xquery
else if($stepname eq 'ext:post') then
  $ext:post
else if($stepname eq 'p:group') then
  $xproc:group
else if($stepname eq 'p:try') then
  $xproc:try
else if($stepname eq 'p:catch') then
  $std:identity
else if($stepname eq 'p:for-each') then
  $xproc:for-each
else if($stepname eq 'p:viewport') then
  $xproc:viewport
else if($stepname eq 'p:choose') then
  $xproc:choose
else if($stepname eq 'p:replace') then
  $std:replace
else if($stepname eq 'p:insert') then
  $std:insert
else if($stepname eq 'ext:xproc') then
  $xproc:xproc-run
else if($stepname eq 'p:namespace-rename') then
  $std:namespace-rename
else if($stepname eq 'p:xinclude') then
  $std:xinclude
else
 $std:identity
};

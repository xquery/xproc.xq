(:
: Licensed under the Apache License, Version 2.0 (the "License");
: you may not use this file except in compliance with the License.
: You may obtain a copy of the License at
:
: http://www.apache.org/licenses/LICENSE-2.0
:
: Unless required by applicable law or agreed to in writing, software
: distributed under the License is distributed on an "AS IS" BASIS,
: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
: See the License for the specific language governing permissions and
: limitations under the License.
:)

xquery version "3.0"  encoding "UTF-8";

(: ----------------------------------------------------------------------------

    xproc-impl.xqy -

 ---------------------------------------------------------------------------- :)

module namespace xproc = "http://xproc.net/xproc";

import module namespace     p  = "http://www.w3.org/ns/xproc"
  at "/xquery/funcs/functions.xqy";

import module namespace const  = "http://xproc.net/xproc/const"
  at "/xquery/core/const.xqy";

import module namespace parse  = "http://xproc.net/xproc/parse"
  at "/xquery/core/parse.xqy";

import module namespace output = "http://xproc.net/xproc/output"
  at "/xquery/core/output.xqy";

import module namespace     u  = "http://xproc.net/xproc/util"
  at "/xquery/core/util.xqy";

import module namespace   std  = "http://xproc.net/xproc/std"
  at "/xquery/steps/std.xqy";

import module namespace   opt  = "http://xproc.net/xproc/opt"
  at "/xquery/steps/opt.xqy";

import module namespace   ext  = "http://xproc.net/xproc/ext"
  at "/xquery/steps/ext.xqy";

declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace xprocerr="http://www.w3.org/ns/xproc-error";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";
declare namespace err="http://www.w3.org/2005/xqt-errors";

declare copy-namespaces preserve, inherit;

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare variable $xproc:xproc-run       := xproc:xproc-run#4;
declare variable $xproc:run-step        := xproc:run#7;
declare variable $xproc:eval-step-func  := xproc:evalstep#4;
declare variable $xproc:declare-step    := ();
declare variable $xproc:library         := ();
declare variable $xproc:pipeline        := ();
declare variable $xproc:variable        := ();

(: ------------------------------------------------------------------------ :)
(: COMPONENT STEPS                                                          :)
(: ------------------------------------------------------------------------ :)

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
declare
%xproc:step
function xproc:xproc-run($primary,$secondary,$options,$currentstep) {
(: -------------------------------------------------------------------------- :)
let $pipeline := u:get-secondary('pipeline',$secondary)/*
let $bindings := u:get-secondary('binding',$secondary)/*
let $dflag  as xs:integer  := xs:integer(u:get-option('dflag',$options,$primary))
let $tflag  as xs:integer  := xs:integer(u:get-option('tflag',$options,$primary))
return xproc:run($pipeline,$primary,$bindings,$options,(),$dflag ,$tflag) 
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
declare
%xproc:step
function xproc:group(
    $primary,
    $secondary,
    $options,
    $currentstep
){
(: -------------------------------------------------------------------------- :)
let $namespaces  := xproc:enum-namespaces($currentstep)
let $defaultname as xs:string := string($currentstep/@xproc:default-name)
let $sorted := parse:pipeline-step-sort(  $currentstep/node(), ())
let $ast := <p:declare-step name="{$defaultname}"
    xproc:default-name="{$defaultname}" >{$sorted}
</p:declare-step>
return
   output:interim-serialize(
       xproc:evalAST($ast,$xproc:eval-step-func,$namespaces,$primary,(),())
   ,0,1)
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
declare
%xproc:step
function xproc:try(
    $primary,
    $secondary,
    $options,
    $currentstep
)
{
(: -------------------------------------------------------------------------- :)
let $namespaces  := xproc:enum-namespaces($currentstep)
let $defaultname as xs:string := string($currentstep/@xproc:default-name)
let $ast-try-sorted := parse:pipeline-step-sort($currentstep/*[name(.) ne "p:catch"],())
let $ast-try := <p:declare-step xproc:default-name="{$defaultname}">
    {$ast-try-sorted}
    {xproc:genExtPost($ast-try-sorted)}
    </p:declare-step>
let $ast-catch-sorted := parse:pipeline-step-sort(
            $currentstep/p:catch/*  ,())
let $ast-catch := <p:declare-step xproc:default-name="{$defaultname}">
        {$ast-try-sorted/ext:pre}
        {$ast-catch-sorted}
    </p:declare-step>
    return
  try{
   output:interim-serialize(xproc:evalAST($ast-try,$xproc:eval-step-func,$namespaces,$primary,(),()), 0,1)
  }catch * {
   output:interim-serialize(xproc:evalAST($ast-catch,$xproc:eval-step-func,$namespaces,$primary,(),()), 0,1)
  }
};


 (:~ p:choose step implementation
 :
 :
 : @param $primary -
 : @param $secondary -
 : @param $options -
 : @param $currentstep -
 :
 : @returns
 :)
declare
%xproc:step
function xproc:choose(
  $primary,
  $secondary,
  $options,
  $currentstep
) {

let $ast := <p:declare-step>{$currentstep}</p:declare-step>
let $namespaces := xproc:enum-namespaces($currentstep)
let $defaultname as xs:string := string($currentstep/@xproc:default-name)

let $xpath-context :=
    xproc:resolve-port-binding(
        $currentstep/ext:pre/p:xpath-context/*,
        (),
        $ast,
        $currentstep)

let $context :=
if($xpath-context)
    then $xpath-context
    else
        xproc:eval-primary(
            $ast,
            $currentstep,
            $primary,
            ()
        )

let $when-test := for $when at $count in $currentstep/p:when
          let $check-when-test := u:assert(not($when/@test eq ''),"p:choose when test attribute cannot be empty")
          return
             if ( u:value($context,$when/@test)) then $count else ()
return
  if($when-test) then
    let $when-sorted :=  parse:pipeline-step-sort( $currentstep/p:when[$when-test]/node()  , () )
    let $ast-when := <p:declare-step name="{$defaultname}" xproc:default-name="{$defaultname}"><p:input port="source"/>
<p:output port="result"/>{$when-sorted}{xproc:genExtPost($when-sorted)}</p:declare-step>
    return
      output:interim-serialize(
        xproc:evalAST($ast-when,$xproc:eval-step-func,$namespaces,$context,(),()),
      0,1)
  else
    let $otherwise-sorted :=  parse:pipeline-step-sort( $currentstep/p:otherwise/node()  , () )
    let $ast-otherwise := <p:declare-step name="{$defaultname}" xproc:default-name="{$defaultname}" ><p:input port="source"/>
<p:output port="result"/>{$otherwise-sorted}{xproc:genExtPost($otherwise-sorted)}</p:declare-step>
    return
      output:interim-serialize(
        xproc:evalAST($ast-otherwise,$xproc:eval-step-func,$namespaces,$context,(),())
     , 0,1)

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
declare
%xproc:step
function xproc:for-each(
    $primary,
    $secondary,
    $options,
    $currentstep
)
{
(: -------------------------------------------------------------------------- :)
let $namespaces  := xproc:enum-namespaces($currentstep)
let $defaultname as xs:string := string($currentstep/@xproc:default-name)
let $iteration-select as xs:string := ($currentstep/ext:pre/p:iteration-source/@select/data(.),"/")[1]
let $sorted := parse:pipeline-step-sort($currentstep/node(),())
let $ast :=
  <p:declare-step name="{$defaultname}" xproc:default-name="{$defaultname}" >
    <p:input port="source"/>
    <p:output port="result"/>
    {$sorted}
  </p:declare-step>

let $iteration-source :=
    xproc:resolve-port-binding(
        $currentstep/ext:pre/p:iteration-source/*,
        (),
        $ast,
        $currentstep)

let $context :=
  ($iteration-source,
   xproc:eval-primary(
            $ast,
            $currentstep,
            $primary,
            ()
        )
  )[1]

  let $_ := u:log( u:value($context,$iteration-select) )
let $result :=
  for $item in u:value($context,$iteration-select)
  return output:interim-serialize(
      xproc:evalAST(
          $ast,
          $xproc:eval-step-func,
          $namespaces,
          $item,
          (),
          ())
      ,0,1)

return $result
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
declare
%xproc:step
function xproc:viewport(
    $primary,
    $secondary,
    $options,
    $currentstep
)
{
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
  output:interim-serialize(xproc:evalAST($ast,$xproc:eval-step-func,$namespaces,$item,(),()), 0,1)
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

(: ------------------------------------------------------------------------- :)
 (: PROCESSOR                                                                :)
(: ------------------------------------------------------------------------- :)


 (:~ resolve external bindings
 :
 : @param $a -
 : @param $b -
 :
 : @returns
 :)
 (: ------------------------------------------------------------------------- :)
 declare function xproc:resolve-external-bindings($a,$b) {
 (: ------------------------------------------------------------------------- :)
 ()
 };


 (:~ generates a sequence of xs:string containing step names
 :
 : @param $step -
 :
 : @returns xs:string of xproc:default-name
 :)
 (: ------------------------------------------------------------------------- :)
 declare function xproc:genstepnames($step) as xs:string* {
 (: ------------------------------------------------------------------------- :)
      for $name in $step/*[@xproc:step eq "true"]
        return
          $name/@xproc:default-name
 };


 (:~ resolve p:document input port bindings
 :
 : @param $href - href of document you wish to access
 :
 : @returns
 :)
 (: ------------------------------------------------------------------------- :)
 declare function xproc:resolve-document-binding($href as xs:string) as item(){
 (: ------------------------------------------------------------------------- :)
    if (starts-with($href,"http://")) then
      u:http-get($href)
    else
      if(fn:doc-available($href))
      then
          let $doc := doc($href)/node()
          return std:add-xml-base($doc,(),(),())
(:
  try {
      } catch * {
          u:dynamicError('xprocerr:XD0002',
            concat(" cannot access document ",$href))
      }
      :)
      else u:dynamicError('xprocerr:XD0002',
             concat("document ",$href," does not exist"))
 };


(:~ resolve p:data input port bindings
 :
 :
 : @param $href - xs:string
 : @param $wrapper  - xs:string
 :
 : @returns c:data
 :)
 (: ------------------------------------------------------------------------- :)
 declare function xproc:resolve-data-binding($input as element(p:data)*){
 (: ------------------------------------------------------------------------- :)

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
 (: ------------------------------------------------------------------------- :)
 declare function xproc:resolve-inline-binding($inline as item()*,$currentstep){
 (: ------------------------------------------------------------------------- :)
 let $ns := u:enum-ns(<dummy>{$currentstep}</dummy>)
 let $exclude-result-prefixes as xs:string := string($inline/@exclude-inline-prefixes)
 let $template := <xsl:stylesheet version="2.0" exclude-result-prefixes="{$exclude-result-prefixes}">
       {for $n in $ns return
       if($n/@URI ne '') then namespace {$n/@prefix} {$n/@URI} else ()
       }
       {$const:xslt-output}
       <xsl:template match="/">
         <xsl:copy-of select="*"/>
       </xsl:template>
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
 (: ------------------------------------------------------------------------- :)
 declare function xproc:resolve-port-binding(
     $input,
     $outputs,
     $ast,
     $currentstep
 ){
 (: ------------------------------------------------------------------------- :)
   typeswitch($input)
     case element(p:empty)
       return ()
     case element(p:inline)
       return xproc:resolve-inline-binding($input/*,$currentstep)
     case element(p:document)
       return xproc:resolve-document-binding($input/@href/data(.))
     case element(p:data)
       return xproc:resolve-data-binding($input)
     case element(p:pipe)
       return u:getInputMap($input/@xproc:step-name/data(.), $input/@port/data(.))
     default 
       return
         u:dynamicError('xprocerr:XD0001',concat("cannot bind to port: ",$input/@port," step: ",$input/@step,' ',u:serialize($currentstep,$const:TRACE_SERIALIZE)))
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
 (: ------------------------------------------------------------------------ :)
 declare function xproc:eval-secondary(
     $ast as element(p:declare-step),
     $currentstep,
     $primaryinput as item()*,
     $outputs as item()*
 ){
 (: ------------------------------------------------------------------------ :)
 let $step-name as xs:string := string($currentstep/@xproc:default-name)
 return

 for $pinput in $currentstep//p:input[@primary eq "false"]
 return
 <xproc:input port="{$pinput/@port}" select="/" step="{$step-name}">
   {
 let $data :=  if($pinput/*) then
       for $input in $pinput/*
       return
          xproc:resolve-port-binding($input,$outputs,$ast,$currentstep) 
       else         
         u:getInputMap($pinput/p:pipe/@xproc:step-name, $pinput/p:pipe/@port/data(.))
                    
let $result :=  u:evalXPATH(string($pinput/@select),$data)
let $_ := u:putInputMap($step-name, ($pinput/@port/data(.),"result")[1], $result)
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
 declare function xproc:eval-primary(
   $ast as element(p:declare-step),
   $currentstep,
   $primaryinput as item()*,
   $outputs as item()*
 )
 {
  let $step-name as xs:string := string($currentstep/@xproc:default-name)
 let $pinput as element(p:input)? := $currentstep/p:input[@primary eq 'true']
 let $data :=  if($pinput/*) then
       for $input in $pinput/*
       return xproc:resolve-port-binding($input,$outputs,$ast,$currentstep)
       else $primaryinput

let $result := u:evalXPATH( $pinput/@select/data(.),$data)

 let $_ := u:putInputMap( $step-name, ($currentstep/p:input[@primary eq 'true']/@port/data(.),"result")[1], $result)
 return
   if ($result) then     
     if ($result instance of document-node()) then $result else document{$result}
   else
      u:dynamicError('xprocerr:XD0016',concat("xproc step ",$step-name, "did not select anything from p:input")) 
};


declare function xproc:noop($a,$b,$c,$d){
 ()
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
 (: ------------------------------------------------------------------------- :)
 declare function xproc:evalstep (
   $step,
   $namespaces,
   $primary as item()*,
   $ast as element(p:declare-step)
 )
 {
 (: ------------------------------------------------------------------------- :)
 let $variables    := ()
 let $with-options :=  <xproc:options>
         {$namespaces}
         {$ast/*[@xproc:default-name eq $step]/p:with-option}
     </xproc:options>
 let $currentstep  := $ast/*[@xproc:default-name eq $step]
 let $stepfunction as function(*):=
     if ($currentstep/@type or $currentstep/@xproc:func eq "")
         then
         if($ast/p:declare-stype/@xproc:type eq "declare-step")
             then xproc:xproc-run#4
             else std:identity#4
         else function-lookup(
             xs:QName(substring-before($currentstep/@xproc:func,'#')),
               xs:integer(substring-after($currentstep/@xproc:func,'#')))
 return
 if($currentstep/@xproc:func eq "xproc:noop#4")
     then
        ()
     else
         let $primary-result   := xproc:eval-primary($ast,$currentstep,$primary, ())
         let $secondary-result := xproc:eval-secondary($ast,$currentstep,$primary,())
         let $log-href := $currentstep/p:log/@href
         let $log-port := $currentstep/p:log/@port
         let $result := $stepfunction(
             if ($primary-result)
                 then $primary-result
                 else $primary-result,$secondary-result,$with-options,$currentstep)
         let $_ := u:putInputMap(
             $step, ($currentstep/p:output/@port/data(.),"result")[1], $result)
         return $result
 };


 (:~
  : xproc pipeline is processed using a step fold function
  :
  : This is the central mechanism by which xprocxq works. By using a step-fold
  : function we have a flexible method of working with xproc branches, ext:xproc
  : invokes, as well as opening up all sorts of possibilities to work Map/Reduce
  : style.
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
 (: ------------------------------------------------------------------------ :)
 declare function xproc:stepFoldEngine(
   $ast as element(p:declare-step),
   $namespaces as element(namespace),
   $steps as xs:string*,
   $f as function(*),
   $primary as item()*
){
(
  $ast,
  fn:fold-left(function($primary,$step){ $f($step,$namespaces,$primary,$ast) }, $primary, $steps)
)
};


 (:~
  :  for xproc:stepFoldEngine 
  :
  : This level of abstraction is probably temporary
  :
  : @param $ast - abstract syntax tree representing pipeline
  : @param $evalstep - function for evaluating each step is chosen at runtime
  : @param $namespaces - all namespaces that are used within pipeline
  : @param $stdin - standard input 
  : @param $bindings - declared port bindings
  : @param $outputs - starting outputs, used for ext:xproc and branching pipelines
  :
  : @returns 
  :)
 (: ------------------------------------------------------------------------- :)
 declare function xproc:evalAST(
   $ast as element(p:declare-step),
   $evalstep as function(*),
   $namespaces as element(namespace),
   $stdin as item()* ,
   $bindings as item()?,
   $outputs as item()?
) as item()*
{
   let $steps := xproc:genstepnames($ast)
   let $_ := if($stdin) then u:putInputMap($ast/@xproc:default-name/data(.),"source",$stdin) else ()
   let $_ := if($stdin) then u:putInputMap($ast/@xproc:default-name/data(.),"result",$stdin) else ()
   let $_ := for $bind in $bindings return u:putInputMap($ast/@xproc:default-name/data(.), $bind/@name/data(.), $bind/*) 
   return
     xproc:stepFoldEngine(
       $ast,
       $namespaces,
       $steps,
       $evalstep,
       $stdin
     )
 };

 
(: ------------------------------------------------------------------------- :)
 (: INTERNAL ENTRY POINT                                                     :)
(: ------------------------------------------------------------------------- :)

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
declare function xproc:run(
    $pipeline,
    $stdin as item()*,
    $bindings,
    $options,
    $outputs,
    $dflag as xs:integer,
    $tflag as xs:integer
    ) as item()*
{
 let $episode := u:episode()
 let $start := u:startMap($episode)       
 let $validate   := () (: validation:jing($pipeline,fn:doc($const:xproc-rng-schema)) :)
 let $namespaces := xproc:enum-namespaces($pipeline)
 let $parse      := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type( $pipeline ))))
 let $ast        := element p:declare-step {$parse/@*,
   u:ns-axis($parse),  
   namespace p {"http://www.w3.org/ns/xproc"},
   namespace xproc {"http://xproc.net/xproc"},
   namespace ext {"http://xproc.net/xproc/ext"},
   namespace opt {"http://xproc.net/xproc/opt"},
   namespace c {"http://www.w3.org/ns/xproc-step"},
   namespace xprocerr {"http://www.w3.org/ns/xproc-error"},
   namespace xxq-error {"http://xproc.net/xproc/error"},
   parse:pipeline-step-sort( $parse/*,  element p:declare-step {$parse/@*[name(.) ne 'xproc:default-name'],  attribute xproc:default-name{$const:init_unique_id} } )
 }
 let $checkAST    := u:assert(not(empty($ast/*[@xproc:step])),"pipeline AST has no steps")
 let $eval_result := xproc:evalAST($ast,$xproc:eval-step-func,$namespaces,$stdin,$bindings,())
 return (output:serialize($eval_result,$dflag),u:stopMap())

};


declare function xproc:run(
    $pipeline,
    $stdin as item()*,
    $bindings,
    $options,
    $outputs,
    $dflag as xs:integer,
    $tflag as xs:integer,
    $func as function(*)
    ) as item()*
{
 let $episode := u:episode()    
 let $start := u:startMap($episode)   
 let $validate   := () (: validation:jing($pipeline,fn:doc($const:xproc-rng-schema)) :)
 let $namespaces := xproc:enum-namespaces($pipeline)
 let $parse      := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type( $pipeline ))))
 let $ast        := element p:declare-step {$parse/@*,

   u:ns-axis($parse),  
   namespace p {"http://www.w3.org/ns/xproc"},
   namespace xproc {"http://xproc.net/xproc"},
   namespace ext {"http://xproc.net/xproc/ext"},
   namespace opt {"http://xproc.net/xproc/opt"},
   namespace c {"http://www.w3.org/ns/xproc-step"},
   namespace xprocerr {"http://www.w3.org/ns/xproc-error"},
   namespace xxq-error {"http://xproc.net/xproc/error"},
   parse:pipeline-step-sort( $parse/*,  element p:declare-step {$parse/@*[name(.) ne 'xproc:default-name'],  attribute xproc:default-name{$const:init_unique_id} } )
 }
 let $checkAST    := u:assert(not(empty($ast/*[@xproc:step])),"pipeline AST has no steps")
 let $eval_result := xproc:evalAST($ast, ($func,$xproc:eval-step-func)[1],$namespaces,$stdin,$bindings,())
 return (output:serialize($eval_result,$dflag), u:stopMap())
};


(: ------------------------------------------------------------------------- :)
 (: DEPRECATION ?                                                            :)
(: ------------------------------------------------------------------------- :)

(:~ migrate to parse ?
 :
 : @param $sorted -
 :
 : @returns
 :)
declare function xproc:genExtPost(
  $sorted
) {
<ext:post xproc:step="true" xproc:func="ext:post#4" xproc:default-name="{$sorted[1]/@xproc:default-name}!">
  <p:input port="source" primary="true" select="/" xproc:type="comp">
    <p:pipe port="result" xproc:type="comp" step="{$sorted[last()]/@xproc:default-name}" xproc:step-name="{$sorted[last()]/@xproc:default-name}"/>
  </p:input>
<p:output primary="true" port="result" xproc:type="comp" select="/"/>
</ext:post>
};



 (:~
  : DEPRECATE - REPLACE WITH u:enum-ns ... lists all namespaces which are declared and in use within pipeline 
  : @TODO possibly move to util.xqm and delineate between declared and in use
  :
  : @param $pipeline - returns all in use namespaces

  : @returns <namespace/> element
  :)
 (: ---------------------------------------------------------------- :)
 declare function xproc:enum-namespaces($pipeline) as element(namespace){
 (: ---------------------------------------------------------------- :)
    <namespace name="{$pipeline/@name}">{
let $element := if ($pipeline instance of document-node()) then $pipeline/* else $pipeline

for $ns in distinct-values($element//*/in-scope-prefixes(.))
return
        if ($ns eq 'xml' or $ns eq '')
        then ()
        else <ns prefix="{$ns}">{try{($element//* ! namespace-uri-for-prefix($ns,.))[1]}catch * { $err:description, $err:value, " module: ",
    $err:module, "(", $err:line-number, ",", $err:column-number, ")"}}</ns>
        }</namespace>
};

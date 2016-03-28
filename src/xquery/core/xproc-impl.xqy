xquery version "3.1"  encoding "UTF-8";

module namespace xproc = "http://xproc.net/xproc";

import module namespace const  = "http://xproc.net/xproc/const"
    at "const.xqy";

import module namespace parse  = "http://xproc.net/xproc/parse"
    at "parse.xqy";

import module namespace output = "http://xproc.net/xproc/output"
    at "output.xqy";

import module namespace u="http://xproc.net/xproc/util"
    at "../lib/util.xqy";

import module namespace   std  = "http://xproc.net/xproc/std"
    at "../steps/std.xqy";

import module namespace   opt  = "http://xproc.net/xproc/opt"
  at "../steps/opt.xqy";

import module namespace   ext  = "http://xproc.net/xproc/ext"
  at "../steps/ext.xqy";

(: declarations :)

declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";
declare namespace map="http://marklogic.com/xdmp/map";

declare default function namespace "http://www.w3.org/2005/xpath-functions";
declare copy-namespaces no-preserve,no-inherit;

declare variable $xproc:std-step-functions := u:get-step-functions("std");
declare variable $xproc:default-steprunner := function($ast,$namespaces,$step,$input){
        let $stepfunc as function(*):= xproc:get-step-function($step)
        let $steparity := function-arity($stepfunc)
        return
           if ($steparity eq 1)
           then $stepfunc($input)
        else $stepfunc($input,(),(),())};


(: functions :)

declare function xproc:run(
    $pipeline,
    $source as item()*,
    $bindings,
    $options,
    $outputs,
    $dflag as xs:boolean,
    $tflag as xs:boolean,
    $stepRunnerFunc as function(*)
    ) as item()*
{
    let $episode := u:episode()
    let $ns := ()
    let $ast := parse:parse($pipeline)

    let $statements := parse:get-flow-statements($ast)
    let $inputs := parse:get-flow-inputs($ast)
    let $outputs := parse:get-flow-inputs($ast)

    let $results := map:new()

    let $_:=
    for $flow at $c in $statements
      let $flow-name := $const:init_unique_id || "." || $c
      let $flow-result := map:new()
      let $input-binding := parse:get-input-binding($flow)
      let $input-binding-name := parse:get-input-binding-name($input-binding)
      let $step-chain := parse:get-step-chains($flow)
      let $step-chain-items := parse:get-chain-item($step-chain)
      let $sequence-literal := parse:get-sequence-literal($step-chain)
      let $output-binding := parse:get-output-binding($flow)
      let $output-binding-name := parse:get-output-binding-name($output-binding)
      let $_ := map:put($flow-result, $input-binding-name, $source)
      let $_ := map:put($flow-result,
       $output-binding-name,
        xproc:stepFoldEngine(
            $ast,$ns,$stepRunnerFunc,$step-chain-items,map:get($flow-result,$input-binding-name)))
      return map:put($results,$flow-name,$flow-result)
    return output:serialize($episode,$results,$ast,$dflag)
};

declare %private function xproc:get-step-function(
    $function-name as xs:string
) as function(*)
{
    let $func := u:get-step-functions($function-name)
    return
      if($func instance of function(*))
      then $func
      else u:xprocxqError("XD0017", "'" || $function-name || "' step not found")
};

declare %private function xproc:stepFoldEngine(
   $ast as element(),
   $ns,
   $f as function(*),
   $step-chain-items as element()*,
   $source as item()*
 ){
    fn:fold-left(
        function($source,$step-chain-item){
            let $chain-item := parse:get-chained-item($step-chain-item)
            let $step-name := parse:get-chained-item-step-name($chain-item)
            return $f($ast,$ns,$step-name,$source)
        },$source, $step-chain-items)
};

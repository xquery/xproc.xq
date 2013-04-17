xquery version "1.0-ml"  encoding "UTF-8";

module namespace output = "http://xproc.net/xproc/output";

declare boundary-space strip;
declare copy-namespaces preserve,no-inherit;

 import module namespace const  = "http://xproc.net/xproc/const"  at "/xquery/core/const.xqy";
 import module namespace     u  = "http://xproc.net/xproc/util"   at "/xquery/core/util.xqy";

 (:~ declare namespaces :)
 declare namespace xproc = "http://xproc.net/xproc";

 declare default function namespace "http://www.w3.org/2005/xpath-functions";

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
 declare function output:serialize($result,$dflag as xs:integer) as item()*{
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
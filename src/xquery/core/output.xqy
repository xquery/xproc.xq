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

(: -------------------------------------------------------------------------------------

    output.xqy - 

 ---------------------------------------------------------------------------------------- :)

module namespace output = "http://xproc.net/xproc/output";

import module namespace const  = "http://xproc.net/xproc/const"  at "/xquery/core/const.xqy";
import module namespace     u  = "http://xproc.net/xproc/util"   at "/xquery/core/util.xqy";

declare namespace xproc = "http://xproc.net/xproc";
declare namespace map ="http://marklogic.com/xdmp/map";
declare namespace ext = "http://xproc.net/xproc/ext";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

(:~ output:seriaize - serializes output 
 :
 : @param $result - all outputs from the result of processing pipeline
 :                  $result[1] - abstract tree
 :                  $result[2...n] - result
 :
 : @param $dflag - if true will output full processing trace
 :
 : @returns item()* 
 :)
(: -------------------------------------------------------------------------- :)
declare function output:serialize(
    $result as item()*,
    $dflag as xs:integer
    ) as item()*
{

 let $ast :=subsequence($result,1,1)
 return
    if($dflag eq 1) then
    element xproc:debug{
        attribute episode {u:get-episode()},
        element xproc:pipeline {$ast},
        element xproc:outputs {
            u:getAllResult()
        }

    } else u:getResult()
 };

(:~ output:seriaize - serializes output from xproc component steps
 :
 :  group, for-each, try/catch, viewport, choose
 :
 : @param $result - all outputs from the result of processing pipeline
 :                  $result[1] - abstract tree
 :                  $result[2...n] - result
 :
 : @param $dflag - if true will output full processing trace
 :
 : @returns item()* 
 :)
(: -------------------------------------------------------------------------- :)
declare function output:interim-serialize(
    $result as item()*,
    $dflag as xs:integer,
    $level as xs:integer
    ) as item()*
{ 
 let $ast :=subsequence($result,1,1)
 return
      subsequence($result,2)
 };
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

(:~ ------------------------------------------------------------------------------------- 
  
	xproc.xq - entry points
	
---------------------------------------------------------------------------------------- :)

module namespace xprocxq = "http://xproc.net/xprocxq";

import module namespace xproc = "http://xproc.net/xproc" at "/xquery/core/xproc-impl.xqy";

declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";

declare copy-namespaces no-preserve, inherit;


 (:~
  : simplified entry point into xproc.xq returning the final serialized output of pipeline processing
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
declare function xprocxq:xq(
    $pipeline,
    $stdin
    ) as item()*
{
 xproc:run($pipeline,$stdin,(),(),(),0,0,$xproc:eval-step-func)
};

declare function xprocxq:xq(
    $pipeline,
    $stdin,
    $time,
    $debug as xs:integer
    ) as item()*
{
 xproc:run($pipeline,$stdin,(),(),(),$debug,0,$xproc:eval-step-func)
};


declare function xprocxq:xq(
    $pipeline,
    $stdin,
    $evalstep
    ) as item()*
{
 xproc:run($pipeline,$stdin,(),(),(),0,0,$evalstep)
};

 (:~
  : entry point into xproc.xq returning the final serialized output of pipeline processing
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
declare function xprocxq:xq(
    $pipeline as item(),
    $stdin as item()*,
    $bindings as item()?,
    $options as item()?,
    $outputs as item()?,
    $dflag as xs:integer?,
    $tflag as xs:integer?
    ) as item()*
{
 xproc:run($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag,$xproc:eval-step-func)   
};


 (:~
  : entry point into xproc.xq returning the final serialized output of pipeline processing
  :
  : @param $pipeline - xproc pipeline
  : @param $stdin - externally defined standard input
  : @param $bindings - externally declared port bindings
  : @param $options - externally declared options
  : @param $outputs - externally declared output
  : @param $dflag - debug flag
  : @param $tflag - timing flag
  : @param $evalstepfunc -
  :
  : @returns item()*
  :)
declare function xprocxq:xq(
    $pipeline as item(),
    $stdin as item()*,
    $bindings as item()?,
    $options as item()?,
    $outputs as item()?,
    $dflag as xs:integer?,
    $tflag as xs:integer?,
    $evalstepfunc as function(*)
    ) as item()*
{
 xproc:run($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag,$evalstepfunc)   
};
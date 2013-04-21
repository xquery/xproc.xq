xquery version "3.0"  encoding "UTF-8";

module namespace xprocxq = "http://xproc.net/xprocxq";

(:~ module imports :)
import module namespace xproc = "http://xproc.net/xproc" at "/xquery/core/xproc-impl.xqy";

declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";

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
 xproc:run($pipeline,$stdin,(),(),(),0,0)   
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
 xproc:run($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)   
};
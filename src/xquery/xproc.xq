xquery version "3.0"  encoding "UTF-8";

module namespace xprocxq = "http://xproc.net/xprocxq";

(:~ module imports :)
import module namespace xproc = "http://xproc.net/xproc" at "/xquery/core/xproc-impl.xqy";

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
declare function xprocxq:xq(
    $pipeline,
    $stdin,
    $bindings,
    $options,
    $outputs,
    $dflag as xs:integer,
    $tflag as xs:integer
    ) as item()*
{
 xproc:run2($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)   
};





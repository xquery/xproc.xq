xquery version "3.0"  encoding "UTF-8";

module namespace xxq = "http://xproc.net/xprocxq";

(: imports :)
import module namespace xproc = "http://xproc.net/xproc"
  at "core/xproc-impl.xqy";

(: declarations :)
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";

declare default function namespace "http://www.w3.org/2005/xpath-functions";
declare copy-namespaces no-preserve,no-inherit;

declare function xxq:run(
    $pipeline,
    $stdin as item()*
) as item()*
{
    xxq:run(
        $pipeline,$stdin,
        (),
        (),
        (),
        false(),
        false(),
        $xproc:default-steprunner)
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
declare function xxq:run(
    $pipeline,
    $stdin as item()*,
    $bindings as item()?,
    $options as item()?,
    $outputs as item()?,
    $dflag as xs:boolean,
    $tflag as xs:boolean,
    $evalstepfunc
    ) as item()*
{
    xproc:run(
        $pipeline,
        $stdin,
        $bindings,
        $options,
        $outputs,
        $dflag,
        $tflag,
        ($evalstepfunc,$xproc:default-steprunner)[1])
};

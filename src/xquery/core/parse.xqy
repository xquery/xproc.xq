xquery version "3.0"  encoding "UTF-8";

module namespace parse = "http://xproc.net/xproc/parse";

(: imports :)

import module namespace const = "http://xproc.net/xproc/const"
    at "const.xqy";

import module namespace g = "grammar"
    at "grammar.xqy";

import module namespace u = "http://xproc.net/xproc/util"
    at "../lib/util.xqy";


(: declarations :)

declare namespace xproc = "http://xproc.net/xproc";
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare default function namespace "http://www.w3.org/2005/xpath-functions";
declare copy-namespaces no-preserve,no-inherit;

declare option output:encoding "utf-8";
declare option output:indent   "yes";

declare function parse:parse(
    $inputstring as xs:string
)
{
    validate lax { g:parse-XProc($inputstring) }
};

declare function parse:get-prolog(
    $flow
)
{
    $flow
};

declare function parse:get-flow-inputs(
    $flow
)
{
    $flow
};

declare function parse:get-flow-outputs(
    $prolog
)
{
    $prolog
};

declare function parse:get-flow(
    $ast
)
{
    $ast/*/XProcFlow
};


declare function parse:get-flow-statements(
    $ast
)
{
    $ast/*/XProcFlow/XProcFlowStatement
};

declare function parse:get-step-chains(
    $xprocstepchain
)
{
    $xprocstepchain/XProcStepChain
};


declare function parse:get-chain-item(
    $xprocstepchain
)
{
    $xprocstepchain/XProcStepChainItem
};

declare function parse:get-sequence-literal(
    $xprocstepchain
)
{
    $xprocstepchain/XProcSequenceLiteral
};

declare function parse:get-input-binding(
    $xprocstepchain
)
{
    $xprocstepchain/XProcStepChain/XProcSequenceLiteral
};

declare function parse:get-input-binding-name(
    $xprocstepchain
)
{
    $xprocstepchain/*/XProcPortInput/XProcPortRef/QName/FunctionName/QName/data()
};

declare function parse:get-output-binding(
    $xprocstepchain
)
{
    $xprocstepchain/XProcOutputBinding
};

declare function parse:get-chained-item(
    $xprocstepchainitem
)
{
    $xprocstepchainitem/XProcChainedItem
};

declare function parse:get-output-binding-name(
    $xprocoutputbinding
)
{
    $xprocoutputbinding/XProcOutputItem/XProcPortRef/QName/FunctionName/QName/data()
};

declare function parse:get-chained-item-step-name(
    $xprocstepchaineditem
)
{
    $xprocstepchaineditem/XProcChainItem/XProcStepInvocation/XProcStepName/QName/FunctionName/QName/data()
};

declare function parse:get-sequence-literal-name(
    $sequence-literal
)
{
    $sequence-literal/XProcSequenceItem/XProcPortInput/XProcPortRef/QName/FunctionName/QName/data()
};

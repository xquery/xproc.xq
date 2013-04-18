xquery version "3.0" encoding "UTF-8";
module namespace ext = "http://xproc.net/xproc/ext";
(: ------------------------------------------------------------------------------------- 

	ext.xqm - implements all xprocxq specific extension steps.
	
 ---------------------------------------------------------------------------------------- :)

(: declare namespaces :)
declare namespace xproc = "http://xproc.net/xproc";
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";

(: declare namespaces :)

(: module imports :)
import module namespace const = "http://xproc.net/xproc/const" at "/xquery/core/const.xqy";
import module namespace u = "http://xproc.net/xproc/util" at "/xquery/core/util.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

(: declare functions :)

(: -------------------------------------------------------------------------- :)
declare
%xproc:step
function ext:pre($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
$primary
};


(: -------------------------------------------------------------------------- :)
declare
%xproc:step
function ext:post($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
$primary
};


(:~ @see xproc:xproc-run in xproc.xqm
 :
:)
(: -------------------------------------------------------------------------- :)
declare
%xproc:step
function ext:xproc($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
()
};


(:-------------------------------------------------------------------------- :)
declare
%xproc:step
function ext:xsltforms($primary,$secondary,$options,$variables){
(: TODO- unsure about the logic of this :)
(: -------------------------------------------------------------------------- :)
()
};



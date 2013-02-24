(: ------------------------------------------------------------------------------------- 

	ext.xqm - implements all xprocxq specific extension steps.
	
---------------------------------------------------------------------------------------- :)
xquery version "3.0" encoding "UTF-8";

module namespace ext = "http://xproc.net/xproc/ext";

(: declare namespaces :)

(: module imports :)
import module namespace const = "http://xproc.net/xproc/const" at "/xquery/const.xqy";
import module namespace u = "http://xproc.net/xproc/util" at "/xquery/util.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

(: declare functions :)
declare variable $ext:pre       := ext:pre#4;
declare variable $ext:post      := ext:post#4;
declare variable $ext:xproc     := ext:xproc#4;
declare variable $ext:xsltforms := ext:xsltforms#4;

(: -------------------------------------------------------------------------- :)
declare function ext:pre($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
$primary
};


(: -------------------------------------------------------------------------- :)
declare function ext:post($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
$primary
};


(:~ @see xproc:xproc-run in xproc.xqm
 :
:)
(: -------------------------------------------------------------------------- :)
declare function ext:xproc($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
()
};


(:-------------------------------------------------------------------------- :)
declare function ext:xsltforms($primary,$secondary,$options,$variables){
(: TODO- unsure about the logic of this :)
(: -------------------------------------------------------------------------- :)
()
};



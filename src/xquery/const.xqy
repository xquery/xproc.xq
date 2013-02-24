(:~ ------------------------------------------------------------------------------------- 
 
	const.xqm - contains all constants used by xprocxq.
	
---------------------------------------------------------------------------------------- :)
xquery version "1.0-ml" encoding "UTF-8";

module namespace const = "http://xproc.net/xproc/const";

(: -------------------------------------------------------------------------- :)
(:~ XProc Namespace Declaration :)
(: -------------------------------------------------------------------------- :)
declare namespace xproc = "http://xproc.net/xproc";
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

(: -------------------------------------------------------------------------- :)
(:~ XProc Namespace Constants :)
(: -------------------------------------------------------------------------- :)
declare variable $const:NS_XPROC      := "http://www.w3.org/ns/xproc";
declare variable $const:NS_XPROC_STEP := "http://www.w3.org/ns/xproc-step";
declare variable $const:NS_XPROC_ERR  := "http://www.w3.org/ns/xproc-error";


(: -------------------------------------------------------------------------- :)
(:~ Serialization Constants :)
(: -------------------------------------------------------------------------- :)
declare variable $const:DEFAULT_SERIALIZE  := 'method=xml indent=yes';
declare variable $const:TRACE_SERIALIZE    := 'method=xml';
declare variable $const:XINCLUDE_SERIALIZE := 'expand-xincludes=yes';
declare variable $const:TEXT_SERIALIZE     := 'method=text';
declare variable $const:ESCAPE_SERIALIZE   := 'method=xml indent=no';


(: -------------------------------------------------------------------------- :)
(:~ XProc Extension Namespaces :)
(: -------------------------------------------------------------------------- :)
declare variable $const:NS_XPROC_EXT     := "http://xproc.net/ns/xproc/ex";
declare variable $const:NS_XPROC_ERR_EXT := "http://xproc.net/ns/errors";


(: -------------------------------------------------------------------------- :)
(:~ Error Dictionary lookup :) (:~ @TODO - obviously need to remove these absolute paths :)
(: -------------------------------------------------------------------------- :)
declare variable $const:error :=  xdmp:document-get("/Users/jfuller/Source/Webcomposite/xprocxq_new/src/xquery/etc/error-codes.xml",<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>);
       
declare variable  $const:xprocxq-error  := xdmp:document-get("/Users/jfuller/Source/Webcomposite/xprocxq_new/src/xquery/etc/xproc-error-codes.xml",<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>);

(: -------------------------------------------------------------------------- :)
(:~ Step Definition lookup :) (:~ @TODO - obviously need to remove these absolute paths :)
(: -------------------------------------------------------------------------- :)
declare variable $const:ext-steps  := xdmp:document-get("/Users/jfuller/Source/Webcomposite/xprocxq_new/src/xquery/etc/pipeline-extension.xml",<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)/p:library; 
declare variable $const:std-steps  := xdmp:document-get("/Users/jfuller/Source/Webcomposite/xprocxq_new/src/xquery/etc/pipeline-standard.xml",<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)/p:library; 
declare variable $const:opt-steps  := xdmp:document-get("/Users/jfuller/Source/Webcomposite/xprocxq_new/src/xquery/etc/pipeline-optional.xml",<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)/p:library; 
declare variable $const:comp-steps := xdmp:document-get("/Users/jfuller/Source/Webcomposite/xprocxq_new/src/xquery/etc/xproc-component.xml",<options xmlns="xdmp:document-get">
           <repair>full</repair>
           <format>xml</format>
       </options>)/xproc:components;


(: -------------------------------------------------------------------------- :)
(:~ System Property :)
(: -------------------------------------------------------------------------- :)
declare variable $const:version :="0.9";
declare variable $const:product-version :="0.9";
declare variable $const:product-name :="xprocxq";
declare variable $const:vendor :="James Fuller";
declare variable $const:language :="en";
declare variable $const:vendor-uri :="http://www.xproc.net";
declare variable $const:xpath-version :="2.0";
declare variable $const:psvi-supported :="false";
declare variable $const:episode :="somerandomnumber";


(: -------------------------------------------------------------------------- :)
(:  :)
(: -------------------------------------------------------------------------- :)
declare variable $const:NDEBUG :=1;

(: -------------------------------------------------------------------------- :)
(:~ XProc default naming prefix :)
(: -------------------------------------------------------------------------- :)
declare variable $const:init_unique_id :="!1";

(: -------------------------------------------------------------------------- :)
(:~ Mime types :)
(: -------------------------------------------------------------------------- :)
declare variable $const:pdf-mimetype := 'application/pdf';

(: -------------------------------------------------------------------------- :)
(:~ XSLT to transform eXist specific file listing :)
(: -------------------------------------------------------------------------- :)
declare variable $const:directory-list-xslt := 'resource:net/xproc/xprocxq/etc/directory-list.xsl';

(: -------------------------------------------------------------------------- :)
(:~ RELAXNG Schema for XPROC :)
(: -------------------------------------------------------------------------- :)
declare variable $const:xproc-rng-schema := 'resource:net/xproc/xprocxq/etc/xproc.rng';

(: -------------------------------------------------------------------------- :)
(:~ default XSLT output element used in std.xqm :)
(: -------------------------------------------------------------------------- :)
declare variable $const:xslt-output := <xsl:output omit-xml-declaration="yes"/>;


declare variable $const:default-ns as xs:string:='


    import module namespace p="http://www.w3.org/ns/xproc" at "src/xquery/functions.xqm";

    declare namespace xproc = "http://xproc.net/xproc";
    declare namespace c="http://www.w3.org/ns/xproc-step";
    declare namespace err="http://www.w3.org/ns/xproc-error";
    declare namespace ex="http://www.example.org";
    declare namespace tmp="http://www.example.org";

    declare namespace test="http://xproc.org/ns/testsuite";
    declare namespace test2="http://xproc.org/ns/testsuite";
    declare namespace n="http://xproc.org/ns/testsuite";

    declare default function namespace "http://www.w3.org/2005/xpath-functions";

';


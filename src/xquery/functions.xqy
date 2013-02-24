xquery version "1.0" encoding "UTF-8";

module namespace func = "http://www.w3.org/ns/xproc";
(:~
 :
 :	functions.xqm - defines xproc xpath extensions.
 :
 :
 :	
 :)


(: declare namespaces :)

declare namespace c     = "http://www.w3.org/ns/xproc-step";
declare namespace err   = "http://www.w3.org/ns/xproc-error";
declare namespace xproc = "http://xproc.net/xproc";
declare namespace xsl   = "http://www.w3.org/1999/XSL/Transform";

(:~ declare import :)

import module namespace const = "http://xproc.net/xproc/const" at "const.xqm";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

(: -------------------------------------------------------------------------- :)



(: -------------------------------------------------------------------------- :)
declare function func:system-property($property){
(: -------------------------------------------------------------------------- :)
if ($property eq 'p:version') then
  $const:version
else if ($property eq 'p:episode') then
  $const:episode
else if ($property eq 'p:language') then
  $const:language
else if ($property eq 'p:product-name') then
  $const:product-name
else if ($property eq 'p:product-version') then
  $const:product-version
else if ($property eq 'p:vendor-uri') then
  $const:vendor-uri
else if ($property eq 'p:vendor') then
  $const:vendor
else if ($property eq 'p:xpath-version') then
  $const:xpath-version
else if ($property eq 'p:psvi-supported') then
  $const:psvi-supported
else
  ()	
(:
should throw a u:dynamicError('err:XD0015',"")
:)
};

(: -------------------------------------------------------------------------- :)
declare function func:version-available($version as xs:decimal){
(: -------------------------------------------------------------------------- :)
  if ($version eq 1.0) then
    "true"
  else
    "false"
};

(: -------------------------------------------------------------------------- :)
declare function func:value-available($value1, $value2){
(: -------------------------------------------------------------------------- :)
    "true"
};

(: -------------------------------------------------------------------------- :)
declare function func:value-available($value1){
(: -------------------------------------------------------------------------- :)
    "true"
};


(: -------------------------------------------------------------------------- :)
declare function func:step-available($step-name) as xs:boolean{
(: -------------------------------------------------------------------------- :)
    if(starts-with($step-name,'p')) then true() else false()
};

(: -------------------------------------------------------------------------- :)
declare function func:iteration-position(){
(: -------------------------------------------------------------------------- :)
    "true"
};

(: -------------------------------------------------------------------------- :)
declare function func:xpath-version-available($version as xs:double) as xs:boolean{
(: -------------------------------------------------------------------------- :)
    if ($version = 2.0) then true() else false()
};

(: -------------------------------------------------------------------------- :)
declare function func:resolve-uri($value1){
(: -------------------------------------------------------------------------- :)
"true"
};

(: -------------------------------------------------------------------------- :)
declare function func:resolve-uri($value1,$value2){
(: -------------------------------------------------------------------------- :)
"true"
};

(: -------------------------------------------------------------------------- :)
declare function func:base-uri($value1){
(: -------------------------------------------------------------------------- :)
"true"
};

(: -------------------------------------------------------------------------- :)
declare function func:base-uri(){
(: -------------------------------------------------------------------------- :)
"true"
};


(: -------------------------------------------------------------------------- :)
declare function func:iteration-size(){
(: -------------------------------------------------------------------------- :)
"true"
};


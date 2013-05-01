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

xquery version "3.0" encoding "UTF-8";

(:~
 :
 :	functions.xqm - defines xproc xpath extensions.
 : 
 :	
 :)

module namespace func = "http://www.w3.org/ns/xproc";

declare namespace c     = "http://www.w3.org/ns/xproc-step";
declare namespace err   = "http://www.w3.org/ns/xproc-error";
declare namespace xproc = "http://xproc.net/xproc";
declare namespace xsl   = "http://www.w3.org/1999/XSL/Transform";

import module namespace const = "http://xproc.net/xproc/const" at "/xquery/core/const.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

(: -------------------------------------------------------------------------- :)



(: -------------------------------------------------------------------------- :)
declare
%xproc:func
function func:system-property($property){
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
declare
%xproc:func
function func:version-available($version as xs:decimal){
(: -------------------------------------------------------------------------- :)
  if ($version eq 1.0) then
    "true"
  else
    "false"
};

(: -------------------------------------------------------------------------- :)
declare
%xproc:func
function func:value-available($value1, $value2){
(: -------------------------------------------------------------------------- :)
    "true"
};

(: -------------------------------------------------------------------------- :)
declare %xproc:func function func:value-available($value1){
(: -------------------------------------------------------------------------- :)
    "true"
};


(: -------------------------------------------------------------------------- :)
declare %xproc:func function func:step-available($step-name) as xs:boolean{
(: -------------------------------------------------------------------------- :)
    if(starts-with($step-name,'p')) then true() else false()
};

(: -------------------------------------------------------------------------- :)
declare %xproc:func function func:iteration-position(){
(: -------------------------------------------------------------------------- :)
    "true"
};

(: -------------------------------------------------------------------------- :)
declare %xproc:func function func:xpath-version-available($version as xs:double) as xs:boolean{
(: -------------------------------------------------------------------------- :)
    if ($version = 2.0) then true() else false()
};

(: -------------------------------------------------------------------------- :)
declare %xproc:func function func:resolve-uri($value1){
(: -------------------------------------------------------------------------- :)
"true"
};

(: -------------------------------------------------------------------------- :)
declare %xproc:func function func:resolve-uri($value1,$value2){
(: -------------------------------------------------------------------------- :)
"true"
};

(: -------------------------------------------------------------------------- :)
declare %xproc:func function func:base-uri($value1){
(: -------------------------------------------------------------------------- :)
"true"
};

(: -------------------------------------------------------------------------- :)
declare %xproc:func function func:base-uri(){
(: -------------------------------------------------------------------------- :)
"true"
};


(: -------------------------------------------------------------------------- :)
declare %xproc:func function func:iteration-size(){
(: -------------------------------------------------------------------------- :)
"true"
};


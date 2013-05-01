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

(: ------------------------------------------------------------------------------------- 

	opt.xqm - Implements all xproc optional steps.
	
---------------------------------------------------------------------------------------- :)

module namespace opt = "http://xproc.net/xproc/opt";

declare namespace xproc = "http://xproc.net/xproc";
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";

import module namespace const = "http://xproc.net/xproc/const" at "/xquery/core/const.xqy";
import module namespace u = "http://xproc.net/xproc/util" at "/xquery/core/util.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions";


(: -------------------------------------------------------------------------- :)
declare
%xproc:step
function opt:exec($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};

(: -------------------------------------------------------------------------- :)
declare
%xproc:step
function opt:hash($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare
%xproc:step
function opt:uuid($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare
%xproc:step
function opt:www-form-urldecode($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
(:
let $value := u:get-option('value',$options,$primary)
let $params := tokenize($value,'&amp;')
return
       <c:param-set>
        {
        for $child in $params
        return
            <c:param name="{substring-before($child,'=')}" value="{substring-after($child,'=')}"/>
        }
       </c:param-set>
:)};


(: -------------------------------------------------------------------------- :)
declare
%xproc:step
function opt:www-form-urlencode($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare
%xproc:step
function opt:validate($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare
%xproc:step
function opt:xsl-formatter($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare
%xproc:step
function opt:xquery($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $query := u:getInputMap($secondary/@step || "#query") 
return u:xquery($query/text(),$primary,$options[@name])
};


(: -------------------------------------------------------------------------- :)
declare
%xproc:step
function opt:zip($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $href             := u:get-option('href',$options,$primary)
let $command          := u:get-option('command',$options,$primary)
let $return-manifest  := u:get-option('return-manifest',$options,$primary)
let $opts             := u:get-option('options',$options,$primary)
return
    <c:result href="{$href}" command="{$command}" return-manifest="{$return-manifest}" options="{$opts}"></c:result>
};

(: -------------------------------------------------------------------------- :)
declare
%xproc:step
function opt:unzip($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};





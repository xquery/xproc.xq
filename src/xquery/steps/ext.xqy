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

	ext.xqm - implements all xprocxq specific extension steps.

 ---------------------------------------------------------------------------------------- :)

module namespace ext = "http://xproc.net/xproc/ext";

import module namespace const = "http://xproc.net/xproc/const"
  at "../core/const.xqy";

import module namespace u = "http://xproc.net/xproc/util"
  at "../lib/util.xqy";

declare namespace xproc = "http://xproc.net/xproc";
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";

declare default function namespace "http://www.w3.org/2005/xpath-functions";
declare copy-namespaces no-preserve, no-inherit;


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

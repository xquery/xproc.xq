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

xquery version "3.0"  encoding "UTF-8";

(: -----------------------------------------------------------------------------
    parse.xqy -
 ---------------------------------------------------------------------------- :)

module namespace parse = "http://xproc.net/xproc/parse";

import module namespace const = "http://xproc.net/xproc/const"
  at "/xquery/core/const.xqy";
import module namespace u = "http://xproc.net/xproc/util"
  at "/xquery/core/util.xqy";

declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace xproc="http://xproc.net/xproc";
declare namespace ext="http://xproc.net/xproc/ext";
declare namespace opt="http://xproc.net/xproc/opt";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare copy-namespaces preserve, inherit;

 (:~
  : looks up std, ext, and opt step definition
  :
  : @returns step signature
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:get-step($node){
 (: ------------------------------------------------------------------------- :)
 let $name := name($node)
 return
   ($const:std-steps/p:declare-step[@type=$name][@xproc:support eq 'true']   
   ,$const:opt-steps/p:declare-step[@type=$name][@xproc:support eq 'true']
   ,$const:ext-steps/p:declare-step[@type=$name][@xproc:support eq 'true']
   ,$const:comp-steps/xproc:element[@type=$name][@xproc:support eq 'true'][@xproc:step eq "true"])[1]
   (: throw err:XS0044 ?:)
 };


 (: ------------------------------------------------------------------------- :)
 declare function parse:type($node) as xs:string{
 (: ------------------------------------------------------------------------- :)
 parse:type($node, ())
 };

 (:~
  : determines type of xproc element<br/>
  :
  : std-step: standard xproc step<br/>
  : opt-step: optional xproc step<br/>
  : ext-step: xprocxq proprietary extension step<br/>
  : declare-step: an author defined step<br/>
  : comp-step: p:choose, p:viewport, etc<br/>
  : comp: component (ex. p:input)<br/>
  : error: means that the element has not been identified<br/>
  : <br/>
  : @returns 'std-step|opt-step|ext-step|declare-step|comp-step|comp|error(unknown type)'
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:type($node, $types) as xs:string{
 (: ------------------------------------------------------------------------- :)
 let $name as xs:string := name($node)
 return
   if ($types = $name) then
     'defined'
   else if ($const:std-steps/p:declare-step[@type=$name][@xproc:support eq 'true']) then
     'std-step'
   else if($const:opt-steps/p:declare-step[@type=$name][@xproc:support eq 'true']) then
     'opt-step'
   else if($const:ext-steps/p:declare-step[@type=$name][@xproc:support eq 'true']) then
     'ext-step'
   else if(local-name($node) eq 'declare-step') then
     'declare-step'
   else if($const:comp-steps/xproc:element[@type=$name][@xproc:support eq 'true'][@xproc:step eq "true"]) then
     'comp-step'
   else if($const:comp-steps/xproc:element[@type=$name][@xproc:support eq 'true']) then
     'comp'
   else
     'error' || $const:opt-steps/p:declare-step[@type=$name]      (: check if unknown p: element else throw error XS0044:)
 };


 (:~
  : determines type of xproc element<br/>
  :
  : std-step: standard xproc step<br/>
  : opt-step: optional xproc step<br/>
  : ext-step: xprocxq proprietary extension step<br/>
  : declare-step: an author defined step<br/>
  : comp-step: p:choose, p:viewport, etc<br/>
  : comp: component (ex. p:input)<br/>
  : error: means that the element has not been identified<br/>
  : <br/>
  : @returns 'std-step|opt-step|ext-step|declare-step|comp-step|comp|error(unknown type)'
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:func($node, $types,$type){
 (: ------------------------------------------------------------------------- :)
    let $name as xs:string := name($node)
    return
    if ($type eq 'std-step') then
    $const:std-steps/p:declare-step[@type=$name][@xproc:support eq 'true']/@xproc:func
    else if($type eq 'opt-step') then
    $const:opt-steps/p:declare-step[@type=$name][@xproc:support eq 'true']/@xproc:func
    else if($type eq 'ext-step') then
    $const:ext-steps/p:declare-step[@type=$name][@xproc:support eq 'true']/@xproc:func    
    else if($type eq 'comp-step') then
    $const:comp-steps/xproc:element[@type=$name][@xproc:support eq 'true']/@xproc:func
    else
     ()
 };


 (:~
  : sorts pipeline based on input port dependencies 
  :
  : p:pipe/xproc:step-name are checked against xproc:default-name
  :
  : @returns node()*
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:pipeline-step-sort($unsorted, $sorted) as item()*{
 (: ------------------------------------------------------------------------- :)
    if (count($unsorted) eq 0) then
      (remove($sorted,1),
      <ext:post xproc:step="true" xproc:func="ext:post#4" xproc:default-name="{$sorted[1]/@xproc:default-name}!">
        <p:input port="source" primary="true" select="/" xproc:type="comp">
          <p:pipe port="result" step="{$sorted[last()]/@xproc:default-name}" xproc:step-name="{$sorted[last()]/@xproc:default-name}"/>
        </p:input>
        <p:output primary="true" port="result" xproc:type="comp" select="/"/>
        </ext:post>)
     else

       let $allnodes := $unsorted [ every $id in p:input/p:pipe/@xproc:step-name satisfies ($id = $sorted/@xproc:default-name)]
       return
         if ($allnodes) then
           parse:pipeline-step-sort( $unsorted except $allnodes, ($sorted, $allnodes ))
         else
          ()
 };


(:~
  : sorts pipeline based on input port dependencies 
  :
  : p:pipe/xproc:step-name are checked against xproc:default-name
  :
  : @returns node()*
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:pipeline-pre-step-sort($unsorted, $sorted) {
 (: ------------------------------------------------------------------------- :)
    if (count($unsorted) eq 0) then
      (remove($sorted,1))
     else

       let $allnodes := $unsorted [ every $id in p:input/p:pipe/@step satisfies ($id = $sorted/@name)]
       return
         if ($allnodes) then
           parse:pipeline-pre-step-sort( $unsorted except $allnodes, ($sorted, $allnodes ))
         else
          ()
 };

 
 (:~
  : entry point for parse:explicit-bindings
  :
  : @returns element(p:declare-step)
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:explicit-bindings($pipeline) as element(p:declare-step){
 (: ------------------------------------------------------------------------- :)
 element p:declare-step {$pipeline/@*,
   parse:explicit-bindings($pipeline,'source',$const:init_unique_id,$pipeline)
 }
 };


 (:~
  : make all p:input and p:output ports explicit
  :
  : @returns element()*
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:explicit-bindings($ast,$portname,$unique_id as xs:string?,$pipeline){
 (: ------------------------------------------------------------------------- :)
 ( $ast/p:declare-step[@type],
   for $step at $count in $ast/*[@xproc:step eq 'true']
   return
     if(empty($step)) then
       ()
     else if($step/@xproc:type eq 'defined') then
       $step
     else if($step/@xproc:type eq 'comp-step') then
       element {name($step)}{
         $step/@*,
         u:ns-axis($step),
         element ext:pre {
             $step/ext:pre/@*,
             $step/ext:pre/(* except (p:iteration-source|p:viewport-source|p:xpath-context)),
             
             for $input in
             $step/ext:pre/(p:iteration-source|p:viewport-source|p:xpath-context)
             return
            element {name($input)} {
              $input/@port,
              $input/@select,
              $input/@xproc:type,
              attribute primary {true()},
              if($input/p:pipe) then
                for $pipe in $input/p:pipe
                 return
                element p:pipe{
                  $pipe/@port,
                  attribute xproc:type {"comp"},
                  attribute step {($pipeline//*[@name eq $pipe/@step]/@xproc:default-name,concat($unique_id,'.',string($count - 2 )))[1]},
                  attribute xproc:step-name {($pipeline//*[@name eq $pipe/@step]/@xproc:default-name,concat($unique_id,'.',string($count - 2 )))[1]}
                }
              else if ($input/(p:data|p:document|p:inline|p:empty)) then
                $input/*
              else
                element p:pipe{
                  attribute port {"result"},
                  attribute xproc:type {"comp"},
                  attribute step {if ($count eq 1) then $unique_id else concat($unique_id,'.',string($count - 2 ))},
                  attribute xproc:step-name {if ($count eq 1) then $unique_id else concat($unique_id,'.',string($count - 2 ))}
                }

            }
            },
            $step/p:variable,
            $step/(* except ext:pre)
       }
     else
       element {name($step)}{
         $step/@*,
         u:ns-axis($step),
         for $input in $step/p:input[@primary eq "true"]
         return
            element p:input {
              $input/@port,
              $input/@select,
              $input/@xproc:type,
              attribute primary {true()},
              if($input/p:pipe) then
                for $pipe in $input/p:pipe
                 return
                element p:pipe{
                  $pipe/@port,
                  attribute xproc:type {"comp"},
                  attribute step {($pipeline//*[@name eq $pipe/@step]/@xproc:default-name,concat($unique_id,'.',string($count - 2 )))[1]},
                  attribute xproc:step-name {($pipeline//*[@name eq $pipe/@step]/@xproc:default-name,concat($unique_id,'.',string($count - 2 )))[1]}
                }
              else if ($input/(p:data|p:document|p:inline|p:empty)) then
                $input/*
              else
                element p:pipe{
                  attribute port {"result"},
                  attribute xproc:type {"comp"},
                  attribute step {if ($count eq 1) then $unique_id else concat($unique_id,'.',string($count - 2 ))},
                  attribute xproc:step-name {if ($count eq 1) then $unique_id else concat($unique_id,'.',string($count - 2 ))}
                }
            },
         for $input in $step/p:input[@primary eq "false" or not(@primary)]
         return
            element p:input {
              $input/@port,
              $input/@select,
              $input/@xproc:type,
              attribute primary {false()},

              if($input/p:pipe) then
                element p:pipe{
                  $input/p:pipe/@port,

                  attribute xproc:type {"comp"},
                  attribute step {($pipeline//*[@name eq $input/p:pipe/@step]/@xproc:default-name,concat($unique_id,'.',string($count - 2 )))[1]},
                  attribute xproc:step-name {($pipeline//*[@name eq $input/p:pipe/@step]/@xproc:default-name,concat($unique_id,'.',string($count - 2 )))[1]}
                }
              else if ($input/(p:data|p:document|p:inline)) then
                $input/*
              else
                element p:pipe{
                  attribute port {$input/@port},
                  attribute external {"true"},
                  attribute xproc:type {"comp"},
                  attribute step {if ($count eq 1) then $unique_id else concat($unique_id,'.',string($count - 2 ))},
                  attribute xproc:step-name {if ($count eq 1) then $unique_id else concat($unique_id,'.',string($count - 2 ))}
                }
            }
            ,
            $step/p:output,
            $step/p:with-option,
            $step/p:option,
            $step/p:variable,
            parse:explicit-bindings($step[@xproc:step eq "true"],$ast[$count - 1]/p:output[@primary eq "true"]/@port,
                 $step/@xproc:default-name,
                 $pipeline)
       }
)
 };



 (:~
  : parse xpath-context bindings used with p:choose
  :
  :
  : @returns element(p:xpath-context)
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:xpath-context($node as element(p:xpath-context)*, $step-definition) as element(p:xpath-context)*{
 (: ------------------------------------------------------------------------- :)
  for $input in $step-definition/p:xpath-context
  let $s := $node
  return
   element p:xpath-context {
      attribute xproc:type {'comp'},
      $s/(p:inline),
      for $pipe in $s/p:pipe
      return
          element p:pipe{
              $pipe/@*
          }
   }
};


 (:~
  : parse viewport-source bindings used with p:viewport
  :
  :
  : @returns element(p:viewport-source)
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:viewport-source($node as element(p:viewport-source)*, $step-definition) as element(p:viewport-source)*{
 (: ------------------------------------------------------------------------- :)
  for $input in $step-definition/p:viewport-source
  let $s := $node
  return 
    element p:viewport-source {
      attribute xproc:type {'comp'},
      $s/*}
};

 (:~
  : parse iteration-source bindings used with p:for-each
  : 
  :
  : @returns element(p:iteration-source)
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:iteration-source($node as element(p:iteration-source)*, $step-definition) as element(p:iteration-source)*{
 (: ------------------------------------------------------------------------- :)
  for $input in $step-definition/p:iteration-source
  let $s := $node
  return 
    element p:iteration-source {
      $s/@*,  
      $s/*
    }
};

 (:~
  : parse input bindings of top level steps
  : which could have an unknown number of ports
  :
  : @returns element(p:input)
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:step-input-port($node as element(p:input)*, $step-definition) as element(p:input)*{
 (: ------------------------------------------------------------------------- :)
 $node
 };

 (:~
  : parse input bindings
  :
  :
  : @returns element(p:input)
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:input-port($node as element(p:input)*, $step-definition) as element(p:input)*{
 (: ------------------------------------------------------------------------- :)
  for $input in $step-definition/p:input
  let $name as xs:string := fn:string($input/@port)
  let $s := $node[@port eq $name]
  return
    element p:input {
      attribute xproc:type {'comp'},
      $input/@*[name(.) ne 'select'],
      ($s/@select, $input/@select)[1],
      $s/*
    }
 };

 (:~
  : parse output bindings
  :
  : @returns element(p:output)
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:output-port($node as element(p:output)*, $step-definition) as element(p:output)*{
 (: ------------------------------------------------------------------------- :)
  for $output in $step-definition/p:output
  let $name as xs:string := fn:string($output/@port)
  let $s := $node[@port eq $name]
  return
    if ($output/@required eq 'true' and fn:empty($s)) then
       fn:error(xs:QName('err:XS0027'),'output required')   (: error XS0027:)
    else
      element p:output {
        attribute xproc:type {'comp'},
        $output/@*[name(.) ne 'select'],
        ($s/@select,  $output/@select)[1],
        $s/*
      }
 };



 (:~
  : parse variable
  :
  : @returns element(p:variable)
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:variables($node as element(p:variable)*, $step-definition) as element(p:variable)*{
 (: ------------------------------------------------------------------------- :)
for $variable in $node
return
     element p:variable {
       attribute xproc:type {'comp'},
       attribute name {$variable/@name},
       attribute select {$variable/@select}
       }
 };



 (:~
  : parse p:option
  :
  : @returns element(p:option)
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:options($node as element(p:option)*, $step-definition) as element(p:option)*{
 (: ------------------------------------------------------------------------- :)
for $option in $node
return
     element p:option {
       attribute xproc:type {'comp'},
       attribute name {$option/@name},
       attribute value {$option/@value},
       attribute select {$option/@select}
       }
 };


 (:~
  : parse a steps options, converting all options to a nested p:with-option element
  :
  : @returns element(p:with-option)
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:with-options($node as element(p:with-option)*, $step-definition) as element(p:with-option)*{
 (: ------------------------------------------------------------------------- :)
 for $option in $step-definition/p:option
 let $name as xs:string := fn:string($option/@name)
 let $defined-option := $node[@name eq $name]
 return
   if ($defined-option) then
     element p:with-option {
       attribute xproc:type {'comp'},
       ($defined-option/@name)[1],
       ($defined-option/@select)[1]

(:
       attribute select {concat("'",$defined-option/@select,"'")}
:)
     }
   else
     element p:with-option {
       attribute xproc:type {'comp'},
       ($option/@name)[1], 
       ($option/@select)[1]
     }
 };


 (:~
  : generate abstract syntax tree
  :
  : generate ext:post
  : make fully explicit all port names 
  : resolve imports or throw XD0002
  : generate ext:xproc if p:declare-step/@type 
  :
  :
  :
  :
  : @returns
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:AST($pipeline as node()*){
 (: ------------------------------------------------------------------------- :)
    for $node in $pipeline
    let $step-definition := parse:get-step($node)
    return
        typeswitch($node)
            case text()
                   return $node/text()
            case element(p:declare-step) 
                   return element p:declare-step {
                     namespace xproc {"http://xproc.net/xproc"},
                     namespace ext {"http://xproc.net/xproc/ext"},
                     namespace c {"http://www.w3.org/ns/xproc-step"},
                     namespace err {"http://www.w3.org/ns/xproc-error"},
                     namespace xxq-error {"http://xproc.net/xproc/error"},
                     $node/@*,
                     u:ns-axis($node),    
                     if ($node/@type) then 
                       $node/*
                     else
                     element ext:pre {attribute xproc:default-name {fn:concat($node/@xproc:default-name,'.0')},
                       attribute xproc:step {"true"},
                       attribute xproc:func {"ext:pre#4"},
                       $node/p:input[@port ne 'source'],
                       parse:input-port($node/p:input[@port eq 'source'], $step-definition), 
                       parse:output-port($node/p:output, $step-definition),
                       parse:with-options($node/p:with-option,$step-definition),
                       parse:options($node/p:option,$step-definition),
                       parse:variables($node/p:variable,$step-definition)
                     },
                     parse:AST($node/*[@xproc:type ne 'comp'])
                   }
            case element(p:group) 
                   return element p:group {
                     $node/@*,
                     u:ns-axis($node),    
                     element ext:pre {attribute xproc:default-name {fn:concat($node/@xproc:default-name,'.0')},
                       attribute xproc:step {"true"},
                       attribute xproc:func {"ext:pre#4"},
                       $node/p:log,
                       parse:input-port($node/p:input, $step-definition),
                       parse:output-port($node/p:output, $step-definition)
                     },
                     parse:AST($node/*[@xproc:type ne 'comp'])
                   }
            case element(p:for-each) 
                   return element p:for-each {
                     $node/@*,
                     u:ns-axis($node),    
                     element ext:pre {attribute xproc:default-name {fn:concat($node/@xproc:default-name,'.0')},
                       attribute xproc:step {"true"},
                       attribute xproc:func {"ext:pre#4"},
                       $node/p:log,
                       parse:input-port($node/p:input, $step-definition),
                       parse:output-port($node/p:output, $step-definition),
                       parse:iteration-source($node/p:iteration-source, $step-definition)
                     },
                     parse:AST($node/*[@xproc:type ne 'comp'])
                   }
            case element(p:viewport)
                   return element p:viewport {
                     $node/@*,
                     u:ns-axis($node),
                     element ext:pre {attribute xproc:default-name {fn:concat($node/@xproc:default-name,'.0')},
                       attribute xproc:step {"true"},
                       attribute xproc:func {"ext:pre#4"},
                       $node/p:log,
                       parse:input-port($node/p:input, $step-definition),
                       parse:output-port($node/p:output, $step-definition),
                       parse:viewport-source($node/p:viewport-source, $step-definition)
                     },
                     parse:AST($node/*[@xproc:type ne 'comp'])
                   }
            case element(p:choose) | element(p:when) | element(p:otherwise)
                   return element {node-name($node)} {
                     $node/@*,
                     u:ns-axis($node),
                     element ext:pre {attribute xproc:default-name {fn:concat($node/@xproc:default-name,'.0')},
                       attribute xproc:step {"true"},
                       attribute xproc:func {"ext:pre#4"},
                       parse:input-port($node/p:input, $step-definition),
                       parse:output-port($node/p:output, $step-definition),
                       parse:xpath-context($node/p:xpath-context, $step-definition)
                     },
                     parse:AST($node/*[@xproc:type ne 'comp'])
                   }
            case element(p:try) | element(p:catch)
                   return element {node-name($node)} {
                     $node/@*,
                     u:ns-axis($node),
                     element ext:pre {attribute xproc:default-name {fn:concat($node/@xproc:default-name,'.0')},
                       attribute xproc:step {"true"},
                       attribute xproc:func {"ext:pre#4"},
                       $node/p:log,
                       parse:input-port($node/p:input, $step-definition),
                       parse:output-port($node/p:output, $step-definition)
                     },
                     parse:AST($node/*[@xproc:type ne 'comp'])
                   }
           case element()
                   return element {node-name($node)}{
                     $node/@*,
                     u:ns-axis($node),
                     $node/p:log,
                     parse:input-port($node/p:input, $step-definition),
                     parse:output-port($node/p:output, $step-definition),
                     parse:with-options($node/p:with-option,$step-definition),
                     parse:AST($node/*[@xproc:type ne 'comp'])
                   }
            default
            return ()
 };


 (:~
  : entry point for parse:explicit-name
  :
  : @returns 
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:explicit-name($pipeline as element(p:declare-step)){
 (: ------------------------------------------------------------------------- :)
 element p:declare-step {
    $pipeline/@*,
    u:ns-axis($pipeline),
    namespace xproc {"http://xproc.net/xproc"},
    namespace ext {"http://xproc.net/xproc/ext"},
    namespace c {"http://www.w3.org/ns/xproc-step"},
    namespace err {"http://www.w3.org/ns/xproc-error"},
    namespace xxq-error {"http://xproc.net/xproc/error"},
    attribute xproc:default-name {$const:init_unique_id},
    $pipeline/*[not(@xproc:step)],
    parse:explicit-name($pipeline/*[@xproc:step eq "true"], $const:init_unique_id)
  }
 };

 (:~
  : inject xproc:default-name attribute to all step elements
  :
  : @returns node()*
  :)
 (: ------------------------------------------------------------------------ :)
 declare function parse:explicit-name(
     $pipeline as node()*,
     $cname as xs:string
 ) as node()*{
 (: ------------------------------------------------------------------------ :)
 for $node at $count in $pipeline
 let $name := if($node/@xproc:step eq 'true')
     then fn:concat($cname,".",$count)
     else $cname
 return
   typeswitch($node)
     case text()
         return $node/text()
     case element()
         return element {node-name($node)} {
           $node/@*,
           u:ns-axis($node),
           if($node/@xproc:step eq 'true') then
             attribute xproc:default-name {$name}
           else
             (),
             for $a in $node/text()
             return
               normalize-space($a),
               if ($node/@type) then $node/* else parse:explicit-name($node/*,if($node/@xproc:step eq 'true') then $name else $cname)
         }
     default
        return ()
};


 (:~
  : add namespace declarations and explicitly type each step
  :
  : @returns node()*
  :)
 (: ------------------------------------------------------------------------- :)
 declare function parse:explicit-type($pipeline as node()*) as node()*{
 (: ------------------------------------------------------------------------- :)
    for $node at $count in $pipeline
    let $type :=  parse:type($node,$pipeline//@type)
    let $func :=  parse:func($node,$pipeline//@type,$type)

(: if (string($pipeline//@type) = name($node)) then "comp" else :)
    return
        typeswitch($node)
            case text()
                   return $node/text()
            case element(p:variable)
                   return element p:variable {
                     attribute xproc:type {'comp'},
                     $node/@name,
                     $node/@select
                     }
            case element(p:option)
                   return element p:option {
                     attribute xproc:type {'comp'},
                     $node/@name,
                     $node/@value,
                     $node/@select
                     }
            case element(p:inline)
                   return element p:inline {
                     attribute xproc:type {'comp'},
                     $node/@*,
                     u:ns-axis($node),
                     $node/*
                     }
            case element(p:import)
                   return
                     if (doc-available($node/@href)) then
                       doc($node/@href)/p:library/p:declare-step
                     else
                       <error type="XD0002">cant import</error>
                       (: u:dynamicError('XD0002',"cannot import pipeline document ") :)
            case element(p:pipeline) | element(p:declare-step)
                   return 
                     if ($node/@type) then
                       element p:declare-step {$node/@*,
                       u:ns-axis($node),
                       namespace xproc {"http://xproc.net/xproc"},
                       namespace ext {"http://xproc.net/xproc/ext"},
                       namespace c {"http://www.w3.org/ns/xproc-step"},
                       namespace err {"http://www.w3.org/ns/xproc-error"},
                       namespace xxq-error {"http://xproc.net/xproc/error"},
                       attribute xproc:type {$type},
                       $node/*}
                     else
                       element p:declare-step {$node/@*,
                       u:ns-axis($node),
                       namespace xproc {"http://xproc.net/xproc"},
                       namespace ext {"http://xproc.net/xproc/ext"},
                       namespace c {"http://www.w3.org/ns/xproc-step"},
                       namespace err {"http://www.w3.org/ns/xproc-error"},
                       namespace xxq-error {"http://xproc.net/xproc/error"},
                       attribute xproc:type {$type},
                       parse:explicit-type($node/node())}
            case element()
                   return element {node-name($node)} {
                     $node/@*,
                     u:ns-axis($node),
                     if (contains($type,'step') or $type eq 'defined') then attribute xproc:step {fn:true()} else (),
                     attribute xproc:type {$type},
                     attribute xproc:func {$func},
                     parse:explicit-type($node/node()) ,
                    if (contains($type,'step')) then
                       for $option in $node/@*[name(.) ne 'name']      (: normalize all step attribute options to be represented as p:with-option elements :)
                       return
                         element p:with-option {
                           attribute xproc:type {'comp'},
                           attribute name {name($option)},
                           attribute select {data($option)}
                         }
                       else
                         () }
            default
                   return parse:explicit-type($node/node())
 };

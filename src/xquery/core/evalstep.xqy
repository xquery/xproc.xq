



 (:~ evaluates an xproc step
  :
  : @param $step - step's xproc:default-name
  : @param $namespaces - namespaces in use 
  : @param $primaryinput - standard input into the step
  : @param $ast - full abstract syntax tree of the pipeline being processed
  : @param $outputs - all of the previously processed steps outputs, including in scope variables and options
  :
  : @returns item()*
 :)
 (: -------------------------------------------------------------------------- :)
 declare function xproc:evalstep (
   $step,
   $namespaces,
   $primary as item()*,
   $ast as element(p:declare-step)) {
 (: -------------------------------------------------------------------------- :)
 let $variables    := ()
 let $with-options :=  <xproc:options>
         {$ast/*[@xproc:default-name=$step]/p:with-option}
     </xproc:options>

 let $currentstep  := $ast/*[@xproc:default-name eq $step]

 let $stepfunction as function(*):= if ($currentstep/@type or $currentstep/@xproc:func eq "")
    then std:identity#4
    else function-lookup(xs:QName(substring-before($currentstep/@xproc:func,'#')),xs:integer(substring-after($currentstep/@xproc:func,'#'))) 

 let $primary-result    := xproc:eval-primary($ast,$currentstep,$primary, ())
 let $secondary-result  := xproc:eval-secondary($ast,$currentstep,$primary,())

 let $log-href     := $currentstep/p:log/@href
 let $log-port     := $currentstep/p:log/@port

 let $result       := $stepfunction( if (empty($primary-result)) then $primary else $primary,$secondary-result,$with-options,$currentstep)
 let $_            := u:putInputMap($step || "#" || $currentstep/p:output[@primary eq "true"]/@port, $result)

 return
      $result
 };
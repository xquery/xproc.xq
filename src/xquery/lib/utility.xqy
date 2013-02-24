xquery version "1.0-ml";

(: utility xquery module :)

module namespace u="http://www.webcomposite.com/utility";

declare variable $NASSERT:=1;
declare variable $NLOG:=1;

declare function u:assert($booleanexp as item(), $why as xs:string)  {
if(fn:not($booleanexp) and fn:boolean($NASSERT)) then 
    (xdmp:log(fn:concat("assertion failure: ",$why),"error"), fn:error(fn:QName("http://www.webcomposite.com/utility", "assertion"),$why))
else
  ()
};

declare function u:log($msg as xs:string)  {
if(fn:boolean($NLOG)) then 
    xdmp:log($msg)
else
    ()
};


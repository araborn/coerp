(:~
 : This is the main XQuery which will (by default) be called by controller.xql
 : to process any URI ending with ".html". It receives the HTML from
 : the controller and passes it to the templating system.
 :)
xquery version "3.0";

import module namespace templates="http://exist-db.org/xquery/templates" ;

(: 
 : The following modules provide functions which will be called by the 
 : templating.
 :)
import module namespace config="http://localhost:8080/exist/apps/coerp_new/config" at "config.xqm";
import module namespace app="http://localhost:8080/exist/apps/coerp_new/templates" at "app.xql";

import module namespace helpers="http://localhost:8080/exist/apps/coerp_new/helpers" at "helpers.xqm";
import module namespace corpus="http://localhost:8080/exist/apps/coerp_new/corpus" at "corpus.xqm";
import module namespace page="http://localhost:8080/exist/apps/coerp_new/page" at "page.xqm";
import module namespace doc="http://localhost:8080/exist/apps/coerp_new/doc" at "doc.xqm";


(: 
ALTE MODULE 
import module namespace search="http://localhost:8080/exist/apps/coerp_new/search" at "search.xqm";
import module namespace corpus="http://localhost:8080/exist/apps/coerp_new/corpus" at "corpus.xqm";
import module namespace dataset="http://localhost:8080/exist/apps/coerp_new/dataset" at "dataset.xqm";
import module namespace hierarchy="http://localhost:8080/exist/apps/coerp_new/hierarchy" at "hierarchy.xqm";
import module namespace genre="http://localhost:8080/exist/apps/coerp_new/genre" at "genre.xqm";
import module namespace period="http://localhost:8080/exist/apps/coerp_new/period" at "period.xqm";
import module namespace register="http://localhost:8080/exist/apps/coerp_new/register" at "registration.xqm";
import module namespace login="http://localhost:8080/exist/apps/coerp_new/login" at "login.xqm";
:)


declare option exist:serialize "method=html5 media-type=text/html enforce-xhtml=yes";

let $config := map {
    $templates:CONFIG_APP_ROOT := $config:app-root,
    $templates:CONFIG_STOP_ON_ERROR := true()
}
(:
 : We have to provide a lookup function to templates:apply to help it
 : find functions in the imported application modules. The templates
 : module cannot see the application modules, but the inline function
 : below does see them.
 :)
let $lookup := function($functionName as xs:string, $arity as xs:int) {
    try {
        function-lookup(xs:QName($functionName), $arity)
    } catch * {
        ()
    }
}
(:
 : The HTML is passed in the request from the controller.
 : Run it through the templating system and return the result.
 :)
let $content := request:get-data()
return
    templates:apply($content, $lookup, (), $config)
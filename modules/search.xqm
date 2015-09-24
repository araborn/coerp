xquery version "3.0";

module namespace search="http://localhost:8080/exist/apps/coerp_new/search";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://localhost:8080/exist/apps/coerp_new/config" at "config.xqm";

declare namespace util="http://exist-db.org/xquery/util";
declare namespace text="http://exist-db.org/xquery/text";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace coerp="http://coerp.uni-koeln.de/schema";

(: ###### SUCH FUNKTIONEN ######### :)

declare function search:Search_Authors-Translator_StWi($type as xs:string, $letter as xs:string) {
    
         let $db := collection("/db/apps/coerp_new/data/texts")
        let $range := concat("//range:field-starts-with(('",$type,"'),'",$letter,"')")
         let $build := concat("$db",$range)
        return util:eval($build)
};






(: ########### SEARCH SEITEN AUFBAU ############# :)

declare function search:test($node as node()*, $model as map(*)) {
   request:get-parameter("name",'')
};


declare function search:CollectData($node as node(), $model as map(*)) {
       (: let $db := collection("/db/apps/coerp_new/data") :)
     let $dbase := collection("/db/apps/coerp_new/data")
     let $term :=  if(search:get-parameters("term") != "") then $dbase//coerp:text[ft:query(.,search:get-parameters("term"))]
                                else $dbase
        let $dbase := $term
       
        let $date := search:get-date-results($dbase)
        let $dbase := $date
        let $genre := if(search:get-parameters("genre") != "") then search:get-range-search($dbase,"genre")
                                else $dbase
        let $dbase := $genre
        let $denom := if(search:get-parameters("denom") != "") then search:get-range-search($dbase,"denom")
                                else $dbase
        let $dbase := $denom
        
        return map {
        "results" :=  $dbase
        }
        
        
};


declare function search:get-parameters($key as xs:string) as xs:string* {
    for $hit in request:get-parameter-names()
        return if($hit=$key) then request:get-parameter($hit,'')
                    else ()
                
};




declare function search:get-date-results($db as node()*) {
        
        let $date := request:get-parameter("date","")
        let $from := xs:integer(substring-before($date," -"))
        let $to := xs:integer(substring-after($date,"- "))
        for $year in ($from to $to)
            return search:get-date-search($db,$year)
};


declare function search:get-range-search($db as node()*,$param as xs:string) {
        for $hit in search:get-parameters($param)    
        let $search_terms := concat('("',$param,'"),"',$hit,'"')
        let $search_funk := concat("//range:field-eq(",$search_terms,")")
        let $search_build := concat("$db",$search_funk)
        return util:eval($search_build)

};

declare function search:get-date-search($db as node()*, $year as xs:string) {
        let $search_terms := concat('("year_from"),"',$year,'"')
        let $search_funk := concat("//range:field-contains(",$search_terms,")")
        let $search_build := concat("$db",$search_funk)
        return util:eval($search_build)
};

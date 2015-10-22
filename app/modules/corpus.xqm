xquery version "3.0";

module namespace corpus="http://localhost:8080/exist/apps/coerp_new/corpus";

import module namespace helpers="http://localhost:8080/exist/apps/coerp_new/helpers" at "helpers.xqm";

import module namespace search="http://localhost:8080/exist/apps/coerp_new/search" at "search.xqm";
declare namespace templates="http://exist-db.org/xquery/templates";

declare namespace util="http://exist-db.org/xquery/util";
declare namespace text="http://exist-db.org/xquery/text";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace coerp="http://coerp.uni-koeln.de/schema";

declare function corpus:test($node as node()*, $model as map(*), $term as xs:string, $param as xs:string) as xs:string{

let $test := concat("im Alive ",$term, " ",$param)
return $test
};




declare function corpus:scanDB($db as node()*, $param as xs:string, $term as xs:string) as node()* {
        let $db := collection("/db/apps/coerp_new/data/texts")
        let $range := concat("//range:field-contains(('",$param,"'),'",$term,"')")
        let $build := concat("$db",$range)
        return util:eval($build)
        
};
declare function corpus:scanDB_map($node as node(), $model as map(*),  $param as xs:string, $term as xs:string) {
        let $db := collection("/db/apps/coerp_new/data/texts")
    (:    let $term := if($param eq "translator" or $param eq "author") then (
                if( contains($term,"-")) then 
                concat(substring-before($term,"-"),", ",substring-after($term,"-"))
                else $term
                ) else $term:)
        let $result := if($param = "periods") then corpus:getDateResults($term,$db) else corpus:getResults($param,$term,$db)
        return  map {
        "results" := $result,
        "sum" := fn:count($result)
        }
};

declare function corpus:getDateResults($term as xs:string, $db as node()*) {
            let $from := xs:integer(substring-before($term,"-"))
            let $to := xs:integer(substring-after($term,"-"))
            for $year in ($from to $to)
                return search:get-date-search($db,$year)
};

declare function corpus:getResults($param as xs:string, $term as xs:string, $db as node()*) {
        let $range := concat("//range:field-contains(('",$param,"'),'",$term,"')")
        let $build := concat("$db",$range)
        return util:eval($build)
};

declare function corpus:AnalyzeResults($node as node(), $model as map(*)) {
    let $item := $model("result")
let $author :=  $item//coerp:coerp_header/coerp:author_profile/coerp:author/data(.) 
    let $short_title := $item//coerp:coerp_header/coerp:text_profile/coerp:short_title/data(.)
    let $year :=  $item//coerp:coerp_header/coerp:text_profile/coerp:year/coerp:from/data(.)
    let $genre :=  $item//coerp:coerp_header/coerp:text_profile/coerp:genre/data(.) 
    let $title :=   $item//coerp:coerp_header/coerp:text_profile/coerp:title/data(.) 
    let $denom :=   $item//coerp:coerp_header/coerp:author_profile/coerp:denom/data(.) 
    let $translator := $item//coerp:coerp_header/coerp:author_profile/coerp:translator/data(.) 
    let $author_preface := $item//coerp:coerp_header/coerp:author_profile/coerp:author_preface/data(.) 
    
    return map {
        "author" := $author,
        "short_title" := $short_title,
        "year" := $year,
        "genre" := $genre,
        "title" := $title,
        "denom" := $denom,
        "translator" := $translator,
        "author_preface" := $author_preface,
        "ref" := concat($helpers:app-root,"/text/",$short_title),
       "filename" := root($item)/util:document-name(.)
    }
};

declare function corpus:printData($node as node(), $model as map(*), $target as xs:string) {
    if($model($target) != "") then $model($target) else "-"
};

declare function corpus:printShortTitle($node as node(), $model as map(*)) {
    <a href="{$model("ref")}">{$model("short_title")}</a>
};


declare  function corpus:CheckData($node as node(), $model as map(*), $target as xs:string) {
      if($model($target) != "") then
      <div class="">
      {templates:process($node/node(), $model) }
      </div>
      else ""
};





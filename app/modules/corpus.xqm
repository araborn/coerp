xquery version "3.0";

module namespace corpus="http://localhost:8080/exist/apps/coerp_new/corpus";

import module namespace helpers="http://localhost:8080/exist/apps/coerp_new/helpers" at "helpers.xqm";

import module namespace search="http://localhost:8080/exist/apps/coerp_new/search" at "search.xqm";
declare namespace templates="http://exist-db.org/xquery/templates";

declare namespace util="http://exist-db.org/xquery/util";
declare namespace text="http://exist-db.org/xquery/text";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace tei="http://www.tei-c.org/ns/1.0";

declare function corpus:test($node as node()*, $model as map(*), $term as xs:string, $param as xs:string) as xs:string{

let $test := concat("im Alive ",$term, " ",$param)
return $test
};




declare function corpus:scanDB($db as node()*, $param as xs:string, $term as xs:string) {
        
        let $results := switch($param) 
                                    case "genre-subtype" case "genre" return search:range-MultiStats($db,"genre-subtype","eq",$term)
                                    case "date" return search:range-date($db,substring-before($term,"-"),substring-after($term,"-"),"date")
                                    default return "Error"
     return $results
        
        
};

declare function corpus:mapScanDB($node as node(), $model as map(*),$param as xs:string+, $term as xs:string+, $orderBy as xs:string?) {
        let $db := collection("/db/apps/coerp_new/data/texts")
        let $eq := for $par in $param return "eq"
        let $results := if($param eq "date") then search:range-date($db,substring-before($term,"-"),substring-after($term,"-"),"date")
                                    else search:range-MultiStats($db,$param,$eq,$term)
        let $results := switch($orderBy) 
                                    case "date" return for $hit in $results order by $hit//tei:date[@type="this_edition"]/@when return $hit
                                    case "title" return for $hit in $results order by $hit//tei:title[@type="short"]/data(.) return $hit
                                    case "author" return for $hit in $results order by $hit//tei:author[@role="author"]/data(.) return $hit
                                    default return $results
        return map {
            "results" := $results,
            "term" := $term,
            "param" := $param,
            "order" := $orderBy,
            "count" := count($results)
        }
};

declare function corpus:mapEntry($node as node(), $model as map(*)) {
    let $db := $model("result")
    let $url : = <a href="{$helpers:app-root}/text/{substring-before(root($db)/util:document-name(.),".xml")}">{$db//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:title[@type = "short"]/data(.)}</a>
    return map {
        "author" := $db//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:author[@role = "author"]/data(.),
        "short-title" := $db//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:title[@type = "short"]/data(.),
        "long-title" := $db//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:title[@type = "main"]/data(.),
        "date" := $db//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:date[@type ="this_edition"]/data(.),
        "genre" := $db//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:note[@type = "genre"]/data(.),
        "link" := root($db)/util:document-name(.),
        "url" := $url
        
    }
};

declare function corpus:createSortBy($node as node(), $model as map(*),$sort as xs:string,$orderBy as xs:string) {
    let $link := if(contains($helpers:request-path,"/date") )
            then substring-before($helpers:request-path,"/date")
        else if (contains($helpers:request-path,"/author"))
            then substring-before($helpers:request-path,"/author")
        else if (contains($helpers:request-path,"/title"))
            then substring-before($helpers:request-path,"/title")
        else $helpers:request-path   
     let $name := switch($sort) 
            case "date" return "Chronolgical"
            case "title" return "Title"
            case "author" return "Author"
            default return "Error"
     return if($orderBy eq $sort) then <a href="{$link}" class="selected"><span >{$name}</span></a>
    else
    <a href="{$link}/{$sort}"><span >{$name}</span></a>
};
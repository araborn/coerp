xquery version "3.0";

module namespace doc="http://localhost:8080/exist/apps/coerp_new/doc";

import module namespace helpers="http://localhost:8080/exist/apps/coerp_new/helpers" at "helpers.xqm";
declare namespace templates="http://exist-db.org/xquery/templates";

declare namespace coerp="http://coerp.uni-koeln.de/schema";

declare function doc:test($node as node()*, $model as map(*), $text as xs:string) as xs:string*{

let $test := "im Alive"
return ($test,xmldb:decode-uri($text))
};




declare    %templates:wrap function doc:fetchDatasetByRequestedId($node as node(), $model as map(*), $text as xs:string) {
    let $dataset := doc( concat("/db/apps/coerp_new/data/texts/",$text)) (: corpus:getDatasetByShortTitle(request:get-attribute("$exist:resource")) :)
    return map:entry("dataset", $dataset)
};


declare %templates:wrap function doc:analyzeTextHeader($node as node(), $model as map(*)) {
    let $data := $model("dataset")
    let $res := $data//coerp:coerp_header
    return map {
    "author" := $res/coerp:author_profile/coerp:author/data(.),
    "translator" := $res/coerp:author_profile/coerp:translator/data(.),
    "denom" := $res/coerp:author_profile/coerp:denom/data(.),
    "date" := doc:createDate($res),
   "title" := $res/coerp:text_profile/coerp:title/data(.),
   "stitle" := $res/coerp:text_profile/coerp:short_title/data(.),
   "source" := $res/coerp:text_profile/coerp:source/data(.),
   "sampling" := $res/coerp:text_profile/coerp:sampling/coerp:info/data(.),
   "genre" := $res/coerp:text_profile/coerp:genre/data(.)
    }
};


declare function doc:createDate($data as node()) {
    
    let $res := $data/coerp:text_profile/coerp:year
    
  return if($res/coerp:from/data(.) = $res/coerp:to/data(.)) then $res/coerp:from/data(.) else <span>first edition : {$res/coerp:from/data(.)}<br />this edition :  {$res/coerp:to/data(.)}</span>
  };
declare function doc:printMapEntry($node as node(), $model as map(*), $type as xs:string) {
$model($type)
};

declare function doc:getText($dataset as document-node()) {
    $dataset/*/coerp:text
};

declare   %templates:wrap function doc:printFormattedText($node as node(), $model as map(*)) {
    doc:formatText(doc:getText($model("dataset")))
};
declare function doc:formatText($node) as item()* {
    typeswitch($node)
        case text() return helpers:linebreaksToHTML($node)
        case element()
            return switch($node/name())
                case 'sup' return
                    element sup { 
                        doc:passFormat($node) 
                    }
                case 'speaker' 
                case 'sample' return
                    element div {
                        attribute class { $node/name() },
                        attribute data-id { $node/@id/string() },
                        if ( exists($node/@type)) then
                            attribute title { $node/@type/string() }
                            else (),
                        doc:passFormat($node)
                    }
                case 'pb' 
                case 'fol' return
                    let $titleAttribute := 
                        if ( exists($node/@type) and exists($node/@reading) ) then
                            attribute title { $node/@type/string() || ': ' || $node/@reading/string() }
                        else ()
                    let $content := 
                        if (exists($node/@n)) then 
                            $node/@n/string()
                        else
                            if ($node/name() eq 'pb') then '' else '[folio sheet ending]'
                    return 
                        element div { 
                            attribute class { $node/name() }, 
                            $titleAttribute, 
                            $content 
                        }
                case 'comment' return
                    let $titleString := 
                        if ( exists($node/@reading) ) then
                            $node/@type/string() || ': ' || $node/@reading/string()
                        else 
                            $node/@type/string()
                    return 
                        element div { 
                            attribute class { "comment" }, 
                            attribute title { $titleString }, 
                            doc:passFormat($node) 
                        }
                case 'bible'
                case 'psalm'
                case 'quotation' return
                    element div {
                        attribute class { $node/name() },
                        attribute title { $node/@ref/string() },
                        doc:passFormat($node) 
                    }
                case 'foreign' return
                    let $omittedAttribute := 
                        if ( exists($node/@omitted) ) then
                            attribute data-omitted { $node/@omitted/string() }
                        else ()
                    return
                        element div {
                            attribute class { "foreign" },
                            attribute title { "Language: " || $node/@language/string() },
                            $omittedAttribute,
                            doc:passFormat($node) 
                        }
                        case 'foreign_omitted' return
                        element div {
                            attribute class { $node/name() },
                            attribute title { "Language: " || $node/@language/string() },
                            doc:passFormat($node) 
                        }
                default return
                    element div { 
                        attribute class { $node/name() }, 
                        doc:passFormat($node) 
                    }
        default return doc:passFormat($node)
};

(:
 : Hilfsfunktion zum rekursiven Aufruf von dataset:formatText()
 : ruft formatText() für alle Kindknoten des übergebenen Elements auf.
 :)
declare function doc:passFormat($nodes as node()*) {
    for $node in $nodes/node() return doc:formatText($node)
};
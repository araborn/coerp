xquery version "3.0";

module namespace doc="http://localhost:8080/exist/apps/coerp_new/doc";

import module namespace helpers="http://localhost:8080/exist/apps/coerp_new/helpers" at "helpers.xqm";
declare namespace templates="http://exist-db.org/xquery/templates";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare function doc:getText($node as node(), $model as map(*),$xml as xs:string) {
    let $file := doc(concat("/db/apps/coerp_new/data/texts/",$xml,".xml"))
    let $genre := $file//tei:note[@type="genre"]/@subtype/data(.)
    let $stylesheet := switch($genre) 
                                    case "catechism" case "preface_catechism" return "catechism"
                                    default return "texts"
                                    
    let $stylesheet := doc(concat("/db/apps/coerp_new/xslt/",$stylesheet,".xsl"))
    
        return transform:transform($file, $stylesheet, ())

};

declare function doc:getControll($node as node(), $model as map(*), $xml as xs:string) {
    let $file := doc(concat("/db/apps/coerp_new/data/texts/",$xml,".xml"))
     
    let $biblical := if(exists($file//tei:quote[@type ="biblical"])) then <item type="biblical" title="Bible References"/> else ()
    let $psalm := if(exists($file//tei:quote[@type ="psalm"])) then <item type="psalm" title="Psalmtext"/> else ()
    let $references := if(exists($biblical) or exists($psalm)) then <item title="References">{($biblical,$psalm)}</item> else ()
    
    let $sample := <item type="tx-sample" title="Samples"/>
    let $pb := if(exists($file//tei:pb)) then  <item type="tx-pb" title="Page Breaks"/> else()
    let $fw := if(exists($file//tei:fw)) then  <item type="tx-fw" title="Folio Sheet Delimiters"/> else () 
    let $head := if(exists($file//tei:head)) then <item type="tx-head" title="Headings"/> else () 
    let $speakers := if(exists($file//tei:sp)) then <item type="tx-speaker" title="Speakers"/> else ()
    
    let $structural := <item title="Structural">{($sample,$pb,$fw,$head,$speakers)}</item>
    
    let $illegible := if(exists($file//tei:choice[@ana ="illegible"])) then <item type="illegible" title="Illegible"/> else ()
    let $print := if(exists($file//tei:choice[@ana ="print"])) then <item type="print" title="Print"/> else ()
    let $print-error := if(exists($file//tei:choice[@ana ="print-error"])) then <item type="print-error" title="Print Error"/> else ()
    let $editor := if(exists($file//tei:choice[@ana ="editor"])) then <item type="editor" title="Editor"/> else ()
    
    let $comment := <item title="Comment">{($illegible,$print,$print-error,$editor)}</item>
    
    return map {
        "datas" := ($references,$structural,$comment)
    }   
};

declare function doc:mapControll($node as node(), $model as map(*), $name as xs:string) {
 map {
        "items" := $model($name)/item
    }
};

declare function doc:printTDControll($node as node(), $model as map(*),$name as xs:string) {
    <tr id="{$model($name)/@type/data(.)}">
        <td class="ct-functions" >
            <label>
                <input type="checkbox" class="ct-check " />
                <span class="ct-button ct-{$model($name)/@type/data(.)}" >{$model($name)/@title/data(.)}</span>
            </label>
        </td>        
        <td><i class="glyphicon glyphicon-step-backward" title="next Element" pos="0"/></td>
        <td><i class="glyphicon glyphicon-step-forward" title="previous Element" pos="1"/></td>   
   </tr>
};

declare function doc:printHDControll($node as node(), $model as map(*), $name as xs:string) {
    <span class="ct-header">{$model($name)/@title/data(.)}</span>
};


declare function doc:getTextInfo($node as node(), $model as map(*), $xml as xs:string) {
    let $file := doc(concat("/db/apps/coerp_new/data/texts/",$xml,".xml"))
    let $bible := $file//tei:bibl
    return 
    map {
        "author" := $bible/tei:author[@role="author"]/data(.),
        "translator" := $bible/tei:author[@role="translator"]/data(.),
        "denom" := "Not Set",
        "title" := $bible/tei:title[@type ="main"]/data(.),
        "short-title" := $bible/tei:title[@type = "short"]/data(.),
        "genre" := $bible/tei:note[@type= "genre"]/data(.),
        "date" := $bible/tei:date[@type ="this_edition"]/data(.),
        "source" := concat($bible/tei:idno/@type/data(.)," ",$bible/tei:idno/data(.))
    }
};


declare function doc:links($node as node(), $model as map(*), $xml as xs:string) {
    map {
        "xml" := <a href="{$helpers:app-root}/text/{$xml}/xml" target="_blank">XML</a>
    }
};

declare function doc:test($node as node(), $model as map(*),$xml as xs:string) {
    let $file := doc(concat("/db/apps/coerp_new/data/texts/",$xml,".xml"))
    return map {
    "xml" := $xml,
    "title" := $file//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:title[@type = "short"]/data(.)
    }
};

(:
declare function doc:test($node as node()*, $model as map(*), $text as xs:string) as xs:string*{

let $test := "im Alive"
return ($test,xmldb:decode-uri($text))
};




declare    %templates:wrap function doc:fetchDatasetByRequestedId($node as node(), $model as map(*), $text as xs:string) {
    let $dataset := doc( concat("/db/apps/coerp_new/data/texts/",$text)) (\: corpus:getDatasetByShortTitle(request:get-attribute("$exist:resource")) :\)
    return map:entry("dataset", $dataset)
};


declare function doc:analyzeTextHeader($node as node(), $model as map(*)) {
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
   "genre" := $res/coerp:text_profile/coerp:genre/data(.),
   "text_layout" := $res/coerp:text_profile/coerp:text_layout/@exists
    }
};


declare function doc:createDate($data as node()) {
    
    let $res := $data/coerp:text_profile/coerp:year
    
  return if($res/coerp:from/data(.) = $res/coerp:to/data(.)) then $res/coerp:from/data(.) else <span>first edition : {$res/coerp:from/data(.)}<br />this edition :  {$res/coerp:to/data(.)}</span>
  };
declare function doc:printMapEntry($node as node(), $model as map(*), $type as xs:string) {
$model($type)
};


declare function doc:getDownloadElements($node as node(), $model as map(*), $text as xs:string) {
    let $doc := $text
    return <ul>
    <li class="DownloadButtons"><a  href="{$helpers:request-path}/xml" target="_blank">XML</a></li>
    <li class="DownloadButtons">Quote</li>
    <li  class="DownloadButtons"><a onclick="printContent()">Print</a></li>
    </ul>
    
};

(\:#### Text Layout Darstellung ####:\)

declare function doc:AnaylzeTextLayout($node as node(),$model as map(*)) {
    if($model("text_layout") eq "true") then
    let $data := $model("dataset")
    let $doc := $data//coerp:coerp_header/coerp:text_profile/coerp:text_layout
    let $tags := ("test1","test2")
  return
      map {
        "la_format" := $doc//coerp:format_original/data(.),
         "la_structuring_elements1":= ($doc//coerp:columns/@type/data(.),
                                                     $doc//coerp:columns/@number/data(.)),
         "la_structuring_elements2":= ($doc//coerp:paragraphs/@pos/data(.),
                                                     $doc//coerp:paragraphs/data(.)),
         "la_illustrations1":= ($doc//coerp:illustrations/@exists/data(.),
                                      $doc//coerp:illustrations/@type/data(.)),
         "la_illustrations2":= $doc//coerp:elements/coerp:style/data(.),
         "la_pagination1":=$doc//coerp:pagination_erratic/@exists/data(.),
         "la_pagination2":= ($doc//coerp:contains/@type/data(.),
                                     $doc//coerp:contains/data(.)),
         "la_notes1":=  $doc//coerp:footnotes/@exists/data(.),
         "la_notes2":= $doc//comments_references/@exists/data(.),
         "la_damaged1":= ($doc//coerp:illegible/coerp:page/@type/data(.), 
                                 $doc//coerp:illegible/coerp:page/coerp:from/data(.),
                                 $doc//coerp:illegible/coerp:page/coerp:to/data(.)),
         "la_damaged2":=$doc//coerp:illegible/coerp:page/pageNr/data(.),
         "la_damaged3":=$doc//coerp:illegible/coerp:due_to/data(.),
         "la_damaged4":=($doc//coerp:illegible/coerp:replaced_by/@edition_number/data(.),
                                 $doc//coerp:illegible/coerp:replaced_by/data(.)),
         "la_missing1":= $doc//coerp:missing/coerp:page/@type/data(.),
         "la_mssing2" := $doc//empty_page/@exists/data(.)
    }
    
    else map {
        "tags" := ""
    }
};

declare function doc:getTags($node as node(), $model as map(*)) {
 map:entry("tags",map:keys($model))
};

declare function doc:mapTagValue($node as node(), $model as map(*)) {
     if(substring-after($model("tag"),"la_") != "" and $model($model("tag"))!= "" ) then
     let $tag :=$model("tag")
     let $data := $model($tag)
     return (
     
     (\:doc:mapTagValue( $model("tag")) 
     :\) 
         (\: map {
            "tag_name" :=   ,
             "tag_value":= 
             }
             :\)
     switch($tag)
        case "la_format" return map {
                    "tag_name" := "Format",
                    "tag_value" := $data
                    }
        case "la_structuring_elements1" return map {
                    "tag_name" := "Structuring Elements",
                    "tag_value":= concat($data[1], " printed in ",$data[2], " columns")
                    }
        case "la_structuring_elements2" return map {
                    "tag_name" := "Structuring Elements",
                    "tag_value":= concat($data[1]," ", (if($data[1] = "first") then "paragraph : " else "paragraphs : "),"marked by ",$data[2])
                    }
        case "la_illustrations1"  return if($data[1] = "true") then map {
                    "tag_name" := "Illustrations"  ,
                    "tag_value":= if($data[2] = "framed") then "text is framed by illustrations" else "text contains illustrations"
                }
                else ()
        case "la_illustrations2"    return map {
                    "tag_name" := "Illustrations"  ,
                    "tag_value" := concat("text contains elements which are marked by ",string-join($data,","))
                    }
        case "la_pagination1" return if($data[1] = "true") then map {
                    "tag_name" := "Pagination"  ,
                    "tag_value":= "erratic"
                }
                else ()
         case "la_pagination2" return map {
                "tag_name" :=  "Pagination"  ,
                "tag_value":= concat("original contains ",$data[1],"numbers in the format ",$data[2])
                }
         case "la_notes1" return if($data = "true") then map{
                "tag_name" := "Notes"   ,
                "tag_value":= "Text contains footnotes"
                }
                else ()
         case "la_notes2" return if($data = "true") then map {
                "tag_name" := "Notes"   ,
                "tag_value":="text contains comments and refernes in the margins"
                }
                else ()
         case "la_damaged1" return if( $data[1] != "" and  $data[2] = "") then map  {
             "tag_name" := "Damage"  ,
              "tag_value":= "Original is partly illegible"
             }
             else if ($data[1] != "" and $data[2] != "") then map {
             "tag_name" := "Damage"  ,
                 "tag_value":= concat("Original is illegible on pages ",$data[1]," to ",$data[2])
             }
             else ()
        
        case "la_damaged2" return map {
                "tag_name" := "Damage"  ,
                 "tag_value":= concat("Original is illegible on pages ",string-join($data[1],","))
             }
        case "la_damaged3" return map {
                "tag_name" := "Damage"  ,
                 "tag_value":= concat("due to ",$data)
             }
             case "la_damaged4" return map {
                "tag_name" := "Damage"  ,
                 "tag_value":= concat("illegible words in the original replaced by those of the ",$data[1], " edition from ", $data[2])
             }
         case "la_missing1" return map {
                 "tag_name" := "Damage"  ,
                 "tag_value":= concat("Several ",$data, " are missing in the original.")
         }
         case "la_missing2" return if($data = "true") then map {
                 "tag_name" := "Damage"  ,
                 "tag_value":= "orignal text contains empty pages"
         }
         else ()
        default return "Unformated"
        )
     else ()
};




(\:
declare function doc:mapTagValue($data as xs:string) {
    switch($data) 
    case "la_format" return map {
                    "name" := "Format",
                    "value" := $model($data)
                    }
    default return "Unformated"

};
:\)
declare function doc:fullTextLayout($node as node(), $model as map(*)) {
    let $doc := $model("dataset")//coerp:coerp_header/coerp:text_layout
    return map {
    "format" := $doc//coerp:format_original/data(.),
    "structuring_elements1":= ($doc//coerp:columns/@type,
                                                $doc//coerp:columns/@number),
    "structuring_elements2":= ($doc//coerp:paragraphs/@pos,
                                                $doc//coerp:paragraphs/data(.)),
    "illustrations1":= ($doc//coerp:illustrations/@exists,
                                 $doc//coerp:illustrations/@type),
    "illustrations2":= $doc//coerp:elements/coerp:style/data(.),
    "pagination1":=$doc//coerp:pagination_erratic/@exists,
    "pagination2":= ($doc//coerp:contains/@type,
                                $doc//coerp:contains/data(.)),
    "notes1":=  $doc//coerp:footnotes/@exists,
    "notes2":= $doc//comments_references/@exists,
    "damaged1":= ($doc//coerp:illegible/coerp:page/@type, 
                            $doc//coerp:illegible/coerp:page/coerp:from/data(.),
                            $doc//coerp:illegible/coerp:page/coerp:to/data(.)),
    "damaged2":=$doc//coerp:illegible/coerp:page/pageNr/data(.),
    "damaged3":=$doc//coerp:illegible/coerp:due_to/data(.),
    "damaged4":=($doc//coerp:illegible/coerp:replaced_by/@edition_number,
                            $doc//coerp:illegible/coerp:replaced_by/data(.)),
    "missing":= ($doc//coerp:missing/coerp:page/@type,
                        $doc//empty_page/@exists)
    }
};


(\: ### NEW HEADER FETCHING ###:\)
declare function doc:get-text-layout($node as node(), $model as map(*), $text as xs:string){
    let $xml := doc( concat("/db/apps/coerp_new/data/texts/",$text))//coerp:text_profile
    let $stylesheet := doc("/db/apps/coerp_new/xslt/texts.xsl")
    return transform:transform($xml, $stylesheet, ())
};

(\:#### Text Darstellung ####:\)

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

(\:
 : Hilfsfunktion zum rekursiven Aufruf von dataset:formatText()
 : ruft formatText() für alle Kindknoten des übergebenen Elements auf.
 :\)
declare function doc:passFormat($nodes as node()*) {
    for $node in $nodes/node() return doc:formatText($node)
};:)
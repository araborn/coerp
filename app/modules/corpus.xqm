xquery version "3.0";

module namespace corpus="http://localhost:8080/exist/apps/coerp_new/corpus";

import module namespace helpers="http://localhost:8080/exist/apps/coerp_new/helpers" at "helpers.xqm";

import module namespace search="http://localhost:8080/exist/apps/coerp_new/search" at "search.xqm";
declare namespace templates="http://exist-db.org/xquery/templates";

declare namespace util="http://exist-db.org/xquery/util";
declare namespace text="http://exist-db.org/xquery/text";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace coerp="http://coerp.uni-koeln.de/schema/coerp";

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
declare function corpus:scanDB_map($node as node(), $model as map(*),  $param as xs:string, $term as xs:string, $ordertype as xs:string) {
        let $db := collection("/db/apps/coerp_new/data/texts")
    (:    let $term := if($param eq "translator" or $param eq "author") then (
                if( contains($term,"-")) then 
                concat(substring-before($term,"-"),", ",substring-after($term,"-"))
                else $term
                ) else $term:)
        let $result := if($param = "periods") then corpus:getDateResults($term,$db) else search:RangeSearch_simple($db,$param,$term)
        (:corpus:getResults($param,$term,$db):)
        return  map {
        "results" := $result,
        "ordertype" := $ordertype,
        "param" := $param,
        "term" := $term
        }
};

declare function corpus:getDateResults($term as xs:string, $db as node()*) {
            let $from := xs:integer(substring-before($term,"-"))
            let $to := xs:integer(substring-after($term,"-"))
            for $year in ($from to $to)
                return search:get-date-search($db,$year)
};

declare function corpus:getResults($param as xs:string, $term as xs:string, $db as node()*) {
        let $range := concat("//range:field-eq(('",$param,"'),'",$term,"')")
        let $build := concat("$db",$range)
        return util:eval($build)
};

declare function corpus:AnalyzeResults($node as node(), $model as map(*),$get as xs:string) {
    let $item := $model($get)
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


declare function corpus:MapNavBar($node as node()*, $model as map(*), $get as xs:string) {
    let $results := $model($get)
    let $auth_name := for $hit in $results//coerp:coerp_header/coerp:author_profile/coerp:author/data(.) 
                                    order by $hit return substring($hit,1,1)
    let $auth_name := distinct-values($auth_name)
    let $date_range :=  for $hit in $results//coerp:coerp_header/coerp:text_profile/coerp:year/coerp:from/data(.)
                                       order by $hit return $hit             
    let $date_range := distinct-values($date_range)
    
    let $short_title := for $hit in $results//coerp:coerp_header/coerp:text_profile/coerp:short_title/data(.)
                                    order by $hit return substring($hit,1,1)
    let $short_title := distinct-values($short_title)
    
    
    let $ordertype := $model("ordertype")
    let $spec := if($ordertype = "alpha") 
                            then $auth_name
                            else if ($ordertype = "crono") then $date_range
                            else $short_title
    let $denoms := for $hit in $results//coerp:coerp_header/coerp:author_profile/coerp:denom/data(.) 
                                order by $hit return $hit
    let $denoms := distinct-values($denoms)
    
    let $genres :=  for $hit in $results//coerp:coerp_header/coerp:text_profile/coerp:genre/data(.) 
                                order by $hit return $hit
    let $genres := distinct-values($genres)
    return map {
        "spec" := $spec,
        "denoms" := if(count($denoms) != 1) then $denoms else (),
        "genres" := if(count($genres) != 1) then $genres else (),
        "sum" := fn:count($results)
    } 
};


declare function corpus:getResultsSpecified($node as node(), $model as map(*),$get as xs:string) {
let $db := $model($get)
let $ordertype := $model("ordertype")
let $result := if($ordertype = "alpha") 
                        then search:RangeSearch_Starts-With("author",$model("value"),$db)
                        else if ($ordertype = "crono") then search:RangeSearch_simple($db, "year_from",$model("value")) 
                        else search:RangeSearch_Starts-With("short_title",$model("value"),$db)
return map {
   "specified" := $result

}
};
(:
declare function corpus:getResultsContainsLetter($db as node(*)){
         search:Search_Starts-With("author",$model("letter"),$db)
     (:   return map {
            "specified" := $results
        } :)
};
:)
declare function corpus:printLetterColumm($node as node()*, $model as map(*),$value as xs:string) {
    <div class="ListLetterColumn" id="{$model($value)}"><span class="ListLetterLetter">{$model($value)}</span>
    <div class="HiddenCategoryBar">{
    for $hit in ($model("denoms"),$model("genres"))
  return   <span class="{$hit}-Hidden ListHiddenCategory" ><i class='glyphicon glyphicon-eye-close ButtonEye-LetterBar' title="{$hit}" /></span>
    
    }  </div></div>
};

declare function corpus:printLetterNavBar($node as node()*, $model as map(*), $value as xs:string) {
   <span class="ListNavBarLetter"><a href="#{$model($value)}">{$model($value)}</a><span class="LetterPlace">|</span></span> 

};

(: if ($("#date").is(":checked"))
        {{
        $("#list").load("{$helpers:app-root}/"+author+"/"+textType+"?ordertype=date");
        
        }}
        else{{
        $("#list").load("{$helpers:app-root}/"+author+"/"+textType+"?ordertype=alphab"); 
        }}:)
declare  function corpus:printRecorder($node as node(), $model as map(*)) as node() {
    let $script := <script type="text/javascript">
        
       function reorder(value){{
        var url = window.location.href;
        var i = url.lastIndexOf("/");
        var substr = url.substring(0,i);
        i = substr.lastIndexOf("/");
        var author = substr.substring(i+1,substr.length);
        var textType = url.substring(url.lastIndexOf("/")+1,url.length);
        
        window.location.href ="{$helpers:app-root}/"+author+"/"+textType+"?ordertype="+value;
        
        
        }}
    </script> 
    return $script
};

declare function corpus:printOrderNavElements($node as node(), $model as map(*), $param as xs:string,$term as xs:string) {
(:
let $title := <button type="submit" name="ordertype" value="title" class="ListNavBarButtons">Title</button>
let $crono := <button type="submit" name="ordertype" value="crono" class="ListNavBarButtons">Cronological</button>
let $alpha := <button type="submit" name="ordertype" value="alpha" class="ListNavBarButtons">Author Name</button>
class="Button-Type2"
:)
let $ext :=  if($param = "author") then <input type="hidden" name="name" value="{$term}"/> else ()
let $title := <span class="ListNavBarButtons"><span class="ListNavBarLetter"><a>Title</a><span class="LetterPlace">|</span></span><form><input type="hidden" name="ordertype" value="title"/>{$ext}</form></span>
let $crono := <span class="ListNavBarButtons"><span class="ListNavBarLetter"><a>Cronological</a><span class="LetterPlace">|</span></span><form><input type="hidden" name="ordertype" value="crono"/>{$ext}</form></span>
let $alpha := <span class="ListNavBarButtons"><span class="ListNavBarLetter"><a>Author Name</a><span class="LetterPlace">|</span></span><form><input type="hidden" name="ordertype" value="alpha"/>{$ext}</form></span>

return if($param = "author") then <span>{($title,$crono)}</span>
                            
                            else <span>{($title,$crono, $alpha)}</span>



};

declare function corpus:printSectionFilter($node as node(), $model as map(*), $value as xs:string,$typus as xs:string, $eye as xs:string?) {
if($eye = "yes") then <span class="ListNavBarLetter ButtonEyeToggle" onclick="HideSpecialEntrys('{$typus}','{$model($value)}')"><a><i class="glyphicon glyphicon-eye-open ButtonEye"/>{$model($value)}</a><span class="LetterPlace">|</span></span>
else 
        <span class="ListNavBarLetter" onclick="HideSpecialEntrys('{$typus}','{$model($value)}')"><a>{$model($value)}</a><span class="LetterPlace">|</span></span>
};

declare function corpus:printSectionFilterButton($node as node(), $model as map(*), $value as xs:string,$typus as xs:string) {
        <span class="ListNavBarButtons" onclick="HideSpecialEntrys('{$typus}','{$model($value)}')"><span class="Button-Type2"><i class="glyphicon glyphicon-eye-open ButtonEye"/>{$model($value)}</span></span>
};
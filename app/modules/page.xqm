xquery version "3.0";

module namespace page="http://localhost:8080/exist/apps/coerp_new/page";

import module namespace helpers="http://localhost:8080/exist/apps/coerp_new/helpers" at "helpers.xqm";
import module namespace corpus="http://localhost:8080/exist/apps/coerp_new/corpus" at "corpus.xqm";
import module namespace search="http://localhost:8080/exist/apps/coerp_new/search" at "search.xqm";


declare namespace util="http://exist-db.org/xquery/util";
declare namespace text="http://exist-db.org/xquery/text";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace coerp="http://coerp.uni-koeln.de/schema/coerp";
declare namespace functx = "http://www.functx.com";


declare function page:createNavigation ($node as node(), $model as map(*)) {
    let $list := doc("/db/apps/coerp_new/data/lists.xml")/lists/list
    let $hierarchies := for $hit in $list/tab where $hit/term/@xml:id/data(.) eq "hierarchies" 
                                        return page:createNavigationsItems($hit)
    let $sets := for $hit in $list/tab where $hit/term/@xml:id/data(.) eq "sets" 
                                        return page:createNavigationsItems($hit)
                                            
                                           
    
    return map {
        "hierarchies" := $hierarchies,
        "sets" := $sets
    }
};

declare function page:createNavigationsItems($hit) {
    for $tab in $hit/list/tab                                                
                                            return   if(exists($tab/term)) then <item title="{$tab/term/data(.)}" type="{$tab/term/@type}">
                                                    {
                                                    for $item in $tab/list/tab                                                         
                                                        return  <item title="{$item/term/data(.)}" type="{$item/term/@type}"/>
                                                    }
                                                </item>
                                                else <item title="{$tab/term/data(.)}" type="{$tab/term/@type}"/>
};
declare function page:printNavigations($node as node(), $model as map(*), $get as xs:string) {    
    page:CaseNavigation($model($get))
        
};

declare function page:CaseNavigation($item) {
switch($item/@type/data(.))
        case "title" return <div class="title">{$item/@title/data(.)}</div>
        case "headline" return <div class="headline">{$item/@title/data(.)}</div>
        case "line" return <div class="line"/>
        case "list" return (<div class="list">{$item/@title/data(.)}</div>,<ul>
                                            {for $hit in $item/item return <li>{page:CaseNavigation($hit)}</li>}
                                      </ul>)
        default return $item
};

declare function page:checkData($param as xs:string, $type as xs:string) as xs:boolean {
      let $return :=   if (corpus:scanDB(collection("/db/apps/coerp_new/data/texts"),$param,$type) != "") then fn:true()
      else fn:false()
      return $return
        
};

declare function page:checkDateRange($date as xs:string) {
let $begin := xs:integer(substring-before($date,"-"))
let $end := xs:integer(substring-after($date,"-"))
let $results := (for $year in ($begin to $end)
             return   search:get-date-search(collection("/db/apps/coerp_new/data"),$year) )
return if(count($results) != 0) then fn:true() else fn:false()
 
};

declare function page:DecodeAuthors($author as xs:string) {
   let $name := for $letter in page:chars($author) return page:DecodeAuthors_for($letter)
        return $name
};

declare function page:DecodeAuthors_for($letter as xs:string) {

         switch ($letter) 
           case 'é' return '&#146;'
             case "," return "-"
             
             default return $letter
             

};
declare function page:chars( $arg as xs:string? )  as xs:string* {

   for $ch in string-to-codepoints($arg)
   return codepoints-to-string($ch)
 } ;

declare function page:createAdvSearch() as node() {
    let $code := <div class="adv_search">
                   <div class="adv_types PageBorders-none-top">
                       <div class="adv_types_tab" id="tab_periods">Periods</div>
                       <div class="adv_types_tab" id="tab_genres">Genres</div>
                       <div class="adv_types_tab" id="tab_denominations">Denominations</div>
                   </div>
                   <div class="adv_fields_div">
                   <div class="adv_fields PageBorders-none-top-left" id="adv_periods">
                       <div class="adv_fields_tab">
                            <label for="amount">Period Range:</label>
                            <input type="search" id="amount"  name="date"/>
                            <div id="RangeSlider"></div>
                            <div id="adv_button_presets" class="adv_periods_buttons">Presets</div>
                            <div id="adv_button_custom" class="adv_periods_buttons">Custom</div>
                            <div id="adv_presets">
                                <span class="adv_presets" id="1150-1499">Middle English</span>
                                <span class="adv_presets" id="1500-1699">Early Modern English</span>
                            </div>
                            <div id="adv_custom">
                                <label for="from">From</label>
                                <input  type="number" name="dat_from"  class="adv_custom_input" id="from"  min="1150" max="1699"/>
                                <label for="to">To</label>
                                <input  type="number" name="dat_to" class="adv_custom_input" id="to" min="1150" max="1699" />
                            </div>
                       </div>
                   </div>
                   <div class="adv_fields PageBorders-none-top-left" id="adv_genres">
                       <div class="adv_fields_tab">
                           <h4>core</h4>
                               <ul>
                                    <li><input type="checkbox" name="genre" value="prayers" id="prayer" /> <label for="prayer">Prayer</label>
                                    </li><li><input type="checkbox" name="genre" value="sermon" id="sermon" /> <label for="sermon">Sermon</label>
                                    </li><li><input type="checkbox" name="genre" value="treatise" id="treatise" /> <label for="treatise">Treatise</label>
                                    </li><li><input type="checkbox" name="genre" value="treatise_controversial" id="treatise_controversial" /> <label for="treatise_controversial">Controversial Treatise</label>
                                    </li><li><input type="checkbox" name="genre" value="catechism" id="catechism" /> <label for="catechism">Catechism</label>
                                    </li><li><input type="checkbox" name="genre" value="catechism_mimetic" id="catechism_mimetic" /> <label for="catechism_mimetic">Mimetic Catechism</label>
                                    </li> 
                               </ul>
                           
                       </div>
                       <div class="adv_fields_tab">
                           <h4>minor</h4>
                               <ul>
                               <li><input type="checkbox" name="genre" value="biography" id="religious_biography" /> <label for="biography">Religious Biography</label>
                               </li>
                               </ul>
                       </div>
                   </div>
                   <div class="adv_fields PageBorders-none-top-left" id="adv_denominations">
                       <div class="adv_fields_tab">
                               <ul>
                               <li><input type="checkbox" name="denom" value="Anglican" id="anglican"/> <label for="anglican">Anglican</label>
                               </li><li><input type="checkbox" name="denom" value="Catholic" id="catohlic"/> <label for="catohlic">Catholic</label>
                               </li><li> <input type="checkbox" name="denom" value="Nonconformist" id="nonconformist"/> <label for="nonconformist">Nonoconformist</label>
                               </li><li><input type="checkbox" name="denom" value="Unknown" id="unknown"/> <label for="unknown">Unknown</label>
                               </li></ul>
                       </div>
                   </div>
               </div>
               </div>
               return $code

};

declare function page:getGenres($type as xs:string) as xs:string* {
        let $db := collection("/db/apps/coerp_new/data/texts")
        return
        if($type = "att") then 
        for $doc in $db
            return $doc//coerp:coerp/coerp:coerp_header/coerp:text_profile/coerp:genre/attribute()
        else 
         for $doc in $db
            return $doc//coerp:coerp/coerp:coerp_header/coerp:text_profile/coerp:genre/data(.)
};

declare function page:postGenres() as item()+ {
    let $att := distinct-values(page:getGenres("att"))
     for $data in $att
    let $dat := doc("/db/apps/coerp_new/data/lists.xml")//term[@xml:id=$data][1]/data(.)
    order by $dat
   return    <item att="{$data}"  dat="{$dat}"/>
   (:
   let $dat := distinct-values(page:getGenres("dat"))
    for $item in $att
    return  <item att="{$att}"  dat="{$dat}" />
    :)
};


declare function page:analyzedGenres() as item()* {
    for $item in page:postGenres()
    return
    if( contains($item/@att/data(.),"_")) then
        <item att="{$item/@att/data(.)}" dat="{$item/@dat/data(.)}" type="{substring-after($item/@dat/data(.)," ")}" list="list" />
        else 
        <item att="{$item/@att/data(.)}" dat="{$item/@dat/data(.)}" list="" type=""/>
};



declare function page:PrintAuthors($type as xs:string, $abc as xs:string) {
    distinct-values( (page:SearchAuthors($type,$abc), page:SearchAuthors($type,$abc)))

    };

declare function page:SearchAuthors($type as xs:string, $abc  as xs:string) {
if($type eq "author") then 
    search:Search_Authors-Translator_StWi($type,$abc)//coerp:author/data(.)
    else     search:Search_Authors-Translator_StWi($type,$abc)//coerp:translator/data(.)
};

(: ################ Next Try ################# :)

declare function page:CollectNavElements($node as node(), $model as map(*)) {
    let $db := collection("/db/apps/coerp_new/data/texts")
    let $list := doc("/db/apps/coerp_new/data/lists.xml")//list[@type="navigation"]
    
    return map {
    "db" := $db,
    "tabs" := $list
    }
    
};

declare function page:GetNavElements($node as node(), $model as map(*),$target as xs:string, $id as xs:string) {

      map {
     "title" := $model($target)/tab[@xml:id=$id]/term/data(.),
     "list" := $model($target)/tab[@xml:id=$id]/list/tab,
     "LinkTarget" := $id
    }
    
};

declare function page:ScanNavElements($node as node(), $model as map(*), $target as xs:string) {
    let $tab := $model($target)
    
   return map {
    "TabName" := $tab/term/data(.),
    "TabType" := $tab/term/attribute(),
    "SecList" := $tab/list/tab
   }

};

declare function page:PrintTabData($node as node(), $model as map(*), $target as xs:string) {
    $model($target)/term/data(.)
};

declare function page:PrintTabs($node as node(), $model as map(*)) {
    let $TabType := $model("TabType")
    return
                if($TabType ="line") then <div class="NavLine"></div>
                else if ($TabType = "headline") then <div class="SubNavTab_head">{$model("TabName")}</div>
                else if($TabType = "SubNav") then (
                    if($model("SecList") != "") then
                    <div class="SubNavTab">{$model("TabName")}</div>
                    else <div class="EmptyTab">{$model("TabName")}</div>
                    )
                else <a href="{$helpers:app-root}/{$model("LinkTarget")}/{$model("TabType")}">{$model("TabName")}</a>
};

declare function page:PrintData($node as node(), $model as map(*), $target as xs:string) {
    $model($target)
};

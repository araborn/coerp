xquery version "3.0";

module namespace page="http://localhost:8080/exist/apps/coerp_new/page";

import module namespace helpers="http://localhost:8080/exist/apps/coerp_new/helpers" at "helpers.xqm";
import module namespace corpus="http://localhost:8080/exist/apps/coerp_new/corpus" at "corpus.xqm";
import module namespace search="http://localhost:8080/exist/apps/coerp_new/search" at "search.xqm";


declare namespace util="http://exist-db.org/xquery/util";
declare namespace text="http://exist-db.org/xquery/text";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace coerp="http://coerp.uni-koeln.de/schema";
declare namespace functx = "http://www.functx.com";


declare function page:createNavigation ($node as node(), $model as map(*)) {
let $list := doc("/db/apps/coerp_new/data/lists.xml")

return <ul class="MainNavList"> {
  for $Tab in $list/lists/list[@type="navigation"]/tab
           return (<div class="MainNavContent ">
           {if($Tab/term/data(.) = "Logo") then
                    <a href="{$helpers:app-root}/index.html"> <li class="HeadTab"><img src="{$helpers:app-root}/resources/img/CoERP-Logo-2_neu_klein.png" alt="Logo" id="logo"/></li></a>
           else  if($Tab/term/data(.) = "Search") then 
                <div id="searchTab">
                <form  action="{$helpers:app-root}/search" method="post" id="SearchForm">
                    <div id="searchDiv">
                    
                        <input id="search" type="search" name="term" placeholder="Search ..." />
                        <div id="search_adDiv" class="searchButtons">Advanced Search</div>
                       
                    </div>
                    {page:createAdvSearch()}
                     </form>
                    <div id="searchButton" class="searchButtons ">
                        <i  class="glyphicon glyphicon-search " id="search_icon" ></i>
                    </div>
                    
                </div>
           else if ( $Tab/term/attribute() = "genres") then 
                    (
                                <div class="MainNavTab emboss"> <li class="HeadTab" id="Tab_{$Tab/term/data(.)}">{$Tab/term/data(.)}</li></div>,
                           (
                           <div class="SecNavTab"><ul id="List_genres" class="MainNavList"> {(
                                 for $item in page:analyzedGenres() return
                                 <div class="SubNavTab_div emboss {$item/@list/data(.)}" id="{$item/@type/data(.)}"><a href="{$helpers:app-root}/genre/{$item/@att/data(.)}"><li class="SubNavTab">{$item/@dat/data(.)}</li></a></div>
                               )}
                                </ul></div> )
                     )         
           (: else if($Tab/term/attribute() = "authors") then (
                    <div class="MainNavTab emboss"> <li class="HeadTab" id="Tab_{$Tab/term/data(.)}">{$Tab/term/data(.)}</li></div>, ( 
                        <div class="SecNavTab"><ul id="List_authors" class="MainNavList">{(
                            for $item in $Tab/list/tab/term return
                            <div class="SubNavTab_div"><li class="SubNavTab">Blaaa{$item/data(.)}</li></div>
                        )}</ul></div>
                    )
                ):)
           else
                     <div class="MainNavTab emboss"> <li class="HeadTab" id="Tab_{$Tab/term/data(.)}">{$Tab/term/data(.)}</li></div> 
           }
           {( 
                if(exists($Tab/list/tab)) then <div class="SecNavTab"> <ul class="{$Tab/list/attribute()}" id="List_{$Tab/term/attribute()}">{
                for $SecTab in $Tab/list/tab return ( 
                    if(exists($SecTab/list/tab)) then <div class="ListTab emboss"><li class="SubNavTab_List" id="Tab_{$SecTab/term/attribute()}">{$SecTab/term/data(.)}</li> {
                        <div class="SubNavList_div emboss"><ul class="{$SecTab/list/attribute()}" id="List_{$SecTab/term/attribute()}"> {
                            for $ThiTab in $SecTab/list/tab  return
                            if($SecTab/term/attribute() != "periods" and exists($ThiTab/term[@xml:id]) ) then
                                if(page:checkData("genre",$ThiTab/term/attribute()) = fn:true() ) then 
                                <div class="ThiNavTab_div emboss"><a href="{$helpers:app-root}/genre/{$ThiTab/term/attribute()}"><li class="ThiNavTab">{$ThiTab/term/data(.)}</li></a></div> 
                                else <div class="EmptyTab inset"><li class="ThiNavTab">{$ThiTab/term/data(.)}</li></div>
                         else if ($Tab/term/attribute() eq "periods") then
                            if(page:checkDateRange($ThiTab/term/data(.)) != fn:false()) then 
                                <div class="ThiNavTab_div"><a href="{$helpers:app-root}/periods/{$ThiTab/term/data(.)}"><li class="ThiNavTab">{$ThiTab/term/data(.)}</li></a></div> 
                            else <div class="EmptyTab inset"><li class="ThiNavTab">{$ThiTab/term/data(.)}</li></div>
                         else 
                                <div class="ThiNavTab_div"><a href="{$helpers:app-root}/genre/{$ThiTab/term/attribute()}"><li class="ThiNavTab">{$ThiTab/term/data(.)}</li></a></div> 

                    }</ul></div>}
                                </div>
                    else if(exists($SecTab/term[@type="line"])) then <div class="NavLine"></div>
                    else if(exists($SecTab/term[@type="headline"])) then <div class="SubNavTab_head emboss"><li class="SubNavTab">{$SecTab/term/data(.)}</li>  </div>
                     else if(exists($SecTab/term[@xml:id="individual_period"])) then 
                            <div class=" emboss" id="div1_period"><li class="SubNavTab" id="individual_period">{$SecTab/term/data(.)}</li>
                                <div class="emboss" id="div_period">
                                    <ul class="SubNavList" id="ul_period">
                                     <li class="" id="li_period">
                                        <form action="{$helpers:app-root}/period" method="post" id="PeriodForm">
                                            <label for="from" class="per_label">From</label>
                                            <input  type="number" name="per_from"  class="per_custom_input" id="per_from"  value="1150"/>
                                            <label for="to" class="per_label">To</label>
                                            <input  type="number" name="per_to" class="per_custom_input" id="per_to" value="1699"/>
                                            <input type="submit"  value="GO"/>
                                        </form>
                                     </li>
                                    </ul>
                                </div>
                            </div>
                     else if(exists($SecTab/term[@xml:id]) and $Tab/term/attribute()/data(.) != "denominations" and $Tab/term/attribute()/data(.) != "authors") then 
                 (:    let $param := if($Tab/term[@xml:id] = "denominations") then "denom" else "genre" :)
                        if(page:checkData( "genre",$SecTab/term/attribute()) = fn:true() ) then  
                        <div class="SubNavTab_div emboss"><a href="{$helpers:app-root}/genre/{$SecTab/term/attribute()}"><li class="SubNavTab">{$SecTab/term/data(.)}</li></a>  </div>
                        else <div class="EmptyTab inset"><li class="SubNavTab">{$SecTab/term/data(.)}</li></div>
                     else if(exists($SecTab/term[@xml:id]) and $Tab/term/attribute()/data(.) = "denominations" ) then
                                             <div class="SubNavTab_div emboss"><a href="{$helpers:app-root}/denom/{$SecTab/term/attribute()}"><li class="SubNavTab">{$SecTab/term/data(.)}</li></a>  </div>
                    else if( exists($SecTab/term[@xml:id]) and $Tab/term/attribute()/data(.) = "authors" ) then (
                                             <div class="ListTab emboss"><li class="SubNavTab_List" id="">{$SecTab/term/data(.)}</li><div class="SubNavList_div emboss">
                                             <ul class="SubNavList">{
                                      
                                      
                                      for $abc in helpers:lettersOfTheAlphabeHight()
                                             return if( page:PrintAuthors(substring-after($SecTab/term/attribute(),"_"),$abc) != "" ) then 
                                             <div class="ThiNavTab_div emboss authors ListTab"><li class="ThiNavTab_List BFont">{$abc}</li>
                                             <div class="ThiNavList_div">
                                                <ul class="ThiNavList">
                                                {
                                                    for $item in page:PrintAuthors(substring-after($SecTab/term/attribute(),"_"),$abc)
                                                  return  <div class="QuadNavTab_div"><a href="#"><li>{$item}</li></a></div>
                                                }
                                                </ul>
                                             </div>
                                             </div>
                                             
                                             else ()
                                              (:   page:PrintAuthors(substring-after($SecTab/term/attribute(),"_"),$abc):)
                                                }</ul>
                                             </div></div>
                        )
                     
                     else ()   
                    )
                    }</ul></div> 

                    else ()
           )}</div>)
           }</ul>

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
                                <input  type="number" name="dat_from"  class="adv_custom_input" id="from"  />
                                <label for="to">To</label>
                                <input  type="number" name="dat_to" class="adv_custom_input" id="to" />
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
    search:Search_Authors-Translator_StWi($type,$abc)//coerp:author/data(.)
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

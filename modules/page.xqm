xquery version "3.0";

module namespace page="http://localhost:8080/exist/apps/coerp_new/page";

import module namespace helpers="http://localhost:8080/exist/apps/coerp_new/helpers" at "helpers.xqm";
import module namespace corpus="http://localhost:8080/exist/apps/coerp_new/corpus" at "corpus.xqm";


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
                    <div id="searchDiv">
                        <input id="search" type="search" placeholder="Search ..." />
                        <div id="search_adDiv" class="searchButtons">Advanced Search</div>
                    </div>
                    <div id="searchButton" class="searchButtons ">
                        <a href="#" class="glyphicon glyphicon-search " id="search_icon" ></a>
                    </div>
                    {page:createAdvSearch()}
                </div>
           else if ( $Tab/term/attribute() = "genres") then 
                    (
                                <div class="MainNavTab emboss"> <li class="HeadTab" id="Tab_{$Tab/term/data(.)}">{$Tab/term/data(.)}</li></div>,
                           (
                           <div class="SecNavTab"><ul id="List_genres" class="MainNavList"> {(
                                 for $item in page:analyzedGenres() return
                                 <div class="SubNavTab_div emboss {$item/@list/data(.)}" id="{$item/@type/data(.)}"><a href="{$helpers:app-root}/genre/{$item/@att/data(.)}"><li class="SubNavTab">{$item/@dat/data(.)}</li></a></div>
                                 
                                 (:
                                 if($Item/@list/data(.) = "none") then
                                    <div class="SubNavTab_div">
                                    <li>{$item/@dat/data(.)}</li>
                                    </div>
                                 else 
                                    let $list := $item/@list/data(.) 
                                    <div class="ListTab emboss"><li class="SubNavTab_List">{$list}</li> {
                                    <div class="SubNavList_div emboss"><ul class="" id=""> {
                                    for $select in contains(page:analyzedGenres()/@key/data(.),$list) return
                                        
                                 
                                        }</div>   :)
                               
                               )}
                                </ul></div> )
                     )         

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
                          else 
                                <div class="ThiNavTab_div"><a href="{$helpers:app-root}/genre/{$ThiTab/term/attribute()}"><li class="ThiNavTab">{$ThiTab/term/data(.)}</li></a></div> 

                    }</ul></div>}
                                </div>
                    else if(exists($SecTab/term[@type="line"])) then <div class="NavLine"></div>
                    else if(exists($SecTab/term[@type="headline"])) then <div class="SubNavTab_head emboss"><li class="SubNavTab">{$SecTab/term/data(.)}</li>  </div>
                     else if(exists($SecTab/term[@xml:id]) and $Tab/term/attribute()/data(.) != "denominations" ) then 
                 (:    let $param := if($Tab/term[@xml:id] = "denominations") then "denom" else "genre" :)
                        if(page:checkData( "genre",$SecTab/term/attribute()) = fn:true() ) then  
                        <div class="SubNavTab_div emboss"><a href="{$helpers:app-root}/genre/{$SecTab/term/attribute()}"><li class="SubNavTab">{$SecTab/term/data(.)}</li></a>  </div>
                        else <div class="EmptyTab inset"><li class="SubNavTab">{$SecTab/term/data(.)}</li></div>
                     else if(exists($SecTab/term[@xml:id]) and $Tab/term/attribute()/data(.) = "denominations" ) then
                                             <div class="SubNavTab_div emboss"><a href="{$helpers:app-root}/denom/{$SecTab/term/attribute()}"><li class="SubNavTab">{$SecTab/term/data(.)}</li></a>  </div>
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

declare function page:createAdvSearch() as node() {
    let $code := <div class="adv_search">
                   <div class="adv_types">
                       <div class="adv_types_tab" id="tab_periods">Periods</div>
                       <div class="adv_types_tab" id="tab_genres">Genres</div>
                       <div class="adv_types_tab" id="tab_denominations">Denominations</div>
                   </div>
                   <div class="adv_fields_div">
                   <div class="adv_fields" id="adv_periods">
                       <div class="adv_fields_tab">
                                <form oninput="start.value=parseInt(a.value), end.value=parseInt(b.value)"> 
                             <input type="range" id="a" value="1150" min="1150" max="1699" /> 
                            <output name="start" for="a">1150</output> 
                                    <output name="end" for="b">1699</output> 
                                     <input type="range" id="b" value="1699" min="1150" max="1699" /> 
                                </form>
                       </div>
                   </div>
                   <div class="adv_fields" id="adv_genres">
                       <div class="adv_fields_tab">
                           <h4>core</h4>
                           <form>
                               <ul>
                               <li><input type="checkbox" name="prayer" value="prayer" id="prayer" /> <label for="prayer">Prayer</label>
                               </li><li><input type="checkbox" name="sermon" value="sermon" id="sermon" /> <label for="sermon">Sermon</label>
                               </li><li><input type="checkbox" name="treatise" value="treatise" id="treatise" /> <label for="treatise">Treatise</label>
                               </li><li><input type="checkbox" name="treatise_controversial" value="treatise_controversial" id="treatise_controversial" /> <label for="treatise_controversial">Controversial Treatise</label>
                               </li><li><input type="checkbox" name="catechism" value="catechism" id="catechism" /> <label for="catechism">Catechism</label>
                               </li><li><input type="checkbox" name="catechism_mimetic" value="catechism_mimetic" id="catechism_mimetic" /> <label for="catechism_mimetic">Mimetic Catechism</label>
                               </li> </ul>
                           </form>
                       </div>
                       <div class="adv_fields_tab">
                           <h4>minor</h4>
                           <form>
                               <ul>
                               <li><input type="checkbox" name="religious_biography" value="religious_biography" id="religious_biography" /> <label for="religious_biography">Religious Biography</label>
                               </li>
                               </ul>
                           </form>
                       </div>
                   </div>
                   <div class="adv_fields" id="adv_denominations">
                       <div class="adv_fields_tab">
                           <form>
                               <ul>
                               <li><input type="checkbox" name="anglican" value="anglican" id="anglican"/> <label for="anglican">Anglican</label>
                               </li><li><input type="checkbox" name="catohlic" value="catohlic" id="catohlic"/> <label for="catohlic">Catholic</label>
                               </li><li> <input type="checkbox" name="nonconformist" value="nonconformist" id="nonconformist"/> <label for="nonconformist">Nonoconformist</label>
                               </li><li><input type="checkbox" name="unknown" value="unknown" id="unknown"/> <label for="unknown">Unknown</label>
                               </li></ul>
                           </form>
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


(:
if(exists($SecTab/list/tab)) then <div> {
                        for $ThiTab in $SeciTab/list/tab return  
                     <div>{$ThiTab/term/data(.)}</div> }</div>
                     else ()
                   }
                   ) 
:)
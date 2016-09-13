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
declare namespace tei="http://www.tei-c.org/ns/1.0";



declare function page:createNavigation ($node as node(), $model as map(*)) {
    let $list := doc("/db/apps/coerp_new/data/lists.xml")/lists/list
    let $hierarchies := for $hit in $list/tab where $hit/term/@xml:id/data(.) eq "hierarchies" 
                                        return page:createNavigationsItems($hit,"genre-subtype")
    let $sets := for $hit in $list/tab where $hit/term/@xml:id/data(.) eq "sets" 
                                        return page:createNavigationsItems($hit,"genre-subtype")
     
     let $genres := page:findGenres()
     
     let $periods := for $hit in $list/tab where $hit/term/@xml:id/data(.) eq "periods" 
                                        return page:createNavigationsItems($hit,"periods")
                                           
     let $denom := for $hit in $list/tab where $hit/term/@xml:id/data(.) eq "denominations" 
                                        return page:createNavigationsItems($hit,"denom")
                                        
     let $authors := page:findAuthors()
                                        
    return map {
        "hierarchies" := $hierarchies,
        "sets" := $sets,
        "genres" := $genres,
        "periods" := $periods,
        "denom" := $denom,
        "authors" := $authors
    }
};




declare function page:createNavigationsItems($hit,$ref as xs:string) {
    for $tab in $hit/list/tab                                                
                                            return   if(exists($tab/list)) then 
                                            <item title="{$tab/term/data(.)}" type="{$tab/term/@type}" id="{$tab/term/@xml:id}">
                                                    {
                                                    for $item in $tab/list/tab                                                         
                                                        return  if($item/term/@type eq "period") then 
                                                                        <item title="{$item/term/data(.)}" type="{$item/term/@type}" 
                                                                                from="{$item/term/@from}" to="{$item/term/@to}" 
                                                                                check="{page:checkPeriods($item/term/@from,$item/term/@to)}"
                                                                                id="{$item/term/data(.)}"
                                                                                ref="{$ref}"
                                                                            />
                                                        else <item title="{$item/term/data(.)}" 
                                                                            type="{$item/term/@type}" 
                                                                            id="{$item/term/@xml:id}" 
                                                                            ref="{$ref}"
                                                                            check="{page:checkEntry($ref,$item/term/@xml:id)}"/>
                                                    }
                                                </item>
                                                else <item title="{$tab/term/data(.)}" type="{$tab/term/@type}" id="{$tab/term/@xml:id}" ref="{$ref}"/>
};
declare function page:printNavigations($node as node(), $model as map(*), $get as xs:string) {    
    page:CaseNavigation($model($get))
        
};

declare function page:CaseNavigation($item) {
switch($item/@type/data(.))
        case "title" return (:<div class="NAV_title"><a href="{$helpers:app-root}/{$item/@ref/data(.)}/{$item/@id/data(.)}">{$item/@title/data(.)}</a></div>:)
        (
                                        if($item/@check eq "true") then <div class="NAV_title" id="{$item/@ref/data(.)}">
                                                <a href="{$helpers:app-root}/{$item/@ref/data(.)}/{$item/@id/data(.)}">{$item/@title/data(.)}</a>
                                            </div>
                                        else <div class="NAV_none" id="{$item/@ref/data(.)}">{$item/@title/data(.)}</div>
                                        )
        
        case "headline" return <div class="NAV_headline">{$item/@title/data(.)}</div>
        case "line" return <div class="NAV_line"/>
        case "list" return (<div class="NAV_LIST_tab">{$item/@title/data(.)}</div>,
                                        <div class="NAV_LIST_list {$item/@id/data(.)} PageBorders-none-left">
                                            <ul>
                                                {for $hit in $item/item return <li>{page:CaseNavigation($hit)}</li>}
                                            </ul>
                                      </div>)
        case "genre_list" return <div class="NAV_title" id="{$item/@id/data(.)}"><a href="{$helpers:app-root}/{$item/@ref/data(.)}/{$item/@id/data(.)}">{$item/@title/data(.)}</a></div>
        case "author_list" return (<div class="NAV_LIST_SEC_tab PageBorders-none-left">{$item/@title/data(.)}</div>,
                                        <div class="NAV_LIST_SEC_list PageBorders-none-left">
                                            <ul>
                                                {for $hit in $item/item return <li>{page:CaseNavigation($hit)}</li>}
                                            </ul>
                                      </div>)
        case "period" return (
                                        if($item/@check eq "true") then <div class="NAV_title" id="{$item/@ref/data(.)}">
                                                <a href="{$helpers:app-root}/{$item/@ref/data(.)}/{$item/@id/data(.)}">{$item/@title/data(.)}</a>
                                            </div>
                                        else <div class="NAV_none" id="{$item/@ref/data(.)}">{$item/@title/data(.)}</div>
                                        )
        default return $item
};

declare function page:findGenres(){
    let $genres := for $hit in collection("/db/apps/coerp_new/data/texts")//tei:sourceDesc/tei:bibl/tei:note               
                                    where $hit/@type eq "genre"
                                return <item title="{$hit/data(.)}" ref="{$hit/@subtype/data(.)}" />
    
    let $simple := for $hit in $genres return $genres/@ref/data(.)
    let $simple := distinct-values($simple)
    let $simple := for $hit in $simple 
                                let $title := for $genre in $genres where $hit eq $genre/@ref return $genre/@title/data(.)
                                let $title := distinct-values($title)
                                return <item id="{$hit}" type="genre_list" title="{$title}" ref="genre"/>
   
    return $simple
};
 
 declare function page:checkPeriods($from as xs:string, $to as xs:string) {
        if(count(search:range-date(collection("/db/apps/coerp_new/data/texts"),$from,$to,"date")) > 1) then "true"
        else "false"      
 };
 
 declare function page:checkEntry($param,$term) {
    if(count(corpus:scanDB(collection("/db/apps/coerp_new/data/texts"),$param,$term) ) > 1) then "true"
        else "false"
 };
 
 declare function page:findAuthors() {
    let $db := collection("/db/apps/coerp_new/data/texts")
    let $authors := for $hit in $db//tei:author[@role = "author"]/data(.)                                
                            return <item key="{substring($hit,1,1)}" title="{$hit}" />
    let $translators := for $hit in $db//tei:author[@role = "translator"]/data(.)
                            return <item key="{substring($hit,1,1)}" title="{$hit}" />
    
    let $s_author := for $hit in $authors/@key return $hit
    let $s_author := distinct-values($s_author)
    let $s_translator := for $hit in $translators/@key return $hit
    let $s_translator := distinct-values($s_translator)
    
    let $authors := for $hit in $s_author 
                                let $title := for $author in $authors where $hit eq $author/@key return $author/@title/data(.)
                                let $title := distinct-values($title)
                                order by $hit
                                return <item key="{$hit}" type="author_list" title="{$hit}">
                                            {for $name in $title order by $name return <item key="{$hit}" title="{$name}" type="title" ref="author" id="{$name}" check="true"/>}
                                            </item>
     let $translators := for $hit in $s_translator 
                                let $title := for $translator in $translators where $hit eq $translator/@key return $translator/@title/data(.)
                                let $title := distinct-values($title)
                                order by $hit
                                return <item key="{$hit}" type="author_list" title="{$hit}">
                                            {for $name in $title order by $name return <item key="{$hit}" title="{$name}" type="title" ref="translator" id="{$name}" check="true"/>}
                                            </item>                           
    
    let $authors := <item title="Authors" type="list">{$authors}</item>
    let $translators := <item title="Translators" type="list">{$translators}</item>
    return ($authors,$translators)
 
 };
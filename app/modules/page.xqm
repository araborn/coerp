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
                                        return page:createNavigationsItems($hit,"genre")
    let $sets := for $hit in $list/tab where $hit/term/@xml:id/data(.) eq "sets" 
                                        return page:createNavigationsItems($hit,"genre")
     
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
        case "title" return 
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
        case "ref" return (
                    let $radius := for $doc in collection("/db/apps/coerp_new/data/texts")//tei:bibl where $doc/tei:date[@type ="this_edition"] order by $doc/tei:date[@type ="this_edition"]/@when  return $doc/tei:date/@when
                    let $start := $radius[1]
                    let $end := $radius[count($radius)]
                    return
                    (<div class=" NAV_LIST_tab">{$item/@title/data(.)}</div>,
                                <div class="NAV_LIST_list PageBorders-none-left" id="indi_period">
                                        <form action="{$helpers:app-root}/periods" method="post" id="PeriodForm">
                                            <span>
                                                <label for="per_from" class="per_label">From</label>
                                                <input  type="number" name="per_from"  class="per_custom_input" id="per_from"  value="{$start}" min="{$start}" max="{$end}"/>
                                            </span>
                                            <span>
                                                <label for="per_to" class="per_label">To</label>
                                                <input  type="number" name="per_to" class="per_custom_input" id="per_to" value="{$end}" min="{$start}" max="{$end}"/>
                                            </span>
                                        </form>
                                        <div id="periodButton" class="searchButtons ">
                                            <i  class="glyphicon glyphicon-search " id="search_icon" ></i>
                                        </div>
                                        <script>
                                        $("#periodButton").click(function() {{
                                            var date = $("#per_from").val()+"-"+$("#per_to").val();
                                             window.location.href = "{$helpers:app-root}/periods/"+date;
                                    }});</script>
                                </div>)
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
    let $authorlist := doc("/db/apps/coerp_new/authors.xml")
    let $authors := for $hit in $db//tei:author[@role = "author"]/@key/data(.)          
                                let $authorL := $authorlist//author[@key = "hit"]
                                let $authorname := $authorL/orig/data(.)
                            return <item key="{substring($authorname,1,1)}" title="{$hit}" />
    let $translators := for $hit in $db//tei:author[@role = "translator"]/@key/data(.)
                                let $authorL := $authorlist//author[@key = "hit"]
                                let $authorname := $authorL/orig/data(.)
                            return <item key="{substring($authorname,1,1)}" title="{$hit}" />
    
    
    
    let $s_author := for $hit in $authors/@key return $hit
    let $s_author := distinct-values($s_author)
    let $s_translator := for $hit in $translators/@key return $hit
    let $s_translator := distinct-values($s_translator)
    
    let $authors := for $hit in $s_author 
                                let $title := for $author in $authors where $hit eq $author/@key return $author/@title/data(.)
                                let $title := distinct-values($title)
                                order by $hit
                                return <item key="{$hit}" type="author_list" title="{$hit}">
                                            {for $name in $title order by $name return <item key="{$hit}" title="{$authorlist//author[@key = $name]/orig/data(.)}" type="title" ref="author" id="{$name}" check="true"/>}
                                            </item>
     let $translators := for $hit in $s_translator 
                                let $title := for $translator in $translators where $hit eq $translator/@key return $translator/@title/data(.)
                                let $title := distinct-values($title)
                                order by $hit
                                return <item key="{$hit}" type="author_list" title="{$hit}">
                                            {for $name in $title order by $name return <item key="{$hit}" title="{$authorlist//author[@key = $name]/orig/data(.)}" type="title" ref="translator" id="{$name}" check="true"/>}
                                            </item>                           
    
    let $authors := <item title="Authors" type="list">{$authors}</item>
    let $translators := <item title="Translators" type="list">{$translators}</item>
    return ($authors,$translators)
 
 };
xquery version "3.0";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://localhost:8080/exist/apps/coerp_new/config" at "modules/config.xqm";
import module namespace helpers="http://localhost:8080/exist/apps/coerp_new/helpers" at "modules/helpers.xqm";
declare namespace request="http://exist-db.org/xquery/request";
import module namespace search="http://localhost:8080/exist/apps/coerp_new/search" at "modules/search.xqm";
import module namespace corpus="http://localhost:8080/exist/apps/coerp_new/corpus" at "modules/corpus.xqm";

(:
import module namespace register="http://localhost:8080/exist/apps/coerp_new/register" at "modules/registration.xqm";
:)
declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;



(:
Diese Funktion leitet auf die login-Seite weiter und merkt sich den angeforderten Pfad, 
um den Benutzer nach erfolgreichem login direkt auf diese Seite weiterzuleiten :)

  (:

declare function local:redirect-login() {
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
		<redirect url="{$helpers:rootPath}/login.html?originalPath={$exist:path}"> 
			{
				if (not(request:get-parameter('originalPath',()))) then
					<add-parameter name="originalPath" value="{$exist:path}" />
				else()
			}
		</redirect>
	</dispatch>
};

declare function local:redirect-login-search() {
    	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
		<redirect url="{$helpers:rootPath}/login.html?originalPath=/index.html"> 
		</redirect>
	</dispatch>  
};


declare function local:user-logged-in() as xs:boolean {
    if (xmldb:get-user-groups(xmldb:get-current-user()) = ("coerp")) then true() else false()
};

declare function local:login($email as xs:string, $password as xs:string) as xs:boolean {
        if (xmldb:login( "/db", $email, $password, true())) then true()          
        else false()
};

declare function local:login-failed($email as xs:string, $password as xs:string) {    
    if(register:check-if-email-exists($email) and (not(system:as-user($config:admin-id, $config:admin-pass, (sm:is-account-enabled($email)))))) then
            <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
                <redirect url="{$helpers:rootPath}/account-disabled.html"/>
            </dispatch>
     else  
            <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
               <redirect url="{$helpers:rootPath}/login-failed.html"/>
            </dispatch>
};

declare function local:redirect-dynamic($originalPath as xs:string) {
    if(not($originalPath eq "")) then
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
		  <redirect url="{$helpers:rootPath}/{$originalPath}"/>
	   </dispatch>
    else 
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <redirect url="{$helpers:rootPath}/logged-in.html"/>
        </dispatch>
};
:)
(:
    SEKTION 1: Seiten, die für alle zugänglich sind
    - index
    - login
    - about
    - impressum
:)

if ($exist:path eq "/") then
    (: forward root path to index.xql :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.html" />
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="index" value="index" />           
            </forward>
        </view>
    </dispatch>
else if (ends-with($exist:resource, "index.html")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.html" />
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="index" value="index" />           
            </forward>
        </view>
    </dispatch>  
    
    else if (contains($exist:path , "genre")) then
         let $term := substring-after($exist:path,"genre/")
         let $ordertype := if (contains($term,"/")) then substring-after($term,"/") else "date" 
         let $term := if (contains($term,"/")) then substring-before($term,"/") else $term 

     return
      (
    session:set-attribute("param","genre-subtype"),
    session:set-attribute("term",$term),
    session:set-attribute("orderBy",$ordertype),
    session:set-attribute("type","genre"),
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/page/list.html" />
        <set-attribute name="param" value="genre-subtype"/>
        <set-attribute name="term" value="{$term}"/>
        <set-attribute name="orderBy" value="{$ordertype}"/>
        <set-attribute name="type" value="genre"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
            </forward>
        </view>
    </dispatch> 
    )
    else if (contains($exist:path , "denom")) then
        let $term := substring-after($exist:path,"denom/")
         let $ordertype := if (contains($term,"/")) then substring-after($term,"/") else "date" 
         let $term := if (contains($term,"/")) then substring-before($term,"/") else $term 
     return
      (
    session:set-attribute("param","denom"),
    session:set-attribute("term",$term),
    session:set-attribute("orderBy",$ordertype),
    session:set-attribute("type","denom"),
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/page/list.html" />
        <set-attribute name="param" value="denom"/>
        <set-attribute name="term" value="{$term}"/>
        <set-attribute name="orderBy" value="{$ordertype}"/>
        <set-attribute name="type" value="denom"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
            </forward>
        </view>
    </dispatch> 
    )
    else if(contains($exist:path,"periods")) then 
         let $term := substring-after($exist:path,"periods/")
         let $ordertype := if (contains($term,"/")) then substring-after($term,"/") else "date" 
         let $term := if (contains($term,"/")) then substring-before($term,"/") else $term 
         return
      (
    session:set-attribute("param","date"),
    session:set-attribute("term",$term),
    session:set-attribute("orderBy",$ordertype),
    session:set-attribute("type","periods"),
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/page/list.html" />
        <set-attribute name="param" value="periods"/>
        <set-attribute name="term" value="{$term}"/>
        <set-attribute name="orderBy" value="{$ordertype}"/>
        <set-attribute name="type" value="periods"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
            </forward>
        </view>
    </dispatch> 
    )
     else if (contains($exist:path,"author") or contains($exist:path,"translator")) then     
     let $type := if (contains($exist:path,"author")) then "author" else "translator"
     let $term := substring-after($exist:path,concat($type,"/"))
     let $ordertype := if(contains($term,"/")) then substring-after($term,"/") else "date"
     let $term := if (contains($term,"/")) then substring-before($term,"/") else $term      
     let $term := ($term,$type)
     let $param := ("person_key","role")

     return
      (
    session:set-attribute("param", $param),
     session:set-attribute("term",$term),
    session:set-attribute("orderBy",$ordertype),
    session:set-attribute("type",$type),
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/page/list.html" />
            <set-attribute name="param" value="{$param}"/>
            <set-attribute name="term" value="{$term}"/>
            <set-attribute name="orderBy" value="{$ordertype}"/>
            <set-attribute name="type" value="{$type}"/>
            <view>
            <forward url="{$exist:controller}/modules/view.xql">
            </forward>
        </view>
    </dispatch> 
    )
    else if (contains($exist:path, "text")) then
    (
        let $xml := $exist:resource
        return (
        session:set-attribute("xml",$xml),
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/page/texts.html" />
        <set-attribute name="xml" value="{$xml}"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
            </forward>
        </view>
    </dispatch> 
        )
    (:
        let $text := if($exist:resource != "xml") then search:FindDocument($exist:resource) else search:FindDocument(substring-after( substring-before($exist:path,"/xml"),"text/"))
        return if($exist:resource = "xml") then 
        
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/data/texts/{$text}"/>
        </dispatch>
        else 
        (
        session:set-attribute("text",$text ),
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/page/texts.html" />
    <set-attribute name="text" value="{$text}"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
            <set-attribute name="textView" value="true" />
            </forward>
        </view>
    </dispatch> ):)
    )
    else if(contains($exist:resource,".html") and not(contains($exist:resource,"index"))) then 
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/page/{$exist:resource}" />
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
            </forward>
        </view>
    </dispatch> 
    else if ($exist:resource eq "search") then 
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/page/{$exist:resource}.html" />
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
            </forward>
        </view>
    </dispatch> 
    (:
else if (ends-with($exist:resource, "login.html")) then
        let $post := request:get-data()
        let $username := request:get-parameter('email',"")
        let $password := request:get-parameter('password',"")
        let $originalPath := request:get-parameter('originalPath', "")
        return
    if (request:get-method() eq "POST") then
        if(local:login($username, $password)) then
            local:redirect-dynamic($originalPath)
        else 
            local:login-failed($username, $password)
     else
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/page/login.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
        <error-handler>
            <forward url="{$exist:controller}/error-page.html" method="get"/>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>

else if (ends-with($exist:resource, "about.html")) then

    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/about.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="about" value="about" />  
            </forward>
        </view>
        <error-handler>
            <forward url="{$exist:controller}/error-page.html" method="get"/>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>    
    
else if (ends-with($exist:resource, "impressum.html")) then

    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/impressum.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="impressum" value="impressum" />           
            </forward>
        </view>
        <error-handler>
            <forward url="{$exist:controller}/error-page.html" method="get"/>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
    
else if (ends-with($exist:resource, "forgotPassword.html")) then

    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/forgotPassword.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="forgotPassword" value="forgotPassword" />           
            </forward>
        </view>
        <error-handler>
            <forward url="{$exist:controller}/error-page.html" method="get"/>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
    
else if (ends-with($exist:resource, "register.html")) then

    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/register.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="register" value="register" />           
            </forward>
        </view>
        <error-handler>
            <forward url="{$exist:controller}/error-page.html" method="get"/>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
    
else if (ends-with($exist:resource, "resetPassword.html")) then

    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/resetPassword.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="resetPassword" value="resetPassword" />           
            </forward>
        </view>
        <error-handler>
            <forward url="{$exist:controller}/error-page.html" method="get"/>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>

else if (ends-with($exist:resource, "activate-account.html")) then

    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/activate-account.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="activate-account" value="activate-account" />           
            </forward>
        </view>
        <error-handler>
            <forward url="{$exist:controller}/error-page.html" method="get"/>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>

else if (ends-with($exist:resource, "login-failed.html")) then

    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/login-failed.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="login-failed" value="login-failed" />           
            </forward>
        </view>
        <error-handler>
            <forward url="{$exist:controller}/error-page.html" method="get"/>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
    
else if (ends-with($exist:resource, "account-disabled.html")) then

    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/account-disabled.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="account-disabled" value="account-disabled" />           
            </forward>
        </view>
        <error-handler>
            <forward url="{$exist:controller}/error-page.html" method="get"/>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
    
:)
(:

    SEKTION 2 
    Alle Seiten, für die ein Login benötigt wird

:)

(:
else if (starts-with($exist:path, "/genre/")) then
    if (local:user-logged-in()) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/dataset_index.html" />
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="resourceType" value="genre"/>
                <set-attribute name="genre" value="{$exist:resource}"/>
            </forward>
        </view>
    </dispatch>
    else local:redirect-login()
else if (starts-with($exist:path, "/period/")) then
    if (local:user-logged-in()) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/dataset_index.html" />
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="resourceType" value="period"/>
                <set-attribute name="period" value="{$exist:resource}"/>
            </forward>
        </view>
    </dispatch>
    else local:redirect-login()
else if (starts-with($exist:path, "/author/")) then
    if (local:user-logged-in()) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/dataset_index.html" />
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="resourceType" value="author"/>
                <set-attribute name="author" value="{$exist:resource}"/>
            </forward>
        </view>
    </dispatch>
    else local:redirect-login()
else if (starts-with($exist:path, "/denomination/")) then
    if (local:user-logged-in()) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/dataset_index.html" />
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="resourceType" value="denomination"/>
                <set-attribute name="denomination" value="{$exist:resource}"/>
            </forward>
        </view>
    </dispatch>
    else local:redirect-login()
else if (starts-with($exist:path, "/translator/")) then
    if (local:user-logged-in()) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/dataset_index.html" />
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="resourceType" value="translator"/>
                <set-attribute name="translator" value="{$exist:resource}"/>
            </forward>
        </view>
    </dispatch>
    else local:redirect-login()
else if (starts-with($exist:path, "/texts/")) then
    if (local:user-logged-in()) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/dataset.html" />
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="textView" value="true" />
            </forward>
        </view>
    </dispatch>
    else local:redirect-login()
else if (ends-with($exist:resource, "search.html")) then
    if (local:user-logged-in()) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/search.html" />
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="query" value="{request:get-parameter("query", "")}" />
                <set-attribute name="type" value="{request:get-parameter("type", "complex")}" />
                <set-attribute name="viewDatasetInfo" value="true"/>
            </forward>
        </view>
    </dispatch>
    else local:redirect-login-search()
else if (ends-with($exist:resource, ".html")) then
    if (local:user-logged-in()) then
    (: the html page is run through view.xql to expand templates :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
		<error-handler>
			<forward url="{$exist:controller}/error-page.html" method="get"/>
			<forward url="{$exist:controller}/modules/view.xql"/>
		</error-handler>
    </dispatch>
    else local:redirect-login()
:)
(:
    SEKTION 3
    Ressourcen (immer zugänglich)

:)

(: Resource paths starting with $shared are loaded from the shared-resources app :)
else if (contains($exist:path, "/$shared/")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="/shared-resources/{substring-after($exist:path, '/$shared/')}">
            <set-header name="Cache-Control" value="max-age=3600, must-revalidate"/>
        </forward>
    </dispatch>   
else
    (: everything else is passed through :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
    </dispatch>

xquery version "3.0";

module namespace search="http://localhost:8080/exist/apps/coerp_new/search";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://localhost:8080/exist/apps/coerp_new/config" at "config.xqm";

declare function search:Search_Authors-Translator_StWi($type as xs:string, $letter as xs:string) {
    
         let $db := collection("/db/apps/coerp_new/data/texts")
        let $range := concat("//range:field-starts-with(('",$type,"'),'",$letter,"')")
         let $build := concat("$db",$range)
        return util:eval($build)
};
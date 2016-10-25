

$(document).ready(function() {
    /*#Manage Elements#*/
    $("span.ct-header").click(function() {
        $(this).next().toggleClass("ct-visible");
    });
    
    /*##Manage Visibility#*/
    $("td.ct-button").click(function() {/*First Line*/    
        $("."+$(this).attr("id")).each(function() {
            $(this).toggleClass("ct-high");  
        });
        $(this).toggleClass("ct-high");        
    })    
});


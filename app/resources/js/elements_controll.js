

$(document).ready(function() {
    $("td.ct-button").click(function() {/*First Line*/    
        $("."+$(this).attr("id")).each(function() {
            $(this).toggleClass("ct-high");  
        });
        $(this).toggleClass("ct-high");
        
    })
});
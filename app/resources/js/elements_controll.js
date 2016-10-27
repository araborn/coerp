

$(document).ready(function() {
    /*#Manage Elements#*/
    $("span.ct-header").click(function() {
        $(this).next().toggleClass("ct-visible");
    });
    
    /*##Manage Visibility#*/
    $( ".ct-check" ).change(function() {
        $("."+$(this).parent().parent().parent().attr("id")).each(function() {
            $(this).toggleClass("ct-high");  
        });
        $(this).next("span").toggleClass("ct-high");   
    });
    
    
    $(".glyphicon-step-backward").click(function() {
        
        
    });
    
    $(".glyphicon-step-forward").click(function() {
        var posi =   $("."+$(this).parent().parent().attr("id")).position();
        var elem = document.elementFromPoint(posi.left,posi.top);
        $.scrollTo({left:posi.left, top:posi.top},400);
        alert(elem.id);
    });
});


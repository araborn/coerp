

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
            getCords($(this).parent().parent().attr("id"),$(this));
    });
    
    $(".glyphicon-step-forward").click(function() {
        getCords($(this).parent().parent().attr("id"),$(this));
    });
    
    $(".ct-bar").click(function() {
        toggleExtBars($(this).attr("resource"));
        /*if( $(this).children("i").hasClass("glyphicon-menu-right")) {
            $(this).children("i").removeClass("glyphicon-menu-right");
            $(this).children("i").addClass("glyphicon-menu-left");
        }
        else {        
            $(this).children("i").removeClass("glyphicon-menu-left");
            $(this).children("i").addClass("glyphicon-menu-right");
        }*/
    });
    $(".he-bar").click(function() {
        toggleExtBars($(this).attr("resource"));
    });

    
    /* Profile Buttons */
    
    $(".he-profile").click(function() {
        $("#he-"+$(this).attr("resource")+"-content").toggle("blind","slow");
        if( $(this).children("i").hasClass("glyphicon-menu-down")) {
            $(this).children("i").removeClass("glyphicon-menu-down");
            $(this).children("i").addClass("glyphicon-menu-up");
        }
        else {        
            $(this).children("i").removeClass("glyphicon-menu-up");
            $(this).children("i").addClass("glyphicon-menu-down");
        }
        });
    
});



function toggleExtBars(elem) {
        $("#ct-"+elem+"-w").toggle("slide","slow");
        if(elem == "downloads") {
            if($("#ct-annotations-w").css("display") == "block") {
                $("#ct-annotations-w").toggle("slide","slow");
            }
        }
        
        if(elem == "annotations") {
            if($("#ct-downloads-w").css("display") == "block") {
                $("#ct-downloads-w").toggle("slide","slow");
            }
        }
        };


function getCords(id, direction) {
    var 
        backward = $("#"+id).children("td").children(".glyphicon-step-backward" ),
        forward = $("#"+id).children("td").children(".glyphicon-step-forward" ),
        poB = parseInt(backward.attr("pos")),
        poF = parseInt(forward.attr("pos")),
        pos;
    
        if(direction.hasClass("glyphicon-step-backward")) {            
            if(poB != 0) poB--;
            if(poB == 0) {
                 for(var i = 1; $('#'+id+'_'+i).index() != -1; i++) {
                    poB = i;
                }
                backward.attr("pos",poB);
                poB--;
            }
            poF = poB + 2;
        }
        
        if (direction.hasClass("glyphicon-step-forward")) {
            poF++;
            poB = poF - 2;
        }
        
        jumpTo(id,direction.attr("pos"));
        
        if(  $('#'+id+'_'+poF).index() == -1) {poF = 1;}
        
        if(poB == 0) {
            for(var i = 1; $('#'+id+'_'+i).index() != -1; i++) {
                poB = i;
            }
        }                
        
        
        forward.attr("pos",poF);
        backward.attr("pos",poB);

};




function jumpTo(id,pos) {
    $(".ct-scroll").removeClass("ct-scroll");
    $("#"+id+"_"+pos).addClass("ct-scroll");
    var posi = $("#"+id+"_"+pos).position();
    $.scrollTo({left:posi.left, top:posi.top},400);
}

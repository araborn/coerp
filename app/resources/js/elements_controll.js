

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
    
    $("#ct-annotations-b").click(function() {
        toggleExtBars("ct-annotations-w");
    });
    $("#ct-downloads-b").click(function() {
         toggleExtBars("ct-downloads-w");        
    });
    
});


function toggleExtBars(elem) {
        $("#"+elem).toggle("slide","slow");
        if(elem == "ct-downloads-w") {
            if($("#ct-annotations-w").css("display") == "block") {
                $("#ct-annotations-w").toggle("slide","slow");
            }
        }
        
        if(elem == "ct-annotations-w") {
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

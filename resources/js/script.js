

$(document).ready(function() { /* Navigations Funktion*/
  

    $("div.MainNavContent").click(function() {
       if(!$(this).hasClass("active")) { /*if 1 Start*/
            $("div.active div.SecNavTab").hide();
            $("div.MainNavContent.active").removeClass("active");
           $("div.MainNavTab.active").removeClass("active");
           $(this).addClass("active");
           $(this).children("div.MainNavTab").addClass("active")
           $(this).children("div.SecNavTab").show();
          /* var raw_id = $(this).children(" li.HeadTab").attr("id");
           var id = raw_id.substring(4);
           $("#List_"+id).show();*/
         /*  $(this).mouseleave(function(){ 
               $(this).removeClass("active");
               $(this).children("div.SecTab").removeClass("active");

               var raw_id = $(this).children(" li.HeadTab").attr("id");
               var id = raw_id.substring(4);
               $("#List_"+id).hide();
           });
         */
       }
       else {
            if($(this).find("li#individual_period").attr("id") == "individual_period") {
               
           }  
           else {
                $(this).removeClass("active");
                $(this).children("div.MainNavTab").removeClass("active")
                $(this).children("div.SecNavTab").hide();
           }
       }/*if 1 End*/
       
       $("div.ListTab").mouseover(function() {
        if(!$(this).hasClass("active")) { /*if 2 Start*/
            $(this).addClass("active");
            $(this).children("li").addClass("active");
      /*     
       *  $(this).children("li.SubNavTab_List").addClass("active");
       * 
            var raw_id= $(this).children("li.SubNavTab_List").attr("id");
            var id = raw_id.substring(4);
            */
            $(this).children("div").children("ul").show();
            $(this).children("div").children(" ul").css("display","inline-block");
             $(this).children("div").show();
            $(this).children("div").css("display","inline-block");
            
            /*$(this).children("div").children("ul#List_"+id).show();
            $(this).children("div").children(" ul#List_"+id).css("display","inline-block");
             $(this).children("div").show();
            $(this).children("div").css("display","inline-block");*/
            
              $(this).mouseleave(function(){ 
              $(this).removeClass("active");
              $(this).children("li").removeClass("active");
           
          /*
           *  $(this).children("li.SubNavTab_List").removeClass("active");
           * 
                var raw_id= $(this).children(" li.SubNavTab_List").attr("id");
               var id = raw_id.substring(4);
          */
          $(this).children("div").children("ul").hide();
               $(this).children("div").hide();
                });
                
          }/*if 2 End*/
          });
          
          
       /*
       $("div.NavMainTab li.HeadTab").mouseleave(function() {
            
           
       });*/
        
       
            
        
    });
    $("#individual_period").click(function() {
            $(this).next("div").toggle();
            $(this).next("div").children("ul").toggle();
            });
    $("#PeriodForm input").change( function() {
            if($(this).attr("id") == "per_from") {
            $("#per_to").attr("min",$(this).val());
            }
            else { 
            $("#per_from").attr("max",($(this).val()));
            }
    });
});

$(document).ready(function() { /* Advanced Search Funktion*/
/*        
        $(".adv_fields").hide();
        $(".adv_search").hide();*/
        $("div.adv_types_tab").click(function() {
            if(!$(this).hasClass("active")) {
                $("div.adv_fields.active").hide("blind","slow");
                $("div.adv_fields.active").removeClass("active");
                $("div.adv_types_tab.active").removeClass("active");
                $(this).addClass("active");
                var raw_id = $(this).attr("id");
                var id = raw_id.substring(4);
                $("#adv_"+id).addClass("active");
                $("#adv_"+id).show("blind","slow");
            }
            else {
                $(this).removeClass("active");
                var raw_id = $(this).attr("id");
                var id = raw_id.substring(4);
                $("#adv_"+id).removeClass("active");
                $("#adv_"+id).hide("blind","slow");
            }
        });
        
        $("div#search_adDiv").click(function() { 
                if(!$(this).hasClass("active")) {
                    $(this).addClass("active");
                    $(".adv_search").show("blind","slow");
                }
                else {
                    $(this).removeClass("active");
                    $(".adv_search").hide("blind","slow");
                }
        });
        
        /*###Range Slider Functions Start #####*/
     $( "#RangeSlider" ).slider({
      range: true,
      min: 1150,
      max: 1699,
      values: [ 1150, 1699 ],
      slide: function( event, ui ) {
        $( "#amount" ).val(ui.values[ 0 ] + " - " + ui.values[ 1 ]  );
        $("#from").val(ui.values[0]);
        $("#to").val(ui.values[1]);
        $("#from").attr("max",ui.values[1]);
        $("#to").attr("min",ui.values[0]);
      }
    });
    $( "#amount" ).val($( "#RangeSlider" ).slider( "values", 0 )+
      " - " + $( "#RangeSlider" ).slider( "values", 1 ));
            $("#from").val($( "#RangeSlider" ).slider( "values", 0 ));
            $("#to").val($( "#RangeSlider" ).slider( "values", 1 ));

        
        $(".adv_periods_buttons").click(function () {
            var id = $(this).attr("id").substring(11);
            $("#adv_"+id).toggle("blind");
            $(this).toggleClass("adv_selected");
            
        });
        $(".adv_presets").click(function () { 
            var from = $(this).attr("id").substring(0,4);
            var to = $(this).attr("id").substring(5,9);
            $( "#RangeSlider" ).slider("values",0,from);
            $( "#RangeSlider" ).slider("values",1,to);
            $("#from").val(from);
            $("#to").val(to);
            $( "#amount" ).val(from+" - " + to);
            
            if(!$(this).hasClass("pre_selected")) {
                $("span.adv_presets.pre_selected").removeClass("pre_selected");
                $(this).addClass("pre_selected");
            }
            
        });
        
        $("#adv_custom input").change( function() {
         
           if($(this).attr("id") == "from") {
               $( "#RangeSlider" ).slider("values",0, $(this).val());
               $( "#amount" ).val($(this).val()+" - " + $( "#RangeSlider" ).slider( "values", 1 ));
               $("#to").attr("min",$(this).val());
               
           }
           else {
               $( "#RangeSlider" ).slider("values",1, $(this).val());
               $( "#amount" ).val($( "#RangeSlider" ).slider( "values", 0 )+" - " +$(this).val());
               $("#from").attr("max",($(this).val()));
           }
           
        });
        
        /*###Range Slider Functions END####*/
        
        $("#searchButton").click(function() {
        $("form#SearchForm").submit();
        });
        
      
});

$(document).ready(function() { /* Genre Funktion*/
        
        $("ul#List_genres div.list").removeClass("SubNavTab_div emboss");
        var classes = new Array( $(".list").attr("id"));
         for (var a = 0; a <classes.length;a++) {
            $("ul#List_genres div#"+classes[a]).wrapAll("<div class='ListTab emboss' id='"+classes[a]+"'><div class='SubNavList_div emboss'><ul  class='SubNavList' id='List_"+classes[a]+"'></ul></div></div> " );
            $("ul#List_"+classes[a]+" div#"+classes[a]).removeClass("list");
            $("ul#List_"+classes[a]+" div#"+classes[a]).addClass("ThiNavTab_div emboss");
            $("ul#List_"+classes[a]+" div#"+classes[a]).children("li").removeClass("SubNavTab");
            $("ul#List_"+classes[a]+" div#"+classes[a]).children("li").addClass("ThiNavTab");
        }
        $("ul#List_genres div.ListTab").prepend("<li class='SubNavTab_List' id='Tab_"+$("ul#List_genres div.ListTab").attr("id")+"'>"+$("ul#List_genres div.ListTab").attr("id")+"</li>")
});



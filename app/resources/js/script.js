$(document).ready(function() { /* Navigations Funktion*/
    $("span.NAV_HEADER_tab").click(function() {/*First Line*/
        if(!$(this).hasClass("selected")) {
            HideMain();            
          $(this).addClass("selected");
          $(this).next("div.NAV_HEADER_list").addClass("active");
          $(this).next("div.NAV_HEADER_list").show();                   
        }
        else {
        HideMain();
        }       
    });
    
    $("div.NAV_LIST_tab").click(function() {/*Second Line*/
        if(!$(this).hasClass("selectedList")) {
            HideList()   
          $(this).addClass("selectedList");
          $(this).next("div.NAV_LIST_list").addClass("showList");
          $(this).next("div.NAV_LIST_list").show();                   
        }
        else {
            HideList()
        }       
    });
    
    $("div.NAV_LIST_SEC_tab").click(function() {/*Third Line*/
        if(!$(this).hasClass("selectedSecList")) {
            HideSecList()   
          $(this).addClass("selectedSecList");
          $(this).next("div.NAV_LIST_SEC_list").addClass("showSecList");
          $(this).next("div.NAV_LIST_SEC_list").show();                   
        }
        else {
            HideSecList()
        }       
    });

});


function HideMain() {
    $("div.active").hide();
    $("div.active").removeClass("active");
    $("span.selected").removeClass("selected");
    
}

function HideList() {
    $("div.selectedList").removeClass("selectedList");
    $("div.showList").hide();
    $("div.showList").removeClass("showList");
}

function HideSecList() {
    $("div.selectedSecList").removeClass("selectedSecList");
    $("div.showSecList").hide();
    $("div.showSecList").removeClass("showSecList");
}
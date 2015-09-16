
$(document).ready(function(){ 
    
    $("span#TextElementBar").click(function() {
        $("#highlightButtons").toggle("slide","slow");
    })
    
    $("div.TextTooltipButton").click(function() {
    $(this).next("div").toggle("blind","slow");
    })
    $("div#TextAnnotation").click(function() {
        $("#highlightButtons").toggle("slide","slow");
    })
});


/*##### Text Elemente ######*/

var textElementsMap = {
    
    'references': {
        'bible': {
            'name': 'Bible References',
            'func': 'showBibleReferences()'
        },
        'psalm': {
            'name': 'Psalmtext',
            'func': 'showPsalmReferences()'
        },
        'quotation': {
            'name': 'Quotations',
            'func': 'toggleHighlight(\'quotation\')'
        }
    },
    
    'language': {
        'foreign': {
            'name': 'Latin Text',
            'func': 'toggleHighlight(\'foreign\')'
        },
        
        'foreign_omitted': {
            'name': 'Foreign Omitted',
            'func': 'showForeign_omitted()'
        },
        'verse': {
            'name': 'Verse ',
            'func': 'toggleHighlight(\'verse\')'
        }
    },
    
    'structural': {
        'sample':   {
            'name': 'Samples',
            'func': 'toggleHighlight(\'sample\')'
        },
        'sampleType':   {
            'name': 'Sample Types',
            'func': 'toggleHighlight(\'sampleType\')'
        },
        'pb': {
            'name': 'Page Breaks',
            'func': 'toggleHighlight(\'pb\')'
        },
        'fol': {
            'name': 'Folio Sheet Delimiters',
            'func': 'toggleHighlight(\'fol\')'
        },
        'head': {
            'name': 'Headings', 
            'func': 'toggleHighlight(\'head\')'
        },
        'speaker': {
            'name': 'Speakers',
            'func': 'toggleHighlight(\'speaker\')'
            /* ToDo: Speaker a und Speaker b in verschiedenen Farben markieren, siehe showSpeaker()*/
            /*'func': 'showSpeaker()'*/
        },
        'metatext': {
            'name': 'Metatext',
            'func': 'toggleHighlight(\'metatext\')'
        },
        'superscr': {
            'name': 'Superscript',
            'func': 'toggleHighlight(\'superscr\')'
        },
        'subscr': {
            'name': 'Subscript',
            'func': 'toggleHighlight(\'subscr\')'
        }
    },
    
    'comments': {
        'comment': {
            'name': 'Comments',
            'func': 'showComments()'
        },
        'comment_editor': {
            'name': 'Original Editor\'s Comments',
            'func': 'toggleHighlight(\'comment_editor\')'
        }
    },
    
    'sample_Types': {
        'metricalPsalm':   {
            'name': 'Metrical Psalm',
            'func': 'hideMetricalPsalm()'
        },
        'canticle':   {
            'name': 'Canticle',
            'func': 'hideCanticle()'
        },
        'otherBibleVersification':   {
            'name': 'Other Bible Versification',
            'func': 'hideOtherBibleVersification()'
        }
}
}

function showBibleReferences() {    
        $('.bible[title]').tooltip();
        toggleHighlight('bible');
}

      
function showPsalmReferences() {
    $('.psalm[title]').tooltip();
    toggleHighlight('psalm');
}

function showForeign_omitted() {
    // var language = "greek";     //$("foreign_omitted").attr("title");  map() oder each() ? 
    //console.log(language);
    toggleHighlight('foreign_omitted');
    if (document.getElementById('checkBox-foreign_omitted').checked) {
        $("div.foreign_omitted-selected").html("<span>[...]</span>");
        $('.foreign_omitted[title]').tooltip('toggle');
    } 
    else {  
        $("div.foreign_omitted").html("<span></span>");
    }
}

function showSpeaker() {
    toggleHighlight('speaker');
    if(document.getElementById('checkBox-speaker').checked) {
        if ($('.speaker-selected[data-id]' == 'a')){
            $('div.speaker-selected').toggleClass('a');
        }
        else if ($('.speaker-selected[data-id]' == 'b')){
            $('div.speaker-selected').toggleClass('b');
        }
            $('div.a').css('border-left', 'solid 2px green');
            $('div.b').css('border-left', 'solid 2px red');
        }
    else {
        $('div.speaker').removeClass('a b');
        $('div.speaker').css('border-left', 'none');
    }
}

function showSampleTypes() {
/*    var sampleType = $('.sample[title]');
    console.log(sampleType);*/
    toggleHighlight('sampleType');
}

function showComments() {
    $('.comment').tooltip(
    {
    
    items:"[title]",
    content : $(this).attr("title"),
    track: true,
    tooltipClass: "CustomTooltip"
              

    /*      position: {
        my: "center bottom-20",
        at: "center top",
        using: function( position, feedback ) {
          $( this ).css( position );
          $(this).css("max-width","200px");
          $( "<div>" )
            .addClass( "arrow" )
            .addClass( feedback.vertical )
            .addClass( feedback.horizontal )
            .appendTo( this );
        }
      }*/
    }
    );
         
     toggleGlyphicon('comment');
    toggleHighlight('comment');                
}

function hideMetricalPsalm() {
    toggleHighlight('metricalPsalm');
    if (document.getElementById('checkBox-metricalPsalm').checked) {
        $("div.metricalPsalm-selected").hide();
    } 
    else {  
        $("div.metricalPsalm").show();
    }  
}

function hideCanticle() {
    toggleHighlight('canticle');
    if (document.getElementById('checkBox-canticle').checked) {
        $("div.canticle-selected").hide();
    } 
    else {  
        $("div.canticle").show();
    }  
}

function hideOtherBibleVersification() {
    toggleHighlight('otherBibleVersification');
    if (document.getElementById('checkBox-otherBibleVersification').checked) {
        $("div.otherBibleVersification-selected").hide();
    } 
    else {  
        $("div.otherBibleVersification").show();
    }  
}


function toggleHighlight(className) {
    // console.log('className: ' + className);
    $('.' + className).toggleClass(className + '-selected');        // sorgt dafür das die Elemente im Text angewählt werden 
    $('#select-' + className).toggleClass(className + '-selected'); // sorgt dafür das die Textelemente links im Menu angewählt werden
}


function toggleGlyphicon(className) {
    
    $('.glyphicon-'+className).toggle();
}

function scrollToTextElement(elemType, className, offset) {
    var elems = $('div.text').find('.' + className);
    var idx;
    if (textElementsMap[elemType][className]['idx'] === undefined) {
        idx = 0;
    } 
    else {
        idx = ( ( (textElementsMap[elemType][className]['idx'] + offset) % elems.size() ) + elems.size() ) % elems.size() // http://javascript.about.com/od/problemsolving/a/modulobug.htm
    }
    $.scrollTo(elems[idx], 400, {offset: {left: 0, top: -50}} );
    // console.log('elemType: ' + elemType + ' className: ' + className + ' offset: ' + offset, ' idx: ' + idx);
    textElementsMap[elemType][className]['idx'] = idx;
}

function addCheckboxListItem(parentDiv, elemType, classToToggle, label, func, fadefunc) {
    parentDiv.append(
        '<li id="' + classToToggle + '-listItem">' +
            '<label class="checkbox" style="font-size:14px;font-weight:normal;line-height: 20px;display:inline;">' +
                '<input id="checkBox-' + classToToggle + '" type="checkbox" onclick="' + func + '"/>' +
                '<span id="select-' + classToToggle + '" class="ButtonTexts">' +  label + '</span>' +
                '</label>' + 
            '<i class="glyphicon glyphicon-step-backward" title="next Element" onclick="scrollToTextElement(\'' + elemType + '\', \'' + classToToggle + '\', 1)"/>' +
            '<i class="glyphicon glyphicon-step-forward" title="previous Element" onclick="scrollToTextElement(\'' + elemType + '\', \'' + classToToggle + '\', -1)"/>' +
        '</li>'
    );
}

/*
 * '<i class="icon-step-forward pull-right" title="next Element" onclick="scrollToTextElement(\'' + elemType + '\', \'' + classToToggle + '\', 1)"/>' +
            '<i class="icon-step-backward pull-right" title="previous Element" onclick="scrollToTextElement(\'' + elemType + '\', \'' + classToToggle + '\', -1)"/>' +
 * 
 */
$(document).ready(function(){
    
    // Download-Bereich einfahren, wenn Text aufgerufen wird
    $('#download-wrapper').toggle();
    
    // Listenelement für alle Buttons auswählen
    var topLevelList = $('#topLevelHighlightButtons');
    
    // Checkboxen anhand der classes-Map erstellen, 
    // wenn die Elemente im Dokument vorhanden sind
    
    $.each(textElementsMap, function(elemType, elems) {
        topLevelList.append(
            '<li id="list-item' + elemType + '" class="toogle">' +
                '<div class="ButtonLine"><h6 id="toogle_'+elemType+'" >' + elemType.replace(/(\b[a-z])|(_)/g, function(str,c,d) { 
                                                                if(d) return ' '; 
                                                                if(c) return c.toUpperCase() }) +"</h6>"+"<i class='glyphicon glyphicon-chevron-down' /></div>"  +
                '<ul id="' + elemType + '" class="text_display InnerButtons"/>' +
            '</li>'
        );
        
        
        
        var currentList = $('#' + elemType);
        $.each(elems, function(className, values) {
            if ($('.' + className)[0]) {
                addCheckboxListItem(currentList, elemType, className, values['name'], values['func']);
            }
        });
        if (currentList.children().length == 0) {
            $('#list-item' + elemType  ).remove();
        }        
    });
    
    $("li.toogle .ButtonLine").click(function() {
            var raw_id = $(this).children("h6").attr("id");
            var id = raw_id.substring(7);
            $("#"+id).toggle("blind","");
            });
               
     $('.comment[title]').append ("<i class='glyphicon glyphicon-comment InText'  />");
      $('#select-comment').append ("<i class='glyphicon glyphicon-comment InText' / >");
     $('.glyphicon-comment').css("display","none");


});
'use strict';

/*
 * get raw xml from server and render it
 */
function getTabData(url) {
    console.log(url);    
}

$(function() {
    
    //first this
    $('#myTabs a[data-json-get]').click(function (e) {
        var active=$(this).parent().hasClass('active');
        console.log(active);
        if (!active) {
            getTabData($(this).attr('data-json-get'));
        }
        
    });
     
    $('#myTabs a').click(function (e) {
         e.preventDefault();
         $(this).tab('show');
    });
    
   
});
'use strict';

/*
 * get raw xml from server and render it
 */
function getTabData(url, tab) {
    console.log(tab);
    console.log(url);
    $(tab).load("rs/xslt/" + url);
}

$(function () {

    //first this
    $('#myTabs a[data-json-get]').click(function (e) {
        var active = $(this).parent().hasClass('active');
        console.log(active);
        if (!active) {
            getTabData($(this).attr('data-json-get'), $(this).attr('href'));
        }

    });

    $('#myTabs a').click(function (e) {
        e.preventDefault();
        $(this).tab('show');
    });


});
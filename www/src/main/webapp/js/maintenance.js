'use strict';

/*
 * get html from server and render it
 */
function getTabData(a) {
    var tab = $(a).attr('href');
    var url = $(a).attr('data-json-get');
    $(tab).load("rs/xslt/" + url);

}

$(function () {

    $('#myTabs a[data-json-get]').click(function () { //click handle
        var active = $(this).parent().hasClass('active');
        if (!active) {
            getTabData(this);
        }
    }).each(function () {//first time setup
        var active = $(this).parent().hasClass('active');
        if (active) {
            getTabData(this);
        }
    });

    $('#myTabs a').click(function (e) {//ajax&static tabs
        e.preventDefault();
        $(this).tab('show');
    });


});
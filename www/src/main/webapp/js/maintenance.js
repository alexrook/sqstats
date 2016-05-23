'use strict';

/*
 * get html from server and render it
 */
function getTabData(a) {
    var tab = $(a).attr('href');
    var url = $(a).attr('data-json-get');
    $(tab).load("rs/xslt/" + url, function (response, status, xhr) {
        if (xhr.status === 404) {
            //перенаправление на несуществующую страницу, 
            //что бы приложение отработало 404-error в соответствии с web.xml
            window.location.href = "404";
            $(tab).html(response);
        }
    });

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
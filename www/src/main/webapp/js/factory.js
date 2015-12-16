'use strict';

var x2js = new X2JS();

var RawReport = function (RawReportJson) {
    this.rawReport = RawReportJson['raw-xml-report'];
};


RawReport.prototype.getName = function () {
    return this.rawReport.meta.name;
};

RawReport.prototype.getDescription = function () {
    return this.rawReport.meta.description ? this.rawReport.meta.description : '';
};

RawReport.prototype.getErrorMsg = function () {
    return this.rawReport.meta.error ? this.rawReport.meta.error.msg : '';
};

RawReport.prototype.isValid = function () {
    return !this.rawReport.meta.error;
};

angular.module('sqstats.factory', [])
        .factory('RawRest', ['$http','$q', function ($http,$q) {

                return {
                    getRawReports: function () {//returns HttpPromise
                        return $http({
                            method: 'GET',
                            url: window.appdeb.urlprefix + 'rs/raw/reports'
                        }).then(function (response) {//success callback

                            var rawReportsJson = x2js.xml_str2json(response.data);
                            rawReportsJson = rawReportsJson.map ? rawReportsJson.map : rawReportsJson;
                            rawReportsJson = rawReportsJson.entry ? rawReportsJson.entry : [];

                            var result = [];

                            for (var i = 0; i < rawReportsJson.length; i++) {
                                var rawReport = new RawReport(rawReportsJson[i]);
                                result.push(rawReport);
                            }

                            return result;

                        }, function (response) { //error callback
                            return response;
                        });

                    },
                     getRawReport: function (reportName) {//returns HttpPromise
                        return $http({
                            method: 'GET',
                            url: window.appdeb.urlprefix + 'rs/raw/'+reportName
                        }).then(function (response) {//success callback

                            var rawReportJson = x2js.xml_str2json(response.data);
                            console.log(rawReportJson);

                            return rawReportJson;

                        }, function (response) { //error callback
                            return $q.reject(response.data ? response.data: null);
                        });
                    }

                };

            }]);
        
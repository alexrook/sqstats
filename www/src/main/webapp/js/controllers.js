'use strict';

/* Controllers */

angular.module('sqstats.controllers', [])

        .controller('MainCtrl',
                ['$scope', function ($scope) {


                    }])
        .controller('RepListCtrl',
                ['$scope', 'RawRest', function ($scope, RawRest) {
                        RawRest.getRawReports().then(
                                function (rawReports) {
                                    $scope.reports = rawReports;
                                },
                                function (error) {
                                    $scope.error = error;
                                });
                    }])
        .controller('ReportCtrl',
                ['$scope', '$routeParams', 'RawRest', function ($scope, $routeParams, RawRest) {
                        console.log($routeParams);
                          RawRest.getRawReport($routeParams.reportName).then(
                                function (rawReport) {
                                    $scope.report = rawReport;
                                },
                                function (error) {
                                    $scope.error = error;
                                });
                    }]);

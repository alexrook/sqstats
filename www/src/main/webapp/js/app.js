'use strict';

// Declare app level module 
angular.module('sqstats', ['ngRoute', 'sqstats.directives', 'sqstats.controllers', 'sqstats.factory']).
        config(['$routeProvider', function ($routeProvider) {

                $routeProvider
                        .when('/list',
                                {templateUrl: 'part/list.html',
                                    controller: 'RepListCtrl'})
                        .when('/about',
                                {templateUrl: 'part/about.html',
                                    controller: 'MainCtrl'})
                        .when('/report/:reportName',
                                {templateUrl: 'part/report.html',
                                    controller: 'ReportCtrl'})
                        .otherwise({redirectTo: '/list'});


            }]);

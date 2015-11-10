'use strict';

// Declare app level module 
angular.module('sqstats', ['ngRoute', 'sqstats.controllers']).
        config(['$routeProvider', function ($routeProvider) {

                $routeProvider
                        .when('/list',
                                {templateUrl: 'part/list.html',
                                    controller: 'RepListCtrl'})
                        .when('/about',
                                {templateUrl: 'part/about.html',
                                    controller: 'MainCtrl'})
                        .otherwise({redirectTo: '/list'});


            }]);

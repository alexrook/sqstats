'use strict';

/* Controllers */

angular.module('sqstats.controllers', [])

        .controller('MainCtrl',
                ['$scope', function ($scope) {


                    }])
        .controller('RepListCtrl',
                ['$scope', '$http', function ($scope, $http) {

                        $http({
                            method: 'GET',
                            url: window.appdeb.urlprefix + 'rs/raw/reports'
                        }).then(function successCallback(response) {
                            var x2js = new X2JS();
                            $scope.reports = x2js.xml_str2json(response.data);
                            $scope.reports=$scope.reports.map?$scope.reports.map:$scope.reports;
                            console.log($scope.reports);   

                        }, function errorCallback(response) {
                            $scope.error = response;
                        });

                    }]);

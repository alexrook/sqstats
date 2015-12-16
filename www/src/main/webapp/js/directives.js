'use strict';

angular.module('sqstats.directives', [])
        /* http://stackoverflow.com/questions/14201753/angular-js-how-when-to-use-ng-click-to-call-a-route
         * Click to navigate
         * similar to <a href="#/partial"> but hash is not required, e.g. <div click-link="/partial">
         */
        .directive('clickLink', ['$location', function($location) {
                return {
                    link: function(scope, element, attrs) {
                        element.on('click', function() {
                            scope.$apply(function() {
                                $location.path(attrs.clickLink);
                            });
                        });
                    }
                };
            }]);


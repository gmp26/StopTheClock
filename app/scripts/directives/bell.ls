'use strict';

angular.module 'bellDirective' []
  .directive 'bell', <[]> ++ ->
    replace: true
    template: '<audio id="bell" autobuffer controls style="display:none">
  <source src="bell.mp3">
</audio>'
    restrict: 'E'
    link: (scope, element, attrs) ->

      scope.ring = ->
        element.0.play!

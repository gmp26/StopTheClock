'use strict';

angular.module 'bouncerDirective' []
  .directive 'bouncer', <[$timeout]> ++ ($timeout) ->
    restrict: 'A'
    link: (scope, element, attrs) ->

      scope.bounceCount = 0

      scope.bounce = ->
        scope.bounceCount = 20
        scope.bouncer!

      scope.bouncer = ->
        if scope.bounceCount > 0
          --scope.bounceCount
          $timeout scope.bouncer, 45

          turn = "rotate(#{357 + (Math.round 6*Math.random!)}deg)"

        else
          turn = "rotate(0deg)"

        style = "-webkit-transform:#{turn};-moz-transform:#{turn};-ms-transform:#{turn};-o-transform:#{turn};-transform:#{turn}"
        element.attr 'style', style


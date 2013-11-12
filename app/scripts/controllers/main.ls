'use strict'

angular.module 'StopTheClockApp'
  .controller 'MainCtrl', ($scope, $routeParams) ->

    # $scope and $timeout are provided automatically by angular dependency injection

    # set a default time to 10:30
    $scope.hours = 10
    $scope.minutes = 30

    $scope.hours = $routeParams.hh ? 10
    $scope.minutes = $routeParams.mm ? 30
    $scope.step = $routeParams.step ? 30

    # supports ng-style="turn('minute')" directive
    $scope.turn = (hand) ->

      # set the turn according to the clock hand
      switch hand
        | 'minute' => turn = "rotate(#{6 * $scope.minutes}deg)"
        | 'hour' => turn = "rotate(#{30 * $scope.hours + $scope.minutes/2}deg)"

      # ng-switch will pick one of these to use dependent on the browser
      return {
        "-webkit-transform": turn
        "-moz-transform": turn
        "-ms-transform": turn
        "-o-transform": turn
        "-transform": turn
      }


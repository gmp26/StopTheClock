'use strict'

angular.module 'StopTheClockApp'
  .controller 'MainCtrl', ($scope, $routeParams) ->

    # $scope and $timeout are provided automatically by angular dependency injection

    # read initial setup from URL routeParams or take default of 10:30, 30, 12
    $scope.hours = $routeParams.hh ? 10
    $scope.minutes = $routeParams.mm ? 30
    $scope.part = $routeParams.part ? 30
    $scope.max = $routeParams.max ? 12

    $scope.analog = (target) -> target <= 12

    $scope.step = (number) !->
      $scope.minutes += number * (60 / $scope.part)
      while $scope.minutes > 60
        ++$scope.hours
        $scope.minutes -= 60

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


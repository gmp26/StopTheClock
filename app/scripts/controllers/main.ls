'use strict'

angular.module 'StopTheClockApp'
  .controller 'MainCtrl', ($scope, $timeout) ->

    # $scope and $timeout are provided automatically by angular dependency injection

    # set a default time to 10:30
    $scope.hours = 10
    $scope.minutes = 30

    # supports ng-style="turn('minute')" directive
    $scope.turn = (hand) ->

      # set the turn according to the clock hand
      switch hand
        | 'minute' => turn = "rotate(#{6 * $scope.minutes}deg)"
        | 'hour' => turn = "rotate(#{30 * $scope.hours + $scope.minutes / 2}deg)"

      # ng-switch will pick one of these to use dependent on the browser
      return {
        "-webkit-transform": turn
        "-moz-transform": turn
        "-ms-transform": turn
        "-o-transform": turn
        "-transform": turn
      }

    # Make use of angular's $timeout service to update hours and minutes every second


    handler = ->
      date = new Date() # see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date
      #
      # Adding 1 for summer time.
      # There are javascript libraries that would look up whether this is required
      # by locale and time of year. But since we're going to delete this code shortly...
      #
      $scope.hours = (date.getUTCHours! + 1 + date.getTimezoneOffset!*60) % 12 
      $scope.minutes = date.getUTCMinutes!
      $timeout handler, 1000

    $timeout handler  # start calling the timeout handler every 1000 ms or so.


'use strict'

angular.module 'StopTheClockApp'
  .controller 'MainCtrl', ($scope, $routeParams, $timeout, $log) ->

    # $scope, $routeParams, and $timeout are provided automatically
    # by angular dependency injection.
    #
    # When testing, we provide fake values for these
    #
    hh = ~~($routeParams.hh ? 6)
    mm = ~~($routeParams.mm ? 0)
    $scope.gameSetup = {
      hours: hh
      minutes: mm
      part: ~~($routeParams.part ? 4)  # the part of an hour to step by
      max: ~~($routeParams.max ? 12)    # 12 hour analog or 24 hour digital
      analog: ~~($routeParams.max ? 12) == 12
    }

    # Initially hide game change settings
    $scope.hideSettings = true;

    $scope.stepSizes = [5,10,15,20,30,60]

    $scope.setStepSize = (index) ->
      stepSize = $scope.stepSizes[index]
      $scope.gameSetup.part = 60 / stepSize

    $scope.setupGame = !->
      $scope.reset!

    # an array of player information
    $scope.playerInfo =
      * id: 1
        buttonClass: 'btn-info'
      * id: 2
        buttonClass: 'btn-danger'

    #
    # Put a watch on $scope.gameSetup.minutes to check for an hour carry
    #
    $scope.$watch 'gameSetup.minutes', (newValue) !->
      if newValue >= 60
        if $scope.gameSetup.hours + 1 < $scope.gameSetup.max
          $scope.gameSetup.minutes = 0
          $scope.gameSetup.hours = $scope.gameSetup.hours + 1
        else
          $scope.gameSetup.minutes = 55
      else if newValue < 0
        if $scope.gameSetup.hours > 0
          $scope.gameSetup.minutes = 55
          $scope.gameSetup.hours = $scope.gameSetup.hours - 1
        else
          $scope.gameSetup.minutes = 0

    #
    # Watch gameSetup.analog to see if max needs adjustment
    #
    $scope.$watch 'gameSetup.analog', (newValue) !->
      $scope.gameSetup.max = if $scope.gameSetup.analog then 12 else 24

    $scope.reset = !->
      # read initial setup from URL routeParams or take default of 6:00, 30, 12
      #
      # NB. ~~"24" == 24
      #
      $scope.hours = $scope.gameSetup.hours
      $scope.minutes = $scope.gameSetup.minutes
      $scope.part = $scope.gameSetup.part
      $scope.max = $scope.gameSetup.max
      $scope.analog = $scope.max == 12     # choose type based on max value
      $scope.player = 1
      $scope.gameOver = false       # true if game is over
      $scope.winner = null          # the winner number
      $scope.disabled = false       # disables controls if true
      stepSize = 60/$scope.part
      $scope.steps = for i til $scope.part
        (i+1) * stepSize

    $scope.reset!

    # return the other player number from the one given
    otherPlayer = (playerNumber) -> 3 - playerNumber

    #
    # ! before -> here because I don't want a return value
    #
    $scope.step = (number) !->

      # in case we have to revert...
      hh_original = $scope.hours
      mm_original = $scope.minutes

      # make the step
      $scope.minutes += number * (60 / $scope.part)
      while $scope.minutes >= 60
        ++$scope.hours
        $scope.minutes -= 60

      # detect end of game
      if $scope.hours == $scope.max and $scope.minutes == 0
        $scope.gameOver = true
        $scope.winner = $scope.player

      if $scope.hours > $scope.max or ($scope.hours == $scope.max and $scope.minutes > 0)
        # we've gone past 12:00 or 24:00, disable the controls
        $scope.disabled = true

        # And set a 1 second timeout to revert clock
        $timeout ->
          $scope.hours = hh_original
          $scope.minutes = mm_original
          $scope.disabled = false
        , 1500ms, true
        #
        # that last false parameter is necessary to get the tests working
        # It prevents the timer callback function being wrapped in a $scope.$apply call.
        #
        # I don't understand why the default 'true' isn't right yet :(
        #

      # switch players whatever happens
      $scope.player = otherPlayer $scope.player


    # supports ng-style="turn('minute')" directive
    $scope.turn = (hand) ->

      # set the turn according to the clock hand
      switch hand
        | 'minute' => turn = "rotate(#{6 * $scope.minutes + 360*$scope.hours}deg)"
        | 'hour' => turn = "rotate(#{30 * $scope.hours + $scope.minutes/2}deg)"

      # ng-switch will pick one of these to use dependent on the browser
      return {
        "-webkit-transform": turn
        "-moz-transform": turn
        "-ms-transform": turn
        "-o-transform": turn
        "-transform": turn
      }

    $scope.playerStatus = ->
      if $scope.gameOver
        "Player #{$scope.winner} is the winner!"
      else
        "Player #{$scope.player} to go next"      

    $scope.gameStatus = ->
      if $scope.gameOver 
        "is the winner!" 
      else 
        "How far do you want to move the clock forward? 
        The winner is the first to reach exactly midnight."

    # Convert hours and minutes to a date object so we can easily render it as hh:mm
    $scope.date = ->
      #
      # return a javascript date object. 
      # The view will ignore all fields but hours and minutes.
      # 
      hours = if $scope.hours > 24 then 0 else $scope.hours
      console.log "#{hours}:#{$scope.minutes}"
      Date.parse "Thu, 01 Jan 1970 #{hours}:#{$scope.minutes}:00 GMT"

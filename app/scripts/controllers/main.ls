'use strict'

angular.module 'StopTheClockApp'
  .controller 'MainCtrl', <[$scope $routeParams $timeout $log]> ++ ($scope, $routeParams, $timeout, $log) ->

    # $scope, $routeParams, and $timeout are provided automatically
    # by angular dependency injection.
    #
    # When testing, we provide fake values for these
    #
    maxTime = Math.round ~~($routeParams.max ? 12)    # 12 hour analog or 24 hour digital
    analog = maxTime <= 12
    hh = Math.round ~~($routeParams.hh ? 6)
    mm = Math.round ~~($routeParams.mm ? 0)

    # Let's make the 60 a parameter
    stepLimit = Math.round ~~($routeParams.stepLimit ? 60)

    $scope.gameSetup = {
      hours: hh
      minutes: mm
      max: maxTime    # 12 hour analog or 24 hour digital
      analog: analog
      stepLimit: stepLimit
    }

    # validate stepSize
    # stepSize = Math.round ~~($routeParams.stepSize ? (stepLimit / 4))
    # while stepLimit % stepSize
    #   stepSize = stepSize + 1

    # validate stepSize
    validateStepSize = (stepSize) ->
      return stepSize if $scope.gameSetup.stepLimit % stepSize == 0

      while stepSize >= 1 and $scope.gameSetup.stepLimit % stepSize
        stepSize = stepSize - 1
      return stepSize if stepSize > 1

      while stepSize <= $scope.gameSetup.stepLimit and $scope.gameSetup.stepLimit % stepSize
        stepSize = stepSize + 1

      return stepSize

    $scope.gameSetup.stepSize = validateStepSize Math.round ~~($routeParams.stepSize ? (stepLimit / 4))

    # Initially hide game change settings
    $scope.hideSettings = true;

    # valid step sizes are factors of stepLimit
    setStepSizes = !->
      stepLimit = $scope.gameSetup.stepLimit

      # This is a livescript comprehension returning an array
      $scope.stepSizes = for i from 1 to stepLimit when stepLimit % i == 0
        i

    setStepSizes!

    $scope.setStepSize = (index) ->
      $scope.gameSetup.stepSize = $scope.stepSizes[index]

    # an array of player information
    $scope.playerInfo =
      * id: 1
        buttonClass: 'btn-info'
      * id: 2
        buttonClass: 'btn-danger'

    #
    # Put a watch on $scope.gameSetup.stepLimit as we might need to rework stepSizes
    # and stepSize
    #
    $scope.$watch 'gameSetup.stepLimit', (newValue) !->
      setStepSizes!
      $scope.gameSetup.stepSize = validateStepSize $scope.gameSetup.stepSize



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
      $scope.stepSize = $scope.gameSetup.stepSize
      $scope.stepLimit = $scope.gameSetup.stepLimit
      $scope.part = $scope.stepLimit / $scope.stepSize
      $scope.max = $scope.gameSetup.max
      $scope.analog = $scope.max <= 12     # choose type based on max value
      $scope.player = 1
      $scope.gameOver = false       # true if game is over
      $scope.winner = null          # the winner number
      $scope.disabled = false       # disables controls if true
      $scope.steps = for i til $scope.part
        (i+1) * $scope.gameSetup.stepSize

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
      $scope.minutes += number * $scope.stepSize
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
        $scope.player = $scope.winner 
        "Player #{$scope.winner} is the winner!"
      else
        "Player #{$scope.player} to go next"      

    $scope.gameStatus = ->
      if $scope.gameOver 
        "Click Restart to try again." 
      else 
        "How far do you want to move the clock forward? 
        The winner is the first to reach exactly midnight."

    # Convert hours and minutes to a date object so we can easily render it as hh:mm
    $scope.date = ->
      #
      # return a javascript date object. 
      # The view will ignore all fields but hours and minutes.
      # 
      hours = if $scope.hours >= 24 then 0 else $scope.hours
      console.log "#{hours}:#{$scope.minutes}"
      Date.parse "Thu, 01 Jan 1970 #{hours}:#{$scope.minutes}:00 GMT"

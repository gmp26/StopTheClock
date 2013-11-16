'use strict'

describe 'Controller: MainCtrl', (_) ->

  # load the controller's module
  beforeEach module 'StopTheClockApp'

  MainCtrl = {}
  $scope = {}
  $route = {}
  $timeout = {}


  describe 'Clock hand turns', (_) ->

    # Initialize the controller and a mock scope
    beforeEach inject ($controller, $rootScope, _$timeout_) ->

      $timeout := _$timeout_

      # Notice use of := rather than = because we are setting values in the
      # closure, outside the local scope of the function.

      $scope := $rootScope.$new()
      $scope.hours = 6
      $scope.minutes = 0

      #
      # Fake some routeParameters that set up a start time of 10:30 and
      # a step of 1/12 hour = 5 minutes. It's as if we had navigated to
      # StopTheClock/#/10/30/12/12
      #
      routeParams = {
        hh: "10"
        mm: "30"
        part: "12"
        max: "12"
      }

      MainCtrl := $controller 'MainCtrl', {
        $scope: $scope,
        $routeParams: routeParams
        $timeout: $timeout
      }

    #
    # Turn tests
    #
    it 'should turn minutes hand by 180deg for 30 minutes', ->
      expect($scope.turn('minute')["-webkit-transform"]).toEqual "rotate(180deg)"

    it 'should turn hour hand by 315deg for 10 hours and 30 minutes', ->
      expect($scope.turn('hour')["-webkit-transform"]).toEqual "rotate(315deg)"

    it 'should return undefined when asked about the seconds hand', ->
      expect($scope.turn('seconds')["-webkit-transform"]).toBeUndefined()

  describe 'URL route mapping', (_) ->

    #
    # We're simply testing that both routes are handled by the same controller
    # 'MainCtrl'. Not every interesting.
    #

    # Initialize the controller and a mock scope
    beforeEach inject ($controller, $rootScope, _$route_, _$timeout_) ->
      $scope := $rootScope.$new()
      $route := _$route_
      $timeout := _$timeout_

      MainCtrl := $controller 'MainCtrl', {
        $scope: $scope
      }

    it 'should map / to MainCtrl', ->
      expect($route.routes['/'].controller).toBe('MainCtrl')

    it 'should map /:hh/:mm/:part to MainCtrl', ->
      expect($route.routes['/:hh/:mm/:part'].controller).toBe('MainCtrl')


  describe 'Testing analog clock game play', (_) ->

    #
    # The idea is that http://nrich.maths.org/StopTheClock/#/10/30/4
    # will cause the animation to start the clock at 10:30 and set the
    # minimum step to 1/4 hour = 15 minutes.
    #

    #
    # Fake some routeParameters that set up a start time of 3:20 and
    # a step of 1/12 hour = 5 minutes. It's as if we had navigated to
    # StopTheClock/#/3/20/12/12
    #
    routeParams = {
      hh: "3"
      mm: "20"
      part: "12"
      max: "12"
    }

    # Initialize the controller and a mock scope
    beforeEach inject ($controller, $rootScope, _$route_, _$timeout_) ->
      $scope := $rootScope.$new()
      $route := _$route_
      $timeout := _$timeout_  # accesses the $timeout in angular_mocks

      # We expect angular to strip $routeParameters from the URL
      # and inject them into the MainCtrl function if it
      # has a $routeParameters parameter.

      #
      # Notice that we are passing a mocked-up $scope, $routeParams
      # and $timeout into the controller
      #
      MainCtrl := $controller 'MainCtrl', {
        $scope: $scope
        $routeParams: routeParams
        $timeout: $timeout
      }

    it 'should display an analog clock', ->
      expect($scope.analog).toBe true

    it 'should start with player 1', ->
      expect($scope.player).toBe 1

    it 'should start at 8:XX', ->
      expect($scope.hours).toBe 3

    it 'should start at X:20', ->
      expect($scope.minutes).toBe 20

    it 'should start at part = 30', ->
      expect($scope.part).toBe 12

    it 'should start with 12 hour target', ->
      expect($scope.max).toBe 12

    it 'should add parts of the hour properly', ->
      $scope.step 3
      expect($scope.hours).toBe 3
      expect($scope.minutes).toBe 35
      $scope.step 97
      expect($scope.hours).toBe 11
      expect($scope.minutes).toBe 40

    it 'should detect a player 1 win', ->
      $scope.hours = 11
      $scope.minutes = 30
      $scope.part = 2 # 30 mins
      $scope.player = 1
      expect($scope.gameOver).toBe false
      $scope.step 1
      expect($scope.winner).toBe 1
      expect($scope.gameOver).toBe true


    it 'should detect a player 2 win', ->
      $scope.hours = 11
      $scope.minutes = 0
      $scope.part = 2 # 30 mins
      $scope.player = 2
      expect($scope.gameOver).toBe false
      $scope.step 2
      expect($scope.winner).toBe 2
      expect($scope.gameOver).toBe true

    it 'should switch player after each move', ->
      $scope.player = 1
      $scope.step 1
      expect($scope.player).toBe 2
      $scope.step 3
      expect($scope.player).toBe 1

    it 'should reset to starting parameters', ->
      $scope.reset!
      expect($scope.analog).toBe true
      expect($scope.hours).toBe 3
      expect($scope.minutes).toBe 20
      expect($scope.part).toBe 12
      expect($scope.max).toBe 12
      expect($scope.player).toBe 1
      expect($scope.gameOver).toBe false

    it 'should undo an end move that is too big', ->
      # the clock will move past 12:00
      # but should then move back after an interval
      # so we have to advance the timer
      # before checking our expectations
      $scope.hours = 11
      $scope.minutes = 30
      $scope.part = 2
      $scope.player = 1
      $scope.step 2

      # flush out all outstanding $timeout events
      # We're using the mock $timeout function from angular_mocks.js
      $timeout.flush 20000ms

      expect($scope.hours).toBe 11
      expect($scope.minutes).toBe 30
      expect($scope.player).toBe 2 #the move has been forfeited

      # Note that the game can go on indefinitely if the start time
      # prevents it being possible to reach exactly 12:00.
      #
      # This is probably what we want since we can make it a problem.
      #

  describe 'Testing digital 24-hour clock game play', (_) ->

    #
    # Fake some routeParameters that set up a start time of 3:20 and
    # a step of 1/2 hour = 3 minutes. It's as if we had navigated to
    # StopTheClock/#/3/20/2/24
    #
    routeParams = {
      hh: "3"
      mm: "20"
      part: "2"
      max: "24"
    }

    # Initialize the controller and a mock scope
    beforeEach inject ($controller, $rootScope, _$route_, _$timeout_) ->
      $scope := $rootScope.$new()
      $route := _$route_
      $timeout := _$timeout_  # accesses the $timeout in angular_mocks

      # MaintCtrl expects angular to provide $routeParameters stripped from the URL
      MainCtrl := $controller 'MainCtrl', {
        $scope: $scope
        $routeParams: routeParams
        $timeout: $timeout
      }

    it 'should display a digital 24 hour clock', ->
      expect($scope.analog).toBe false

    it 'should not detect a player 1 win at 12:00', ->
      $scope.hours = 11
      $scope.minutes = 30
      $scope.part = 2 # 30 mins
      $scope.player = 1
      $scope.step 1
      expect($scope.gameOver).toBe false

    it 'should detect a player 1 win', ->
      $scope.hours = 23
      $scope.minutes = 30
      $scope.part = 2 # 30 mins
      $scope.player = 1
      expect($scope.gameOver).toBe false
      $scope.step 1
      expect($scope.winner).toBe 1
      expect($scope.gameOver).toBe true

    it 'should detect a player 2 win', ->
      $scope.hours = 23
      $scope.minutes = 0
      $scope.part = 2 # 30 mins
      $scope.player = 2
      expect($scope.gameOver).toBe false
      $scope.step 2
      expect($scope.winner).toBe 2
      expect($scope.gameOver).toBe true

    it 'should reset to starting parameters', ->
      $scope.reset!
      expect($scope.analog).toBe false
      expect($scope.hours).toBe 3
      expect($scope.minutes).toBe 20
      expect($scope.part).toBe 2
      expect($scope.max).toBe 24
      expect($scope.player).toBe 1
      expect($scope.gameOver).toBe false

    it 'should undo an end move that is too big', ->
      # the clock will move past 12:00
      # but should then move back after an interval
      # so we have to advance the timer
      # before checking our expectations
      $scope.hours = 23
      $scope.minutes = 30
      $scope.part = 2
      $scope.player = 1
      $scope.step 2

      # flush out all outstanding $timeout events
      # We're using the mock $timeout function from angular_mocks.js
      # flush all events for 1000ms
      $timeout.flush 1000ms

      expect($scope.hours).toBe 23
      expect($scope.minutes).toBe 30
      expect($scope.player).toBe 2 #the move has been forfeited

      #
      # Note that the game can go on indefinitely if the start time
      # prevents it being possible to reach exactly 24:00.
      #
      # This is probably what we want since we can make it a problem.
      #









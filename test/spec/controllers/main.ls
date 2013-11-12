'use strict'

describe 'Controller: MainCtrl', (_) ->

  # load the controller's module
  beforeEach module 'StopTheClockApp'

  MainCtrl = {}
  $scope = {}
  $route = {}


  describe 'Clock hand turns', (_) ->

    # Initialize the controller and a mock scope
    beforeEach inject ($controller, $rootScope) ->
      $scope := $rootScope.$new()
      $scope.hours = 10
      $scope.minutes = 30
      MainCtrl := $controller 'MainCtrl', {
        $scope: $scope
      }

    #
    # Turn tests
    #
    it 'should turn minutes hand by 180deg for 30 minutes', ->
      expect($scope.turn('minute')["-webkit-transform"]).toEqual "rotate(180deg)"

    it 'should turn hour hand by 315deg for 10 hours and 30minutes', ->
      expect($scope.turn('hour')["-webkit-transform"]).toEqual "rotate(315deg)"

    it 'should return undefined when asked about the seconds hand', ->
      expect($scope.turn('seconds')["-webkit-transform"]).toBeUndefined()

  describe 'URL route mapping', (_) ->

    #
    # We're simply testing that both routes are handled by the same controller
    # 'MainCtrl'. Not every interesting.
    #

    # Initialize the controller and a mock scope
    beforeEach inject ($controller, $rootScope, _$route_) ->
      $scope := $rootScope.$new()
      $route := _$route_

      MainCtrl := $controller 'MainCtrl', {
        $scope: $scope
      }

    it 'should map / to MainCtrl', ->
      expect($route.routes['/'].controller).toBe('MainCtrl')

    it 'should map /:hh/:mm/:part to MainCtrl', ->
      expect($route.routes['/:hh/:mm/:part'].controller).toBe('MainCtrl')


  describe 'Initialising with parameters from the URL', (_) ->

    #
    # The idea is that http://nrich.maths.org/StopTheClock/#/10/30/4
    # will cause the animation to start the clock at 10:30 and set the
    # minimum step to 1/4 hour = 15 minutes.
    #
    # Need to ensure that 12:00 is reachable in some multiple of partsize minutes
    # from the starting point.
    #
    # Also need to worry about digital 24 hour clock.
    #

    #
    # Fake some routeParameters that set up a start time of 3:20 and
    # a step of 1/12 hour = 5 minutes. It's as if we had navigated to
    # StopTheClock/#/3/20/12/12
    #
    routeParams = {
      hh: 3
      mm: 20
      part: 12
      max: 12
    }

    # Initialize the controller and a mock scope
    beforeEach inject ($controller, $rootScope, _$route_) ->
      $scope := $rootScope.$new()
      $route := _$route_

      # We expect angular to strip $routeParameters from the URL
      # and inject them into the MainCtrl function if it
      # has a $routeParameters parameter.
      MainCtrl := $controller 'MainCtrl', {
        $scope: $scope
        $routeParams: routeParams
      }

    it 'should start at 8:XX', ->
      expect($scope.hours).toBe 3

    it 'should start at X:20', ->
      expect($scope.minutes).toBe 20

    it 'should start at part = 30', ->
      expect($scope.part).toBe 12

    it 'should start with 12 hour target', ->
      expect($scope.max).toBe 12

    it 'should choose analog or digital properly', ->
      expect($scope.analog 12).toBe true
      expect($scope.analog 24).toBe false

    it 'should add parts of the hour properly', ->
      $scope.step(3)
      expect($scope.hours).toBe 3
      expect($scope.minutes).toBe 35
      $scope.step(97)
      expect($scope.hours).toBe 11
      expect($scope.minutes).toBe 40














'use strict'

describe 'Controller: MainCtrl', (_) ->

  # load the controller's module
  beforeEach module 'StopTheClockApp'

  MainCtrl = {}
  scope = {}
  route = {}

  describe 'Clock hand turns', (_) ->

    # Initialize the controller and a mock scope
    beforeEach inject ($controller, $rootScope) ->
      scope := $rootScope.$new()
      scope.hours = 10
      scope.minutes = 30
      MainCtrl := $controller 'MainCtrl', {
        $scope: scope
      }

    #
    # Turn tests
    #
    it 'should turn minutes hand by 180deg for 30 minutes', ->
      expect(scope.turn('minute')["-webkit-transform"]).toEqual "rotate(180deg)"

    it 'should turn hour hand by 315deg for 10 hours and 30minutes', ->
      expect(scope.turn('hour')["-webkit-transform"]).toEqual "rotate(315deg)"

    it 'should return undefined when asked about the seconds hand', ->
      expect(scope.turn('seconds')["-webkit-transform"]).toBeUndefined()

  describe 'URL route mapping', (_) ->

    #
    # We're simply testing that both routes are handled by the same controller
    # 'MainCtrl'. Not every interesting.
    #

    # Initialize the controller and a mock scope
    beforeEach inject ($controller, $rootScope, $route) ->
      scope := $rootScope.$new()
      route := $route

      MainCtrl := $controller 'MainCtrl', {
        $scope: scope
      }

    it 'should map / to MainCtrl', ->
      expect(route.routes['/'].controller).toBe('MainCtrl')

    it 'should map /:hh/:mm/:step to MainCtrl', ->
      expect(route.routes['/:hh/:mm/:step'].controller).toBe('MainCtrl')


  describe 'Initialising with URL routeParameters', (_) ->

    #
    # The idea is that http://nrich.maths.org/StopTheClock/#/10/30/15
    # will cause the animation to start the clock at 10:30 and set the
    # minimum stepsize for the game at 15 minutes. Other step sizes will
    # be multiples of 15 minutes up to a maximum of 60 minutes.
    #
    # Need to ensure that 12:00 is reachable in some multiple of stepsize minutes
    # from the starting point.
    #
    # Also need to worry about digital 24 hour clock.
    #

    # Initialize the controller and a mock scope
    beforeEach inject ($controller, $rootScope, $route) ->
      scope := $rootScope.$new()
      route := $route

      MainCtrl := $controller 'MainCtrl', {
        $scope: scope
      }





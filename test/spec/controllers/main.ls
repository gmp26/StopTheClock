'use strict'

describe 'Controller: MainCtrl', (_) ->

  # load the controller's module
  beforeEach module 'StopTheClockApp'

  MainCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope := $rootScope.$new()
    scope.hours = 10
    scope.minutes = 30
    MainCtrl := $controller 'MainCtrl', {
      $scope: scope
    }

  it 'should turn minutes hand by 180deg for 30 minutes', ->
    expect(scope.turn('minute')["-webkit-transform"]).toEqual "rotate(180deg)"

  it 'should turn hour hand by 315deg for 10 hours and 30minutes', ->
    expect(scope.turn('hour')["-webkit-transform"]).toEqual "rotate(315deg)"


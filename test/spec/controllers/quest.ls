'use strict'

describe 'Controller: QuestCtrl', (_) ->

  # load the controller's module
  beforeEach module 'StopTheClockApp'

  QuestCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope := $rootScope.$new()
    QuestCtrl := $controller 'QuestCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect scope.awesomeThings.length .toBe 7

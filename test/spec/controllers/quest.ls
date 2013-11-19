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

  it 'should attach a list of questions to the scope', ->
    expect scope.questions.length .toBe 24

  it 'should determine whether a question has an image', ->
    expect(scope.hasImage 0).toBe true
    expect(scope.hasImage 23).toBe false

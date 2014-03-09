'use strict'

describe 'Directive: bell', (_) ->

  # load the directive's module
  beforeEach module 'bellDirective'

  var $rootScope
  var $scope
  var $compile

  beforeEach inject (_$compile_, _$rootScope_) ->
    $rootScope := _$rootScope_
    $scope := $rootScope.$new!
    $compile := _$compile_

  it 'should make hidden element visible', ->
    element = angular.element '<bell></bell>'
    element = $compile(element) $scope
    expect element.text! .toBe 'this is the bell directive'

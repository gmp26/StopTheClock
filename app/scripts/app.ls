'use strict'

angular.module 'StopTheClockApp', ['ngRoute', 'ui.bootstrap']
  .config ($routeProvider) ->
    $routeProvider.when '/', {
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    }
    .when '/:hh/:mm', {
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    }
    .when '/:hh/:mm/:stepSize', {
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    }
    .when '/:hh/:mm/:stepSize/:max', {
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    }
    .otherwise {
      redirectTo: '/'
    }


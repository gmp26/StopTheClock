'use strict'

{is-type, break-list} = require 'prelude-ls'

angular.module 'StopTheClockApp'
  .controller 'QuestCtrl', <[$scope]> ++ ($scope) ->

    # $scope.rate = 3;
    # $scope.max = 5;
    # $scope.isReadonly = false;

    # $scope.hoveringOver = (value) !->
    #   $scope.overStar = value
    #   $scope.percent = 100 * (value / $scope.max)

    # $scope.ratingStates = [
    #   * stateOn: 'icon-ok-sign'
    #     stateOff: 'icon-ok-circle'
    #   * stateOn: 'icon-star'
    #     stateOff: 'icon-star-empty'
    #   * stateOn: 'icon-heart'
    #     stateOff: 'icon-ban-circle'
    #   * stateOn: 'icon-heart'
    #     stateOff: 'icon-off'
    # ]

    # Questions
    $scope.questions = [
      * clock: 1
        image: true
        hh: '06'
        mm: '00'
        small: '15'
        big: '60'
        max: '12'
        header: 'Q'
        para:'Can player 1 always win?'
      * clock: 2
        image: true
        hh: '06'
        mm: '00'
        small: '15'
        big: '60'
        max: '12'
        header: 'Q'
        para:'Can player 2 always win?'
      * clock: 3
        image: true
        hh: '06'
        mm: '30'
        small: '20'
        big: '60'
        max: '12'
        header: 'Q'
        para:'Are there any games nobody can win?'
      * clock: 4
        image: true
        hh: '03'
        mm: '40'
        small: '10'
        big: '60'
        max: '12'
        header: 'Q'
        para:'Can I pick a winning start position?'
      * clock: 5
        image: true
        hh: '01'
        mm: '00'
        small: '60'
        big: '60'
        max: '12'
        header: 'Q'
        para:'Does the start time affect who wins?'
      * clock: 6
        image: true
        hh: '01'
        mm: '45'
        small: '02'
        big: '60'
        max: '12'
        header: 'Q'
        para:'How does changing the smallest step affect things?'
      * clock: 7
        image: true
        hh: '09'
        mm: '10'
        small: '10'
        big: '50'
        max: '24'
        header: 'Q'
        para:'How does the computer choose the step buttons to show?'
      * clock: 8
        image: true
        hh: '00'
        mm: '15'
        small: '01'
        big: '60'
        max: '24'
        header: 'Q'
        para:'How does the digital clock affect the game?'
      * clock: 9
        image: true
        hh: '07'
        mm: '32'
        small: '01'
        big: '60'
        max: '24'
        header: 'Q'
        para:'Is there a quick way to work out winning moves?'
      * clock: 10
        image: true
        hh: '02'
        mm: '30'
        small: '15'
        big: '60'
        max: '24'
        header: 'Q'
        para:'Does my quick way always work?'
      * clock: 11
        image: true
        hh: '04'
        mm: '30'
        small: '15'
        big: '60'
        max: '12'
        header: 'Q'
        para:'Can I work out how to win in my head?'
      * clock: 12
        image: true
        hh: '07'
        mm: '15'
        small: '25'
        big: '50'
        max: '12'
        header: 'Q'
        para:'Can I really work it out in my head?'
      * clock: 13
        image: true
        hh: '10'
        mm: '15'
        small: '15'
        big: '60'
        max: '12'
        header: 'Q'
        para:'Would I like to start first or second?'
      * clock: 14
        hh: '09'
        mm: '00'
        small: '15'
        big: '60'
        max: '12'
        header: 'Q'
        para:'Can I invent a similar game with counters instead of times?'
      * clock: 15
        hh: '09'
        mm: '00'
        small: '15'
        big: '60'
        max: '12'
        header: 'Q'
        para:'Can I invent a similar game with numbers instead of times?'
      * clock: 16
        hh: '09'
        mm: '00'
        small: '15'
        big: '60'
        max: '12'
        header: 'Q'
        para:'Are all the games fair?'
      * clock: 17
        hh: '09'
        mm: '00'
        small: '15'
        big: '60'
        max: '12'
        header: 'Q'
        para:'Are some games fair?'
      * clock: 18
        hh: '09'
        mm: '00'
        small: '15'
        big: '60'
        max: '12'
        header: 'Q'
        para:'Is the game fair if we toss a coin to decide who goes first?'
      * clock: 19
        hh: '09'
        mm: '00'
        small: '15'
        big: '60'
        max: '12'
        header: 'Q'
        para:'Is the game fair if we choose a start time using dice?'
      * clock: 20
        hh: '09'
        mm: '00'
        small: '15'
        big: '60'
        max: '12'
        header: 'Q'
        para:'How many moves in the longest game?'
      * clock: 21
        hh: '09'
        mm: '00'
        small: '15'
        big: '60'
        max: '12'
        header: 'Q'
        para:'How many moves in the shortest game?'
      * clock: 22
        hh: '09'
        mm: '00'
        small: '15'
        big: '60'
        max: '12'
        header: 'Q'
        para:'What time is it 1 hour and 15 minutes before midnight?'
      * clock: 23
        hh: '09'
        mm: '00'
        small: '15'
        big: '60'
        max: '12'
        header: 'Q'
        para:'Is this a good game?'
      * clock: 24
        hh: '09'
        mm: '00'
        small: '15'
        big: '60'
        max: '12'
        header: 'Q'
        para:'Is this an interesting game?'
    ]

    key = (qq) -> "clock#{qq.clock}"

    store = (qq) !-> localStorage.setItem key(qq), "#{qq.ups}:#{qq.downs}"

    load = (qq) !->
      stored = localStorage.getItem key(qq)
      qq.downs = null
      if is-type 'String' stored
        [qq.ups, qq.downs] = (stored.split ':').map((n)->~~n)
      unless is-type "Number", qq.downs
        qq.ups = 0
        qq.downs = 0

    getClasses = (qq) ->
      qq.classes = qq.baseClasses ++ if qq.ups > qq.downs
        'interesting'
      else
        if qq.ups < qq.downs
          'uninteresting'
        else
          ''

    for qq in $scope.questions
      qq.baseClasses = ['thumbnail', 'text-center']
      qq.classes = [] ++ qq.baseClasses

      load qq
      qq.classes = getClasses qq

    $scope.hasImage = (qno) ->
      if $scope.questions[qno].image? then true else false

    $scope.isInteresting = (qq) !->
      ++qq.ups
      qq.classes = getClasses qq
      store qq

    $scope.notInteresting = (qq) !->
      ++qq.downs
      qq.classes = getClasses qq
      store qq

    $scope.reset = !->
      for qq in $scope.questions
        qq.ups = 0
        qq.downs = 0
        qq.classes = getClasses qq
        store qq


Stop the Clock
==============

A Nim like game designed to give young children practice in handling time while in a game context.

Step5
-----

In Step4, we were side-tracked by the need to have a game settings panel that could reconfigure the game. Although we can now create and address multiple configurations through different URLs, we still have no game play! Time to remedy that.

1. First let's add a status display to say who's go it is and if anyone has won.

1. In fact we'll split the game status into two fields so we can use colour to flag who's turn it is, and so we can flag gameOver and winner.

1. We change the minute hand turn calculation so it rotates by the full angle implied by both hours and minutes. That way changes to $scope.minutes cause the correct number of turns of the hand.

1. We add an array of buttons coloured by the player colour indicating the available choices. This uses the [ng-repeat directive](http://docs.angularjs.org/api/ng.directive:ngRepeat), and is styled using [bootstrap button](http://getbootstrap.com/2.3.2/base-css.html#buttons) HTML and CSS. These buttons call $scope.step() passing ($index+1). $index is the zero-based index of the repeated element.

1. Changed the title to 'Approaching Midnight' since we are not trying to stop a clock.

1. Discovered the amazingly useful 'pointer-events:none' style parameter and applied it to the clock visualisation. This stops the big rotated hand images from overlaying controls and so rendering them inaccessible, and simplifies the controls CSS. (I was avoiding the problem by using absolute position before.)

1. We change the digital clock so it renders in hh:mm by converting the model $scope.hours and
$scope.minutes to a javascript Date object, and then using angular's date filter. See [Angular's date filter](http://docs.angularjs.org/api/ng.filter:date) and javascript's [Date.parse](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/parse).

1. On testing the digital clock we see that we must ensure that the date time does not exceed 23:59. Also, we need to disable the step controls during the period when the clock has exceeded the target and has yet to revert to its previous time.

1. We started by using the parts of an hour (== the button count) to determine the stepSize, but it would be easier if we always input stepSize and calculate the button count. 

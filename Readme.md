Stop the Clock
==============

A Nim like game designed to give young children practice in handling time while in a game context.

Step4
-----

Connecting the view up to the game model.

For this step we're going to need some user interface widgets. These will mostly come from [`Bootstrap` (v2.3.2 for now)](http://getbootstrap.com/2.3.2/). If we need to use the components that depend on javascript, we'll pull in [`angular-ui/bootstrap`](http://angular-ui.github.io/bootstrap/). At time of writing `angular-ui` had not released stable code for `bootstrap-3`.

1. Let's start by checking that the routeParameters that we tested work in the real app.

   `grunt server` and browse to the urls.

    http://localhost:9000/#/8/30 still goes to 10:30, but
    http://localhost:9000/#/8/30/2 starts at 8:30.

    It seems that unless we use the wildcard URL syntax [it's changing in angular v1.2](http://docs.angularjs.org/guide/migration#syntax-for-named-wildcard-parameters-changed-in), we must provide routes for all likely options
    - i.e. for all options implied by :hh/:mm[/:part[/:max]]. Edited apps.js to do this.

    Commit c1235d48d85eed6474b9af866dfc89d33e47a120

1.  We edit the `app/views/main.html` and wrap the analog and digital clocks in divs with `ng-show="analog"` and `ng-hide="analog"`, and test http://localhost:9000/#/8/30/2/12 and http://localhost:9000/#/8/30/2/24. Both show the analog clock.

    Setting a breakpoint at `app/controllers/main.js` reveals that URL parameters are coming in as strings, but the code tests for numbers. Let's change our tests so the fake routeParameters are all strings, and rework.

    Fake routeParameters become:
    ```
    routeParams = {
      hh: "3"
      mm: "20"
      part: "2"
      max: "24"
    }

    ```

    And we rework function $scope.reset to read these in as numbers. Tests then pass again, and the app now shows an analog or
    digital clock correctly.

    Commit bef5fc4508a102a0b71070d370f95ac4f102e81e

1.  Adding *Change the game* controls.
    
    Introduces a new gameSetup object in the application scope, which is connected to hour and minute inputs (using ng-model) and an analog or digital clock-type checkbox (also using ng-model).

    Note that ng-model references variables via gameSetup so 2-way binding
    is preserved. See [this egghead video](http://egghead.io/lessons/angularjs-the-dot) for an explanation of why this is important.

    There's some trickiness associated with the minute to hour carry that requires us to place a watch on gameSetup.minutes looking for potential carries.

    In the HTML we're making heavy use of Bootstrap classes to control the look and feel.

    The *Change the game* controls are placed inside a `<form>` - which is actually another angular directive. This allows us to place `min` and `max` values on the inputs, and also a `required` attribute to ensure that the form is validated. Try typing in an invalid value - e.g. a decimal, or blanking one of the fields.

    Changed the `reset` function so it reads the new gameSetup settings, and changed the initialisation code so gameSetup is initialised from routeParameters. Tests still pass.

    Commit ff16ca759bdf35fada87699f080b334453166704


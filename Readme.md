Approaching Midnight (alias Stop the Clock)
==============

A Nim like game designed to give young children practice in handling time while in a game context.

See branches Step0 to Step5 for a run-through on building this app.

Usage
-----

This starts a 7 step tutorial in building a simple angular app. It's simple because we are creating an interactivity in a single page, which does not interact with a server, and does not require us to build any custom angular services, filters, or directives. That makes it quite good as an introduction.

A Flash version of the app we want to construct is [published on NRICH](http://nrich.maths.org/content/id/6071/Clock.swf). We're going to make it better using HTML5 and AngularJS. 

To start the app off we're going to use yeoman with the generator published at https://github.com/gmp26/generator-angular-ls to scaffold the application. This is a version of the angular generator customised so it can scaffold a project that uses [Livescript](http://livescript.net/) - a language that compiles into javascript. It's like CoffeScript but better.

NB. This generator is under development and will have changed by the time you read this, so to ensure you have the same version, make sure you checkout the commit `b3763b2`. Later versions will probably work better, so if you start your own project, start with the head of that repo `git checkout master`.

To install the generator in a directory of your choice:

```
git clone https://github.com/gmp26/generator-angular-ls.git # download the generator
cd generator-angular-ls       # make it current
git checkout b3763b2
npm link                # this installs a symbolic link to generator-angular-ls so yeoman can find it
```

Now we can start StopTheClock

```
mkdir StopTheClock      #makes ~/angular/StopTheClock directories
cd StopTheClock         #make it the current directory
yo angular-ls --ls      #scaffold a project in LiveScript.
```

Yeoman will ask 5 questions, to which you can accept the default 'Yes' answer. Use <space> and the down arrow key to switch off the last three options - we won't need `angular-resource`,`cookies`, or `sanitize`. It looks like this:

```
lapc-br1-253:StopTheClock gmp26$ yo angular-ls --ls
[?] Would you like to include Twitter Bootstrap? Yes
[?] Would you like to use the less version of Twitter Bootstrap? Yes
[?] Would you like to use the Bootstrap responsive CSS? Yes
[?] Would you like to include jQuery. (Angular supplies jqLite.) Yes
[?] Would you like to use fontAwesome glyphs in Bootstrap? Yes
  create karma.conf.js
  create karma-e2e.conf.js
[?] Which modules would you like to include? 
⬡ angular-resource.js
⬡ angular-cookies.js
❯⬡ angular-sanitize.js
```

After hitting return for a final time, `yeoman` will create a working skeleton project. In the top level, there will be files called `package.json`, and `bower.json`. These files describe the javascript libraries that are to be installed by `npm` and by `bower`. `Yeoman` will call `npm install` and `bower install` for you, so you will see a lot of network traffic as all these dependencies are pulled in and compiled. `npm` handles the dependencies of the build system, whereas bower handles the dependencies needed by the StopTheClock itself.


Now, if all has gone to plan, you should be able to give the command (still from the StopTheClock directory)
```
grunt server
```

This starts a node web server serving the newly scaffolded app. It also kicks off the Chrome browser looking at
`http://localhost:9000` where the new app is running.

It's possible that you don't have Chrome installed in which case this last step may not work. I'd recommend installing Chrome. Later you can research how to configure the Gruntfile and Karma configuration files to your preferred browser.

Looking at `http://localhost:9000` you should see an 'Allo Allo' message from yeoman in a grey box.
`Control-C` will kill the server off anytime you want.


This is the base app that we'll turn into StopTheClock running from a nodeJS server installed on your local machine.

The result of this stage is published at https://github.com/gmp26/StopTheClock in branch Step0.

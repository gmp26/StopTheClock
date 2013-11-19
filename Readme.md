Stop the Clock
==============

A Nim like game designed to give young children practice in handling time while in a game context.

See branches Step0 to Step5 for a run-through on building this app.

Step 6
-----

I spoke too soon. We *are* going to add another view. The idea is that this app provides a space for mathematically creative questions, and we need a view to seed some questions.

Kick this off by using yeoman to define a new route. This time we'll use the minsafe option since we've already started to worry about publishing and minimising code.

```
yo angular-ls:route quest --ls --minsafe
   invoke   angular-ls:controller:/Users/gmp26/angular/generator-angular-ls/route/index.js
   create     app/scripts/controllers/quest.ls
   create     test/spec/controllers/quest.ls
   invoke   angular-ls:view:/Users/gmp26/angular/generator-angular-ls/route/index.js
   create     app/views/quest.html
``` 

A `grunt test` confirms that we now have one more passing test for the new view. It's testing that the newly created `QuestCtrl` controller has the usual awesome things listed by yeoman.

Using `grunt server`, we should be able to navigate to the new route. Yes - localhost:9000/#/quest
returns a page saying `This is the quest view`. Looks like we can start hacking that view. The idea is that we use the space of games created by the main view to illustrate the questions in the quest view.




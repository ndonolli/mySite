+++
title = "Let the fors flow through you"
date = "2017-05-09T10:38:10-05:00"
draft = true
+++

What's wrong with `var`?  Well, a great many things, but is it really that bad?  Kind of.

I can't find any good reasons where `var` gives you a legitimate advantage over `let` or `const`.  All other major languages use block scoping, and with the ES6 initiative to welcome a new `class` of developers who come from stricter, safer languages, the `var` keyword will only cause confusion.  On top of that, the light restrictions of `const` will enforce better paradigms like functional programming and immutable data structures.

You should absolutely use `let` on for loops to block scope your iterator.  Here's a case where using `var` goes too far:

```javascript
var funcs = [];

for (var i = 0; i < 3; i++) {
  funcs[i] = function() {
    console.log("value of i: " + i);
  }
}

funcs.forEach(func => func.call());

// "value of i: 3"
// "value of i: 3"
// "value of i: 3"
```

Oh snap! Do you see it? That pesky `var` declares `i` as a global variable, so all functions in `func` access it while it is equal to 3.  Wrap it in a function, it still doesn't matter.  "But what about closure?" you ask, believing that each function in func should hold its own `i` in context.  This should be true, and expected since closures are another feature of functional programming languages that allow for techniques like composition.  However, due to the lack of block scope when using `var`, this unfortunately ruins that advantage. Reading this David Shariff's article on the [Javascript Execution Context](http://davidshariff.com/blog/what-is-the-execution-context-in-javascript/) may clear up some things.

Don't `let` yourself be fooled.  `let` and `const` are intended to replace `var`, and while we'll see old code on the web for quite some time, we are responsible for what developers will see in the future.

And of course, as per the code above - all you have to do is use `let`:

```javascript
var funcs = [];

for (let i = 0; i < 3; i++) {
  funcs[i] = function() {
    console.log("value of i: " + i);
  }
}

funcs.forEach(func => func.call());

// "value of i: 0"
// "value of i: 1"
// "value of i: 2"
```

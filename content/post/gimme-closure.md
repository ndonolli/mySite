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

Oh snap! Do you see it?

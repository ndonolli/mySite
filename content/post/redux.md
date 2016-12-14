+++
date = "2016-11-12T18:34:37-06:00"
title = "A Meditation on Redux"

+++

- Thinking about grubbr
- Why we used redux
- Why we used Nativebase
  - Custom components for cross-platform styling, and func
  - Other shit like flow and react routing with redux
- Talk about tech debt with storing state with redux or not

I've been thinking about redux lately.  Everybody and their mother (and my mother) loves redux, and that makes sense.  The redux team *(read: Dan Abramov)* includes philosophical documentation that explain the three noble truths of redux - the main one being that reducers are pure functions of state and action.  With immutable state, your application becomes much more predictable and testable.  If this sounds simple and you are asking why it isn't just incorporated into the design of state-based render libraries like react, it's because it kinda sorta is with flux, a library/design pattern used internally at Facebook of which redux builds upon.

So, really, there's not much to redux.  But developers view it like a god damn necessity. The first page of the docs provides a plea from the creator himself on why you might not need redux. By not using redux, you risk introducing scalability issues as your app grows.  By including redux, you risk wasting time writing boilerplate for your state, actions, and reducers for a view change that could have just been triggered with `setState()`.  The only way to know if you'll need redux is to use it.  And even after using it, I'm still not sure what to think.

But I digress, this is not really about redux. Redux is fantastic. This is about me understanding how to use redux properly.  Let me give you an example: 

+++
date = "2016-11-12T18:34:37-06:00"
title = "A Meditation on Redux"

+++

I've been thinking about Redux lately.  Everybody and their mother (and my mother) loves Redux, and that makes sense.  The Redux team *(read: Dan Abramov)* bestows [philosophical documentation](http://redux.js.org/) that explain the three noble truths of Redux - the main one being that reducers are pure functions of state and action.  With immutable state, your application becomes much more predictable and testable.  If this sounds simple and you are asking why it isn't just incorporated into the design of state-based rendering libraries like React, it's because it kinda sorta is with flux, a library/design pattern used internally at Facebook of which Redux builds upon.

So, really, there's not much to Redux.  But developers view it like a god damn necessity. The first page of the docs provides a plea from the creator himself on why you might not need Redux. By not using Redux, you risk introducing scalability issues as your app grows.  By including Redux, you risk wasting time writing boilerplate for your state, actions, and reducers for a view change that could have just been triggered with `setState()`.  The only way to know if you'll need Redux is to use it.  And even after using it, I'm still not sure what to think.

But I digress, this is not really about Redux. Redux is fantastic. This is about me understanding how to use Redux properly.  Let me give you an example: in building **Grubbr**, a mobile app designed with react-native, we spent a good amount of time including/excluding Redux in our tech stack, flip flopping through the reasons stated above.  Ultimately, our final project architecture was laid out with the help of a react-native boilerplate library called [Nativebase](http://nativebase.io/).  We still structured our codebase from scratch since we intended to use Nativebase primarily as a UI library, but we also kept their custom routing plugin, which was controlled through Redux actions and reducers.

Here was the first potential design flaw of the application: All views were rendered inside this custom navigator component.  Any components that needed to be globally accessible had to have been included in the same tier as the navigator component.  This isn't too bad, and our app was essentially a collection of separate, non-nested views anyway.  But now the traditional method of passing data to child elements through props and state has to be thrown out the window.

This is where Redux kicked ass actually. Say we want a user object that contains their name, id, etc. and is created on login.  The id is used for any kind of POST request so the user object must be globally available to all views. Sure, we could use some cookie that contains some encrypted info, but why not set it simply to state?  With Redux, the global state persists throughout the whole application as a single object that contains state, route, location, etc.

```javascript
function bindAction(dispatch) {
  return {
    openDrawer: () => dispatch(openDrawer()),
    replaceRoute: route => dispatch(replaceRoute(route)),
    pushNewRoute: route => dispatch(pushNewRoute(route)),
    setIndex: index => dispatch(setIndex(index)),
    popRoute: () => dispatch(popRoute()),
    setCurrentDish: dish => dispatch(setCurrentDish(dish)),
    setLocation: location => dispatch(setLocation(location)),
  };
}
function mapStateToProps(state) {
  return {
    name: state.user.name,
    list: state.list.list,
    results: state.search,
    location: state.location.location,
  };
}
export default connect(mapStateToProps, bindAction)(BestInTown);
```

But like all alchemy, one must give up something in order to receive something in return. In our case, we have given up the ease of managing a local state to dictate changes in an individual component's UI.  Here's another example: I wanted to include animations that would occur while the search was being conducted on the page. My normal method would be to set a `loading: false` property in the initial local state, and triggering `setState({ loading: true })` while waiting for the server request to return.  But now I gotta touch three files and create separate actions and reducers for this feature to come to fruition!

So what did I do? I just did it the way I knew how. The 'Redux state' is a separate entity and is accessed through the props (thanks to a function which, believe it or not, is called `mapStateToProps`) so theoretically you can handle both state objects without any fear that they would interfere with each other. The problem is that I felt dirty, like I had broken one of the pillars of the Redux way of truth. Concerns were still separated, with persisting data being held in the 'Redux state' and primarily UI logic being handled thru the local state. But it's all state to consider for the React DOM, and part of me feels like there could have been a better way to reason about things.

But the application worked marvelously, despite my concerns that views seemed to render two or three times too many. And I'll say this - I believe it worked out because, in the end, Redux is a very natural, minimalistic suggestion to handling application state. It is a library, but not by much.  It's more a way of thinking.  Take this example from the article explaining [why you may not need Redux](https://medium.com/@dan_abramov/you-might-not-need-redux-be46360cf367#.9c7c0ared) written by Dan Abramov himself.  He first shows us a typical counter example in react using state:

```javascript

import React, { Component } from 'react';

class Counter extends Component {
  state = { value: 0 };

  increment = () => {
    this.setState(prevState => ({
      value: prevState.value + 1
    }));
  };

  decrement = () => {
    this.setState(prevState => ({
      value: prevState.value - 1
    }));
  };

  render() {
    return (
      <div>
        {this.state.value}
        <button onClick={this.increment}>+</button>
        <button onClick={this.decrement}>-</button>
      </div>
    )
  }
}
```

And then refactors it using actions, reducers, and dispatchers. But there's no Redux installed at all! It's just the design pattern:

```javascript
import React, { Component } from 'react';

const counter = (state = { value: 0 }, action) => {
  switch (action.type) {
    case 'INCREMENT':
      return { value: state.value + 1 };
    case 'DECREMENT':
      return { value: state.value - 1 };
    default:
      return state;
  }
}

class Counter extends Component {
  state = counter(undefined, {});

  dispatch(action) {
    this.setState(prevState => counter(prevState, action));
  }

  increment = () => {
    this.dispatch({ type: 'INCREMENT' });
  };

  decrement = () => {
    this.dispatch({ type: 'DECREMENT' });
  };

  render() {
    return (
      <div>
        {this.state.value}
        <button onClick={this.increment}>+</button>
        <button onClick={this.decrement}>-</button>
      </div>
    )
  }
}
```

So what should you use? Should you use Redux at all? Should you use it all the time? I implore you to meditate on this decision as I have done, and perhaps the wisdom of Dan Abramov will descend upon you. And he shall say 'Yeah, probably'.

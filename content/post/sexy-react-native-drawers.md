+++
date = "2017-04-18T12:52:20-05:00"
title = "Getting Your React Native Drawer to Behave Juuuuuuust Right"

+++

The "native" half of React-native is why so many web developers get so giddy about it.  A technology that binds to native mobile platform APIs on top of the already-popular React library is a welcome addition to the new wave of web-to-mobile solutions, many of which rely on custom components rendered within webkit (which is also still great).  Where React-native shines is that your picker will look like an iOs picker, your buttons will fade that right way when you click it, and the app will just "feel" like a real app.

Is this a reason to make the switch?  Not really.  The importance of having a "native feeling" app weighs on the product owner, and even within react-native, certain components aren't *quite* there yet.

But usually you can make due.  I'm a big fan of [react-native-drawer](https://github.com/root-two/react-native-drawer), which gives you a customizable drawer component akin to the kind you see in many Android apps.  If you start with a boilerplate/generator that includes this package, the drawer will usually render with default settings that (in my opinion) do not mimic the look and feel of a typical Android drawer. The documentation can be a little spacey, so I'll show you the few, small tweaks I make to get this looking right.

Bear with me for a sec - this is how the `<Drawer>` component is rendered using a standard [Ignite](https://github.com/infinitered/ignite) template, a cli-interface generator I like to bootstrap react-native projects with:

```javascript
<Drawer
  ref='navigation'
  type='displace'
  open={state.open}
  onOpen={() => NavigationActions.refresh({key: state.key, open: true})}
  onClose={() => NavigationActions.refresh({key: state.key, open: false})}
  content={<DrawerContent />}
  styles={Styles}
  tapToClose
  openDrawerOffset={0.2}
  panCloseMask={0.2}
  negotiatePan
  tweenHandler={(ratio) => ({
    main: { opacity: Math.max(0.54, 1 - ratio) }
  })}
>
  <DefaultRenderer navigationState={children[0]} onNavigate={this.props.onNavigate} />
</Drawer>
```
The problem I'm addressing has to do with the **animation** of the drawer open/close.  Mainly being:

1. The drawer displaces the screen when opened

2. The screen fades to white, where most native apps fade to black.

3. The tween animation is rough and fast.

All these issues can be solved by passing the right prop values into this component.  Take note:

```javascript
<Drawer
  ref='navigation'
  type='overlay'
  open={state.open}
  onOpen={() => NavigationActions.refresh({key: state.key, open: true})}
  onClose={() => NavigationActions.refresh({key: state.key, open: false})}
  content={<DrawerContent />}
  styles={Styles}
  tapToClose
  openDrawerOffset={0.2}
  panCloseMask={0.2}
  negotiatePan
  tweenHandler={(ratio) => ({
    mainOverlay: {
      opacity: ratio / 2,
      backgroundColor: 'black'
    },
    drawer: {
      shadowRadius: Math.min(ratio * 5 * 5, 5)
    }
  })}
  tweenEasing='easeOutQuint'
  tweenDuration={800}
>
  <DefaultRenderer navigationState={children[0]} onNavigate={this.props.onNavigate} />
</Drawer>
```
First, `type='displace'` can be changed to `type='overlay'` - solving that first issue easily.  The rest can be fixed by editing some of the tween configurations.  The `tweenHandler`, for example, takes a function that manipulates other properties based on the current state of the animation sequence.  With this, we can get our faded black backround, as well as adding a dynamic `shadowRadius` to give a popping effect that the drawer hovers above the screen.  As for the third point, the *actual* tween function can be determined by `tweenEasing`, which takes a string corresponding to one of the functions defined in the [tween-functions](https://github.com/chenglou/tween-functions) package, which comes as a dependency with `react-native-drawer`.

As with the tween-function and other tweaks, you should experiment to find the drawer that fits your fancy. But never settle for less.


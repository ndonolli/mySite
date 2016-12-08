+++
date = "2016-10-08T14:31:20-06:00"
title = "Working with geolocation on a non-secure site"

+++

The last couple of days, our small development team **BrutSoft** was working on some legacy code written by our friend Harvey for his app "Pick-up". It is a simple web-app that organizes pick-up soccer games, sending out texts through Twilio's SMS service. We wanted to expand this app to work on a mobile platform through the Ionic framework, add an authentication service, and extra geolocation features.

I opted to implement the geolocation features, initially utilizing the HTML5 native `navigator.geolocation` API to grab the user's location data and search for active games within a 10km radius. It was only after I had deployed the app that I learned that [Google has discontinued support for geolocation on non-secure domains](https://developers.google.com/web/updates/2016/04/geolocation-on-secure-contexts-only). Not wanting to deal with obtaining a SSL certificate, I quickly scrambled to find a new solution.

**Disclaimer:** I am in no way against Google's decision to promote a safer web by requiring SSL certification for sensitive user information like geolocation. The beauty of the web is that many solutions exist and, so long as the web remains open, many problems will be solved and shared. This post is about one solution I found that worked for me.

Not interested in changing the codebase dramatically, I started searching for a third-party API that offered geolocation services. I settled on [ipinfo.io](http://ipinfo.io) which is a light, RESTful service and offers 1000 free API calls per day. There are many more that would probably work fine and I encourage further research, but I was sold on the simplicity of using this service. My original code wrapped the `getCurrentPosition()` method in a promise, and then sent the game request on resolve.

```javascript
getLocation: function() {
  var options = {
    enableHighAccuracy: true,
    timeout: 5000,
    maximumAge: 0
  };

  return new Promise(function(resolve, reject) {
    navigator.geolocation.getCurrentPosition(resolve, reject, options);
  });
},
```

The `getCurrentPosition` method is an asynchronous call, which necessitates the Promise wrapper in order to wait for the location to return before attaching it to the game request object, which is handled by an Angular controller.  Among the deprecation of this method for non-secure sites, there are a couple other things that are annoying:

1. The browser will ask the user to grant the application permission to know their GPS location.  From a UX standpoint, this is not really ideal.  The native chrome alert box that pops up could seem a tad sketchy and insecure to some users, even if they were aware that the app used location to function.  It would be much better to ask for permission or inform the user through the app itself.

2. If a user denies permission to reveal their location, whether on purpose or by accident, there is no way to reset this through the application.  The permissions are stored within the browser and there is no simple way to check, through your application, if a user has denied or granted geolocation permissions.  To the application, the `getLocation` function will just timeout.

By using *ipinfo.io* there is no need to ask permission, which in my opinion is redundant considering the app is very clear about how it uses user's locations.  It is one less thing to worry about on the user experience end and several lines of code shorter for the developer who should not have to worry about handling that extra logic.

The `getLocation` helper function was thus refactored to...

```javascript
getLocation: function() {
  return new Promise(function(resolve, reject) {
    $.getJSON('https://ipinfo.io/geo', resolve);
  });
},
```

...which honestly isn't that much different.  The return JSON data is mostly similar to how the Chrome geolocation object is structured, so just minor tweaks to the controller allowed this new code to fit in just dandily.

```javascript
// ...
.controller('TimeSelectController', function($scope, $location, GameReq, sharedProps) {
  var gameReq = {};
  $scope.findingLocation = false;

  $scope.requestGame = function() {
    console.log('requesting Game');
    $scope.findingLocation = true;
    helpers.getLocation()
    .then(function(response) {
      var loc = response.loc.split(',');
      gameReq.location = {
        latitude: +loc[0],
        longitude: +loc[1],
      };
      gameReq.time = helpers.createGameTime($scope.data.selectedOption.hour);
      gameReq.smsNum = $scope.smsNum;
      gameReq.sport = $scope.sportInput;

      GameReq.requestGame(gameReq)
        // etc...      
    })
  }
})
// ...
```

Remember, *ipinfo.io* is one just one of many sites that offer geolocation as a service.  Find what works best for you if there comes a time where you can't/don't want to use the native geolocation features built into Chrome.

<h1 align="center">
  <br>
  The Places App
  <br>
</h1>

<h4 align="center">See places from all over the world. A simple app built with <a href="https://flutter.dev/" target="_blank">Flutter</a>.</h4>

<p align="center">
  <a href="https://github.com/AjinkyaASK/the_places_app">
    <!-- <img src="#"
         alt="Flutter"> -->
  </a>
</p>
<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#download">Download</a> •
  <a href="#credits">Credits</a> •
  <a href="#related">Related</a> •
  <a href="#license">License</a>
</p>

## Key Features

* The Places App is a simple application built with Flutter, that showcases different places from all over the world, lets you pick your favorites and see them later (in offline mode too!).
* Dark/Light mode (Coming Soon)
* Cross platform (Web, iOS, Android and Linux)

## Screenshots
Note: Screenshots are somewhat outdated due to the recent changes in design. Getting udpated soon.
<br>
<br>
<img src="https://raw.githubusercontent.com/AjinkyaASK/the_places_app/master/screenshots/the_places_app_screenshot_auth.png" width='250px'
         alt="Screenshots">
<img src="https://raw.githubusercontent.com/AjinkyaASK/the_places_app/master/screenshots/the_places_app_screenshot_home.png" width='250px'
         alt="Screenshots">
<img src="https://raw.githubusercontent.com/AjinkyaASK/the_places_app/master/screenshots/the_places_app_screenshot_user.png" width='250px'
         alt="Screenshots">
<img src="https://raw.githubusercontent.com/AjinkyaASK/the_places_app/master/screenshots/the_places_app_screenshot_guest.png" width='250px'
         alt="Screenshots">         
<img src="https://raw.githubusercontent.com/AjinkyaASK/the_places_app/master/screenshots/the_places_app_screenshot_drawer.png" width='250px'
         alt="Screenshots">
<img src="https://raw.githubusercontent.com/AjinkyaASK/the_places_app/master/screenshots/the_places_app_screenshot_drawer_tile_dismiss.png" width='250px'
         alt="Screenshots">         
<img src="https://raw.githubusercontent.com/AjinkyaASK/the_places_app/master/screenshots/the_places_app_screenshot_details.png" width='250px'
         alt="Screenshots">      
<img src="https://raw.githubusercontent.com/AjinkyaASK/the_places_app/master/screenshots/the_places_app_screenshot_fav.png" width='250px'
         alt="Screenshots">  
<img src="https://raw.githubusercontent.com/AjinkyaASK/the_places_app/master/screenshots/the_places_app_screenshot_remove.png" width='250px'
         alt="Screenshots"> 
<img src="https://raw.githubusercontent.com/AjinkyaASK/the_places_app/master/screenshots/the_places_app_screenshot_splash.png" width='250px'
         alt="Screenshots">     
             
## Download the source code
You can [download](https://github.com/AjinkyaASK/the_places_app/) this repository and use it free for your own purposes.


## Prerequisites
- Flutter SDK: >2.0
- Dart SDK: >2.12

## How To Setup
- [Firebase Setup](https://firebase.google.com/docs/flutter/setup)
- [Facebook Login Setup](https://developers.facebook.com/docs/facebook-login/)
- [Make sure you have Flutter SDK >2.0 and Null Safety enabled]
- [Download the dependencies and place your Firebase config files in place]
- [Done]

## Dependencies and Libraries
This software uses the following API and packages:
- [Locations API](https://hiveword.com/papi/random/locationNames)
- [HTTP](https://pub.dev/packages/http)
- [Provider (For State Management)](https://pub.dev/packages/provider)
- [Cached Network Image](https://pub.dev/packages/cached_network_image)
- [Cupurtino Icons](https://pub.dev/packages/cupertino_icons)
- [Equatable](https://pub.dev/packages/equatable)
- [Dartz (For Functional Programming Based Error Management)](https://pub.dev/packages/dartz)
- [Hive (As a Local Database)](https://pub.dev/packages/hive)
- [Firebase Core](https://pub.dev/packages/firebase_core)
- [Firebase Auth](https://pub.dev/packages/firebase_auth)
- [Google Sign In (Interface for Google Sign In API)](https://pub.dev/packages/google_sign_in)
- [Flutter Facebook Auth (As a Interface for Facebook Sign In API)](https://pub.dev/packages/flutter_facebook_auth)
- [URL Launcher (For launching urls into external apps)](https://pub.dev/packages/url_launcher)
- [Palette Generator](https://pub.dev/packages/palette_generator)
- [Build Runner (Dev Dependency)](https://pub.dev/packages/build_runner)
- [Hive Generator (Dev Dependency)](https://pub.dev/packages/hive_generator)
- [Mockito (Dev Dependency)](https://pub.dev/packages/mockito)

## Asumptions and other details
- Added some extra stuff as below
  - Interactive Fullscreen Image Viewer: Opens image in a interactive (zoom and pan gestures) image viewer
  - Profile Details Dialog: A popup dialog that display user's name, email and profie avatar with an option to signout
  - Details view that shows details of the page on a dedicated screen
  - Option to Sign in as a guest: Allows user to sign in without any identification, this has no limitation on features
  - Integrated a NoSQL local database (Hive) for storing user and favorite place details
- The pictures for places are not actual ones and are taken from a randome pictures API (https://picsum.photos/) which returns random picture of given size everytime
- These pictures are cached with a unique key, making a place to always have a specific image once cached
- Favorite places feature uses Local Database only (the data stored is associated with the local device only and not the cloud)
- Local database coded to be wiped out completely on sign out (making the favorite places to vanish)
- App supports three ways of signing in, two social sign ins (using Google and Facebook) and and a Guest sign in.
- 'Sign in as a Guest' option to allows user to sign in without any identification, this has no limitation on features
- Instead of being in End Drawer, the 'Signout' option is placed in the profile details popup (I thought it is better suitable place for it)
- The end drawer shows list of favorite places, each list tile is dismissable. (user can swipe it east-west to remove a place from favorites)
- Home screen shows vertically stacked list of cards containing place details from API
- Swiping west-east on a card marks it as favorite and removes it from the list, while swiping the other way just removes the card from stack
- These cards need to swiped atleast ~80% off the screen to be considered for an event, if left before reaching the threshold, the card regains its position in the stack
- Cards on home screen have two buttons (favorite and maps) as shown in the screenshots provided. Map button opens the location in google maps and favorite button marks the page as favorites and removes from the list
- The views are designed considering only the portrait mode and touch enabled devices (not for pointer or keyboard driven devices)
- The details screen has icon that shows in Pink color if place is a favorite
- Details screen also has map and wiki button
- Clicking on the picture on details screen opens the picture in interactive full screen preview
- 
## Credits
- To Team Flutter
- Google and Facebook for providing us with easy Sign In APIs
- To all developers for creating the various usefull dependencies and libraries used in this project
- The Hive Word API
- Lorem Picsum API for their great free service
- Github for the free Git platform

## Support
Coming Soon

## You may also like...
- [Covid-19 Tracker App](https://github.com/AjinkyaASK/covid19_tracker_restapi)
- [The Movies App](https://github.com/AjinkyaASK/themoviesapp)
- [Word Match App](https://github.com/AjinkyaASK/word_match)
- More coming Soon

## License

NA

---

> GitHub [@AjinkyaASK](https://github.com/AjinkyaASK) &nbsp;&middot;&nbsp;
> CodePen [@ajinkya-karanjikar](https://codepen.io/ajinkya-karanjikar)
> LinkedIn [@ajinkyakaranjikar](https://in.linkedin.com/in/ajinkyakaranjikar)
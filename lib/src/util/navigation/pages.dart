///[Pages] contains all named routes and their path
class Pages {
  ///[home] is the initial route of the application
  static const String home = '/';

  ///[authentication] is the sign in screen
  static const String authentication = '/auth';

  ///[placesShowcase] is the landing page after signing in that shows all places
  static const String placesShowcase = '/places';

  ///[placeDetails] is the detail view of a place
  static const String placeDetails = '/place-details';

  ///[fullScreenImageView] is the view that shows full screen view of an network image
  static const String fullScreenImageView = '/fullscreen-image-view';
}

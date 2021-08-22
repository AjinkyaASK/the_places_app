class PlacesApi {
  ///[url] is the url of the places API
  static const String url = 'https://hiveword.com/papi/random/locationNames';

  ///[radmomPictureUrl] is the url of dummy picture
  static const String radmomPictureUrl = 'https://picsum.photos/720/1280';

  static final _PlacesApiLabels labels = _PlacesApiLabels();
}

class _PlacesApiLabels {
  final String id = 'id';
  final String state = 'state';
  final String name = 'name';
  final String asciiName = 'asciiName';
  final String country = 'country';
  final String countryShort = 'countryDigraph';
  final String wikipediaLink = 'wikipediaLink';
  final String googleMapsLink = 'googleMapsLink';
}

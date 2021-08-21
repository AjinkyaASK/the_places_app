class PlacesApi {
  static const String url = 'https://hiveword.com/papi/random/locationNames';

  static const String dummyPictureUrl = 'https://picsum.photos/720/1280';

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

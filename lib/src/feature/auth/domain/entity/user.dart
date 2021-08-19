abstract class PlacesAppUserBase {
  PlacesAppUserBase({
    required this.isGuest,
    required this.name,
    required this.pictureUrl,
  });

  final bool isGuest;
  final String name;
  final String pictureUrl;
}

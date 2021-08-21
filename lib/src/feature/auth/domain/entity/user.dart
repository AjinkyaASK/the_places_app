abstract class PlacesAppUserBase {
  PlacesAppUserBase({
    required this.isGuest,
    required this.name,
    required this.pictureUrl,
    this.email,
  });

  final bool isGuest;
  final String name;
  final String? email;
  final String pictureUrl;
}

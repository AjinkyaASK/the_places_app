import '../../domain/entity/user.dart';

class PlacesAppUser extends PlacesAppUserBase {
  PlacesAppUser({
    required final String name,
    required final String pictureUrl,
    final bool isGuest = false,
  }) : super(
          name: name,
          pictureUrl: pictureUrl,
          isGuest: isGuest,
        );

  factory PlacesAppUser.fromMap(Map<String, dynamic> data) {
    return PlacesAppUser(
      name: data['name'],
      pictureUrl: data['picture_url'],
      isGuest: data['is_guest'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'picture_url': pictureUrl,
      'is_guest': isGuest,
    };
  }
}

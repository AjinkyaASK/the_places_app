import '../../../../core/exception/general_exception.dart';

import '../../core/auth_database_keys.dart';
import '../../domain/entity/user.dart';

///[PlacesAppUser] is used as a class for user
class PlacesAppUser extends PlacesAppUserBase {
  PlacesAppUser(
      {required final String name,
      required final String pictureUrl,
      final bool isGuest = false,
      final String? email})
      : super(
          name: name,
          pictureUrl: pictureUrl,
          isGuest: isGuest,
          email: email,
        );

  ///[PlacesAppUser.fromMap] takes an object of [Map<String, dynamic>]
  ///and returns an initialized bject of this class
  ///throws exceptino of type [GeneralException] if any mandatory argument
  ///is not present in the given map
  factory PlacesAppUser.fromMap(Map<String, dynamic> data) {
    assert(
        data.containsKey(AuthLocalDatabaseKeys.name) &&
            data[AuthLocalDatabaseKeys.name].isNotEmpty,
        GeneralException(
          source: 'PlacesAppUser',
          message: 'name is empty or does not exist in the data',
        ));
    assert(
        data.containsKey(AuthLocalDatabaseKeys.pictureUrl) &&
            data[AuthLocalDatabaseKeys.pictureUrl].isNotEmpty,
        GeneralException(
          source: 'PlacesAppUser',
          message: 'pictureUrl is empty or does not exist in the data',
        ));

    if (!data.containsKey(AuthLocalDatabaseKeys.name) ||
        data[AuthLocalDatabaseKeys.name].toString().isEmpty)
      throw GeneralException(
        source: 'PlacesAppUser',
        message: 'name is empty or does not exist in the data',
      );
    if (!data.containsKey(AuthLocalDatabaseKeys.pictureUrl) ||
        data[AuthLocalDatabaseKeys.pictureUrl].toString().isEmpty)
      throw GeneralException(
        source: 'PlacesAppUser',
        message: 'pictureUrl is empty or does not exist in the data',
      );

    return PlacesAppUser(
      name: data[AuthLocalDatabaseKeys.name],
      pictureUrl: data[AuthLocalDatabaseKeys.pictureUrl],
      isGuest: data[AuthLocalDatabaseKeys.isGuest] ?? false,
      email: data[AuthLocalDatabaseKeys.email],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AuthLocalDatabaseKeys.name: name,
      AuthLocalDatabaseKeys.pictureUrl: pictureUrl,
      AuthLocalDatabaseKeys.isGuest: isGuest,
      AuthLocalDatabaseKeys.email: email,
    };
  }
}

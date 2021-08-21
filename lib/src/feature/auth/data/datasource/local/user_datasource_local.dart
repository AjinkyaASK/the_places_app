import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../core/exception/general_exception.dart';
import '../../../core/auth_database_keys.dart';
import '../../../domain/entity/datasource.dart';

///[UserDatasourceLocal] is the datasource for local database
class UserDatasourceLocal implements UserDatasource {
  static const String _userBoxLabel = 'user_box_hive';
  static late final Box<dynamic> _userBox;

  ///[init] method initializes the [_userBox] object and opens makes it ready for connection
  static Future<void> init() async {
    try {
      _userBox = await Hive.openBox<dynamic>(_userBoxLabel);
      if (_userBox.isOpen) if (!_userBox
          .containsKey(AuthLocalDatabaseKeys.guestSignedIn))
        await _userBox.put(AuthLocalDatabaseKeys.guestSignedIn, false);
    } catch (error) {
      //TODO: Handle this error in better way
      print('Initialization error: Error while opening places box: $error');
    }
  }

  ///[dispose] method closes the [_userBox]
  static Future<void> dispose() async {
    if (_userBox.isOpen)
      await _userBox.close();
    else
      throw GeneralException(
        source: 'UserDatasourceLocal',
        message:
            'Initialization error: Did you called init() before calling this?',
      );
  }

  ///[_initializationCheck] method checks if the box is open and throws error if it is not
  void _initializationCheck() {
    //TODO: Handle this error in better way
    if (!_userBox.isOpen)
      throw GeneralException(
        source: 'UserDatasourceLocal',
        message:
            'Initialization error: Did you called init() before calling this?',
      );
  }

  ///[get] method returns value of given key stored in local database
  ///throws error when the key is not present in the box
  @override
  dynamic get(String key) {
    _initializationCheck();

    if (_userBox.containsKey(key))
      return _userBox.get(key);
    else
      throw GeneralException(
        source: 'UserDatasourceLocal',
        message: 'Key not found',
      );
  }

  ///[set] method stores given pair of key and value in the local database
  @override
  Future<void> set({required String key, required value}) async {
    _initializationCheck();
    return await _userBox.put(key, value);
  }
}

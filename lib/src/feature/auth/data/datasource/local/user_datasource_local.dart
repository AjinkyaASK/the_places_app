import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../core/exception/general_exception.dart';
import '../../../core/local_database_keys.dart';
import '../../../domain/entity/datasource.dart';

class UserDatasourceLocal implements UserDatasource {
  static const String _userBoxLabel = 'user_box_hive';
  static late final Box<dynamic> _userBox;

  static Future<void> init() async {
    try {
      _userBox = await Hive.openBox<dynamic>(_userBoxLabel);
      if (_userBox.isOpen) if (!_userBox
          .containsKey(UserLocalDatabaseKeys.guestSignedIn))
        await _userBox.put(UserLocalDatabaseKeys.guestSignedIn, false);
    } catch (error) {
      //TODO: Handle this error in better way
      print('Initialization error: Error while opening places box: $error');
    }
  }

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

  @override
  dynamic get(String key) {
    if (_userBox.isOpen) if (_userBox.containsKey(key))
      return _userBox.get(key);
    else
      throw GeneralException(
        source: 'UserDatasourceLocal',
        message: 'Key not found',
      );
    else
      throw GeneralException(
        source: 'UserDatasourceLocal',
        message:
            'Initialization error: Did you called init() before calling this?',
      );
  }

  @override
  Future<void> set({required String key, required value}) async {
    if (_userBox.isOpen)
      return await _userBox.put(key, value);
    else
      throw GeneralException(
        source: 'UserDatasourceLocal',
        message:
            'Initialization error: Did you called init() before calling this?',
      );
  }
}

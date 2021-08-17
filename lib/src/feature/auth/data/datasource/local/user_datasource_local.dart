import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../core/exception/general_exception.dart';
import '../../../domain/entity/datasource.dart';

class UserDatasourceLocal implements UserDatasource {
  static const String _userBoxLabel = 'user_box_hive';
  static late final Box<dynamic> _userBox;

  static Future<void> init() async {
    try {
      _userBox = await Hive.openBox<dynamic>(_userBoxLabel);
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
  Future<dynamic> get(String key) async {}

  @override
  Future<void> set({required String key, required value}) async {}
}

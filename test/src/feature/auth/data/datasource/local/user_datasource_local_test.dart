import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:the_places_app/src/core/exception/general_exception.dart';
import 'package:the_places_app/src/feature/auth/data/datasource/local/user_datasource_local.dart';
import 'package:the_places_app/src/feature/auth/domain/entity/datasource.dart';

Future<void> main() async {
  await Hive.initFlutter();

  test('Making sure the class extends its intended parent class', () {
    expect(
      UserDatasourceLocal() is UserDatasource,
      true,
    );
  });

  test('Given call to init, When it executes, Then no error is thrown',
      () async {
    // Arrange
    // Act
    // Assert
    expect(
      () async => await UserDatasourceLocal.init(),
      returnsNormally,
    );
  });

  test(
      'Given call to get with a key, when the key does not exist in the database, then it throws object of type GeneralException',
      () async {
    // Arrange
    const String keyThatDoesNotExist = 'key_that_does_not_exist';
    //Making sure the box is open
    await UserDatasourceLocal.init();
    final UserDatasourceLocal userDatasourceLocal = UserDatasourceLocal();
    // Act
    // Assert
    expect(
      () async => await userDatasourceLocal.get(keyThatDoesNotExist),
      throwsA(
        isA<GeneralException>(),
      ),
    );
  });

  test(
      'Given call to set with a key and a value, when the box is open, then it executes and returns normally',
      () async {
    // Arrange
    const String keyToStoreForTest = 'key_to_store_for_test';
    const String valueToStoreForTest = 'value_to_store_for_test';
    //Making sure the box is open
    await UserDatasourceLocal.init();
    final UserDatasourceLocal userDatasourceLocal = UserDatasourceLocal();
    // Act
    // Assert
    expect(
      () async => await userDatasourceLocal.set(
        key: keyToStoreForTest,
        value: valueToStoreForTest,
      ),
      returnsNormally,
    );
  });

  test(
      'Given call to get with a key, when the key exists in the box, then it returns its value',
      () async {
    // Arrange
    const String keyToStoreForTest = 'key_to_store_for_test';
    const String valueToStoreForTest = 'value_to_store_for_test';
    await UserDatasourceLocal.init(); //Making sure the box is open
    final UserDatasourceLocal userDatasourceLocal = UserDatasourceLocal();

    // Act
    await userDatasourceLocal.set(
      key: keyToStoreForTest,
      value: valueToStoreForTest,
    ); // Setting value
    final storedValue =
        await userDatasourceLocal.get(keyToStoreForTest); // Fetching value set

    // Assert
    expect(
      storedValue,
      equals(valueToStoreForTest),
    );
  });
}

abstract class UserDatasource {
  dynamic get(String key);
  Future<void> set({
    required String key,
    required dynamic value,
  });
}

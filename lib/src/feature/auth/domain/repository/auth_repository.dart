import '../entity/datasource.dart';
import '../entity/user.dart';

abstract class AuthRepositoryBase {
  AuthRepositoryBase(this.datasource);

  final UserDatasource datasource;

  Future<PlacesAppUserBase?> signInWithGoogle(
      {required void Function(String message) onAuthFailure});
  Future<PlacesAppUserBase?> signInWithFacebook(
      {required void Function(String message) onAuthFailure});
  Future<PlacesAppUserBase?> signInWithTwitter();
  Future<PlacesAppUserBase> signInAsGuest();
  Future<void> signOut();
}

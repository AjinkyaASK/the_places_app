import 'package:dartz/dartz.dart';

import '../../../../core/exception/exception.dart';
import '../../../../core/exception/general_exception.dart';
import '../../../../core/usecase/usecase_base.dart';
import '../entity/user.dart';
import '../repository/auth_repository.dart';

class SignInWithFacebookUseCase
    implements UsecaseBase<Either<Exception, PlacesAppUserBase?>> {
  SignInWithFacebookUseCase(this.repository);

  final AuthRepositoryBase repository;

  @override
  Future<Either<Exception, PlacesAppUserBase?>> call(
      {void Function(String)? onAuthFailure}) async {
    try {
      final user = await repository.signInWithFacebook(
        onAuthFailure: onAuthFailure ??
            (message) {
              print('Sign in failed');
            },
      );
      return Right(user);
    } catch (error) {
      return Left(GeneralException(
        source: 'source',
        message: 'Error signing in with Facebook',
      ));
    }
  }
}

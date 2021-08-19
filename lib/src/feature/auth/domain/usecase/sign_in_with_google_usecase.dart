import 'package:dartz/dartz.dart';

import '../../../../core/exception/exception.dart';
import '../../../../core/exception/general_exception.dart';
import '../../../../core/usecase/usecase_base.dart';
import '../entity/user.dart';
import '../repository/auth_repository.dart';

class SignInWithGoogleUseCase
    implements UsecaseBase<Either<Exception, PlacesAppUserBase?>> {
  SignInWithGoogleUseCase(this.repository);

  final AuthRepositoryBase repository;

  @override
  Future<Either<Exception, PlacesAppUserBase?>> call(
      {void Function(String)? onAuthFailure}) async {
    try {
      final result = await repository.signInWithGoogle(
        onAuthFailure: onAuthFailure ??
            (message) {
              print('Sign in failed');
            },
      );
      return Right(result);
    } catch (error) {
      return Left(GeneralException(
        source: 'source',
        message: 'Error signing in as a guest',
      ));
    }
  }
}

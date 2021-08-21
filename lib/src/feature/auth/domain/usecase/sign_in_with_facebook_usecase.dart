import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../core/exception/exception.dart';
import '../../../../core/exception/general_exception.dart';
import '../../../../core/usecase/usecase_base.dart';
import '../entity/user.dart';
import '../repository/auth_repository.dart';

///[SignInWithFacebookUseCase] signs in the user with Facebook
///returns object of type `PlacesAppUserBase`
///or object of [GeneralException] if something is wrong
class SignInWithFacebookUseCase
    implements UsecaseBase<Either<Exception, PlacesAppUserBase?>> {
  SignInWithFacebookUseCase(this.repository);

  final AuthRepositoryBase repository;

  @override
  Future<Either<Exception, PlacesAppUserBase?>> call(
      {void Function(String)? onAuthFailure}) async {
    try {
      //Calling repository method [signInWithFacebook] to initiate sign in process
      final user = await repository.signInWithFacebook(
        onAuthFailure: onAuthFailure ??
            (message) {
              log('Sign in failed');
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

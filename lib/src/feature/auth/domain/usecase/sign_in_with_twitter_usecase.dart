import 'package:dartz/dartz.dart';

import '../../../../core/exception/exception.dart';
import '../../../../core/exception/general_exception.dart';
import '../../../../core/usecase/usecase_base.dart';
import '../entity/user.dart';
import '../repository/auth_repository.dart';

class SignInWithTwitterUseCase
    implements UsecaseBase<Either<Exception, PlacesAppUserBase?>> {
  SignInWithTwitterUseCase(this.repository);

  final AuthRepositoryBase repository;

  @override
  Future<Either<Exception, PlacesAppUserBase?>> call() async {
    try {
      final user = await repository.signInWithTwitter();
      return Right(user);
    } catch (error) {
      return Left(GeneralException(
        source: 'source',
        message: 'Error signing in with Twitter',
      ));
    }
  }
}

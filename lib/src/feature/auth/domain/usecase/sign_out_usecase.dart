import 'package:dartz/dartz.dart';

import '../../../../core/exception/exception.dart';
import '../../../../core/exception/general_exception.dart';
import '../../../../core/usecase/usecase_base.dart';
import '../repository/auth_repository.dart';

class SignOutUseCase implements UsecaseBase<Either<Exception, void>> {
  SignOutUseCase(this.repository);

  final AuthRepositoryBase repository;

  @override
  Future<Either<Exception, void>> call() async {
    try {
      await repository.signOut();
      return Right(null);
    } on GeneralException catch (exception) {
      return Left(exception);
    } catch (error) {
      return Left(GeneralException(
        source: 'SignOutUseCase',
        message: 'Error signing out. Try again.',
      ));
    }
  }
}

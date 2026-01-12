import 'package:fpdart/fpdart.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/user_repository.dart';

class GoogleLogin implements UseCase<UserEntity, NoParams> {
  final UserRepository userRepository;

  GoogleLogin(this.userRepository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await userRepository.loginWithGoogle();
  }
}

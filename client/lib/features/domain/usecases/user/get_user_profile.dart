import 'package:fpdart/fpdart.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/user_repository.dart';

class GetUserProfile implements UseCase<UserEntity, NoParams> {
  final UserRepository userRepository;

  GetUserProfile(this.userRepository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await userRepository.getUserProfile();
  }
}

import 'package:fpdart/fpdart.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/user_repository.dart';

class CurrentUser implements UseCase<UserEntity, NoParams> {
  final UserRepository userRepository;

  CurrentUser(this.userRepository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await userRepository.currentUser();
  }
}

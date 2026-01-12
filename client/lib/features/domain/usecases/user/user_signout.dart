import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/user_repository.dart';

class UserSignOut implements UseCase<Unit, NoParams> {
  final UserRepository userRepository;

  UserSignOut(this.userRepository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params){
    return userRepository.signOut();
  }
}

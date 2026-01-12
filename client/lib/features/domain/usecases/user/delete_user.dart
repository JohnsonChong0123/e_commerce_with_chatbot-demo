import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/user_repository.dart';

class DeleteUser implements UseCase<Unit, NoParams> {
  final UserRepository userRepository;

  DeleteUser(this.userRepository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await userRepository.deleteUser();
  }
}

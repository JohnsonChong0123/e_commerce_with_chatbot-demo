import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/user_repository.dart';

class ForgetPassword implements UseCase<Unit, ForgetPasswordParams> {
  final UserRepository userRepository;

  ForgetPassword(this.userRepository);

  @override
  Future<Either<Failure, Unit>> call(ForgetPasswordParams params) async {
    return await userRepository.forgetPassword(email: params.email);
  }
}

class ForgetPasswordParams extends Equatable {
  final String email;

  const ForgetPasswordParams({
    required this.email,
  });
  
  @override
  List<Object?> get props => [email];

  
}

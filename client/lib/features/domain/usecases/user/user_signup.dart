import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/user_repository.dart';

class UserSignUp implements UseCase<Unit, UserSignUpParams> {
  final UserRepository userRepository;
  const UserSignUp(this.userRepository);

  @override
  Future<Either<Failure, Unit>> call(UserSignUpParams params) {
    return userRepository.signUpWithEmailPassword(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      password: params.password,
      phone: params.phone,
    );
  }
}

class UserSignUpParams extends Equatable {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;

  const UserSignUpParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });
  
  @override
  List<Object?> get props => [email, password, firstName, lastName, phone];
}

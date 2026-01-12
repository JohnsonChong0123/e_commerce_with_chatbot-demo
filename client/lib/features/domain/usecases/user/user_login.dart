import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/user_repository.dart';

class UserLogin implements UseCase<UserEntity, UserLoginParams> {
  final UserRepository userRepository;

  const UserLogin(this.userRepository);
  @override
  Future<Either<Failure, UserEntity>> call(UserLoginParams params) {
    return userRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams extends Equatable {
  final String email;
  final String password;

  const UserLoginParams({required this.email, required this.password});
  
  @override
  List<Object?> get props => [email, password];
}

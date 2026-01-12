import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/user_repository.dart';

class ChangePassword implements UseCase<void, ChangePasswordParams> {
  final UserRepository userRepository;

  ChangePassword(this.userRepository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    return await userRepository.changePassword(
      oldPassword: params.oldPassword,
      newPassword: params.newPassword,
    );
  }
}

class ChangePasswordParams extends Equatable {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

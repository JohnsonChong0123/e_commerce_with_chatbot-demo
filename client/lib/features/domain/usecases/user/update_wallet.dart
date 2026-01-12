import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/user_repository.dart';

class UpdateUserWallet implements UseCase<Unit, UpdateUserWalletParams> {
  final UserRepository userRepository;

  UpdateUserWallet(this.userRepository);

  @override
  Future<Either<Failure, Unit>> call(UpdateUserWalletParams params) async {
    return await userRepository.updateUserWallet(
      amount: params.amount,
    );
  }
}

class UpdateUserWalletParams extends Equatable {
  final double amount;

  const UpdateUserWalletParams({
    required this.amount,
  });

  @override
  List<Object?> get props => [amount];
}

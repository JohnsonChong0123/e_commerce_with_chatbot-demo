import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/user_repository.dart';

class UpdateUserAddress implements UseCase<Unit, UpdateUserAddressParams> {
  final UserRepository userRepository;

  UpdateUserAddress(this.userRepository);

  @override
  Future<Either<Failure, Unit>> call(UpdateUserAddressParams params) async {
    return await userRepository.updateUserAddress(
      address: params.address,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

class UpdateUserAddressParams extends Equatable {
  final String address;
  final double latitude;
  final double longitude;

  const UpdateUserAddressParams({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
  
  @override
  List<Object?> get props => [address, latitude, longitude];
}

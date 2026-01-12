import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/location_repository.dart';

class GetAddressFromLatLng implements UseCase<String?, AddressParams> {
  final LocationRepository locationRepository;

  GetAddressFromLatLng(this.locationRepository);

  @override
  Future<Either<Failure, String?>> call(AddressParams params) async {
    return await locationRepository.getAddressFromLatLng(params.latitude, params.longitude);
  }
}

class AddressParams extends Equatable {
  final double latitude;
  final double longitude;

  const AddressParams({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

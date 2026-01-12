import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../entity/location_entity.dart';
import '../../repository/location_repository.dart';

class GetCurrentLocation implements UseCase<LocationEntity, NoParams> {
  final LocationRepository locationRepository;

  GetCurrentLocation(this.locationRepository);

  @override
  Future<Either<Failure, LocationEntity>> call(NoParams params) async {
    return await locationRepository.getCurrentLocation();
  }
}
import 'package:fpdart/fpdart.dart';
import '../../../core/errors/exception.dart';
import '../../../core/errors/failure.dart';
import '../../domain/entity/location_entity.dart';
import '../../domain/repository/location_repository.dart';
import '../sources/remote/location_remote_data.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteData locationRemoteData;

  LocationRepositoryImpl(this.locationRemoteData);

  @override
  Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
    try {
      final currentlocation = await locationRemoteData.getCurrentLocation();
      return right(currentlocation);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String?>> getAddressFromLatLng(
      double latitude, double longitude) async {
    try {
      final address =
          await locationRemoteData.getAddressFromLatLng(latitude, longitude);
      return right(address);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, LocationEntity>> getUserLocation() async {
    try {
      final address = await locationRemoteData.getUserLocation();
      return right(address);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

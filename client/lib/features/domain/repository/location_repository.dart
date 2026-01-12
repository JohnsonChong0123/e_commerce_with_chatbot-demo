import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failure.dart';
import '../entity/location_entity.dart';

abstract class LocationRepository {
  Future<Either<Failure, LocationEntity>> getCurrentLocation();
  Future<Either<Failure, String?>> getAddressFromLatLng(double latitude, double longitude);
  Future<Either<Failure, LocationEntity>> getUserLocation();
}
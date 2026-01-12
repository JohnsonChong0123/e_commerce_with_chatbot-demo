import '../../domain/entity/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.latitude,
    required super.longitude,
    super.address,
  });
}
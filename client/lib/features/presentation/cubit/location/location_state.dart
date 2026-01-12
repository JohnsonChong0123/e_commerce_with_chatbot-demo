part of 'location_cubit.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final LatLng location;
  final String address;

  LocationLoaded({
    required this.location,
    required this.address,
  });
}

class LocationFailure extends LocationState {
  final String message;

  LocationFailure(this.message);
}
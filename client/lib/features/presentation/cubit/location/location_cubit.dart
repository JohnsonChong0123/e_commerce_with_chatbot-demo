import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/location/get_address_latlng.dart';
import '../../../domain/usecases/location/get_current_location.dart';
import '../../../domain/usecases/location/get_user_location.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final GetCurrentLocation _getCurrentLocation;
  final GetAddressFromLatLng _getAddressFromLatLng;
  final GetUserLocation _getUserLocation;

  LocationCubit({
    required GetCurrentLocation getCurrentLocation,
    required GetAddressFromLatLng getAddressFromLatLng,
    required GetUserLocation getUserLocation,
  })  : _getAddressFromLatLng = getAddressFromLatLng,
        _getCurrentLocation = getCurrentLocation,
        _getUserLocation = getUserLocation,
        super(LocationInitial());

  Future<void> loadUserLocation() async {
    emit(LocationLoading());
    final res = await _getUserLocation(
      NoParams(),
    );
    res.fold(
      (l) => emit(LocationFailure(l.message)),
      (r) => emit(LocationLoaded(
        location: LatLng(r.latitude ?? 0.0, r.longitude ?? 0.0),
        address: r.address ?? 'Address not found',
      )),
    );
  }

  Future<void> loadCurrentLocation() async {
    emit(LocationLoading());
    final res = await _getCurrentLocation(NoParams());
    res.fold(
      (l) => emit(LocationFailure(l.message)),
      (r) => emit(LocationLoaded(
        location: LatLng(r.latitude!, r.longitude!),
        address: r.address ?? 'Address not found',
      )),
    );
  }

  Future<void> updateLocation(LatLng newLocation) async {
    emit(LocationLoading());
    final res = await _getAddressFromLatLng(AddressParams(
      latitude: newLocation.latitude,
      longitude: newLocation.longitude,
    ));
    res.fold(
      (l) => emit(LocationFailure(l.message)),
      (r) => emit(LocationLoaded(
        location: newLocation,
        address: r ?? 'Address not found',
      )),
    );
  }
}

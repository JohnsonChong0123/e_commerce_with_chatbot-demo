import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/common/utils/show_snackbar.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../../../core/theme/app_colors.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../cubit/location/location_cubit.dart';
import '../../cubit/profile/profile_cubit.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;

class LocationScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const LocationScreen());
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  GoogleMapController? mapController;
  @override
  Widget build(BuildContext context) {
    context.read<LocationCubit>().loadUserLocation();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Loader();
          } else if (state is LocationLoaded) {
            ll.LatLng from = state.location;

            gmap.LatLng toGoogleLatLng(ll.LatLng p) {
              return gmap.LatLng(p.latitude, p.longitude);
            }

            return Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  onTap: (LatLng position) {
                    final latlongLatLng = ll.LatLng(
                      position.latitude,
                      position.longitude,
                    );
                    context.read<LocationCubit>().updateLocation(latlongLatLng);
                  },

                  initialCameraPosition: CameraPosition(
                    target: toGoogleLatLng(from),
                    zoom: 13,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('selectedLocation'),
                      position: toGoogleLatLng(from),
                    ),
                  },
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                ),
                if (state.address.isNotEmpty)
                  Positioned(
                    top: 80,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      child: Text(
                        state.address,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                Positioned(
                  top: 200,
                  right: 20,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: AppColor.green,
                    onPressed: () async {
                      context.read<LocationCubit>().loadCurrentLocation();
                    },
                    child: const Icon(Icons.my_location, color: Colors.white),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 60,
                  child: BlocConsumer<ProfileBloc, ProfileUpdateState>(
                    listener: (context, state) {
                      if (state is ProfileUpdateAddressSuccess) {
                        context.read<ProfileCubit>().loadProfile();
                        Navigator.pop(context);
                        showSnackBar(context, state.message);
                      } else if (state is ProfileUpdateAddressFailure) {
                        showSnackBar(context, state.message);
                      }
                    },
                    builder: (context, profileState) {
                      if (profileState is ProfileUpdateLoading) {
                        return const Loader();
                      }
                      return AppButton(
                        onPressed: () async {
                          context.read<ProfileBloc>().add(
                            ProfileUpdateAddress(
                              address: state.address,
                              latitude: state.location.latitude,
                              longitude: state.location.longitude,
                            ),
                          );
                        },
                        title: 'Confirm Location',
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is LocationFailure) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}

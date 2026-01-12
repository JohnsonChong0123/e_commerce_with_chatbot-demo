import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../core/common/utils/firebase_util.dart';
import '../../../../core/errors/exception.dart';
import '../../models/location_model.dart';

abstract interface class LocationRemoteData {
  Future<LocationModel> getCurrentLocation();
  Future<String?> getAddressFromLatLng(double latitude, double longitude);
  Future<LocationModel> getUserLocation();
}

class LocationRemoteDataImpl implements LocationRemoteData {
  @override
  Future<LocationModel> getCurrentLocation() async {
    try {
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        throw const ServerException('Location permissions are denied');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final address = await getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      return LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<String?> getAddressFromLatLng(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json'
        '?latlng=$latitude,$longitude'
        '&key=key',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' &&
            data['results'] != null &&
            data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address'];
        } else {
          print('Geocoding failed: ${data['status']}');
          return null;
        }
      }

      switch (response.statusCode) {
        case 400:
          print('Bad Request');
          break;
        case 401:
          print('Unauthorized');
          break;
        case 403:
          print('Forbidden - check API key / billing');
          break;
        case 429:
          print('Too Many Requests');
          break;
        case 500:
          print('Server Error');
          break;
        default:
          print('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
    return null;
  }

  @override
  Future<LocationModel> getUserLocation() async {
    try {
      final userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .get();

      if (!userData.exists) {
        throw Exception('User data not found');
      }

      final data = userData.data();

      return LocationModel(
        latitude: data?['userLatitude'],
        longitude: data?['userLongitude'],
        address: data?['userAddress'],
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<bool> _handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
    }
    return true;
  }
}

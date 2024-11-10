// lib/services/geolocation_service.dart

import 'package:geolocator/geolocator.dart';

class GeolocationService {
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return null;
    }

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, // Adjust accuracy here as needed
      distanceFilter: 10, // Update location every 10 meters
    );
    // When permissions are granted, get the current position
    try {
      // Position position = await Geolocator.getCurrentPosition(
      //     desiredAccuracy: LocationAccuracy.high);
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
      return position;
    } catch (e) {
      print('Error fetching location: $e');
      return null;
    }
  }
}

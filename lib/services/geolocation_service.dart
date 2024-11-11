import 'package:geolocator/geolocator.dart';

class GeolocationService {
Stream<Position> getPositionStream() {
  LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 1, // Update when moved 1 meter
  );
  return Geolocator.getPositionStream(locationSettings: locationSettings);
}


  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Error fetching location: $e');
      return null;
    }
  }
}

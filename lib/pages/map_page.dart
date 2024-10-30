import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wuct/pages/loading.dart';
import 'package:wuct/services/geolocation_service.dart';
import 'package:wuct/shared/custom_app_bar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  LatLng _defaultPosition = const LatLng(-33.86, 151.20); // Default location to load the map
  LatLng? _currentPosition;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchLocation(); // Start fetching the location after map load
    print('initState: Starting location fetch');
  }

  Future<void> _fetchLocation() async {
    setState(() {
      isLoading = true;
    });
    print('_fetchLocation: Fetching location...');
    
    try {
      Position? position = await GeolocationService().getCurrentPosition();
      if (position != null) {
        _currentPosition = LatLng(position.latitude, position.longitude);
        print('_fetchLocation: Current position fetched: $_currentPosition');

        // Move the camera to the user's current location if mapController is initialized
        if (mapController != null) {
          print('_fetchLocation: mapController available, animating camera to $_currentPosition');
          mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(_currentPosition!, 15.0),
          );
        }
      } else {
        print('_fetchLocation: Location is null, popping navigator');
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error in _fetchLocation: $e');
    }

    setState(() {
      isLoading = false;
    });
    print('_fetchLocation: Location fetch complete, isLoading set to false');
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    print('_onMapCreated: Map controller initialized');

    // Move the camera if location is fetched after map is created
    if (_currentPosition != null) {
      print('_onMapCreated: Current position available, animating camera to $_currentPosition');
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 15.0),
      );
    } else {
      print('_onMapCreated: No current position yet');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build: Current position: $_currentPosition');
    
    return Scaffold(
      appBar: CustomAppBar(label: 'Maps'),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _defaultPosition,
              zoom: 11.0,
            ),
            markers: _currentPosition != null
                ? {
                    Marker(
                      markerId: const MarkerId("current_location"),
                      position: _currentPosition!,
                      infoWindow: const InfoWindow(title: "You are here"),
                    )
                  }
                : {},
          ),
          if (isLoading)
            const Center(
              child: Loading(), // Show loading indicator while fetching location
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_currentPosition != null && mapController != null) {
            print('FloatingActionButton: Manually animating camera to $_currentPosition');
            await mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(_currentPosition!, 15.0),
            );
          } else {
            print('FloatingActionButton: mapController or currentPosition is null');
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

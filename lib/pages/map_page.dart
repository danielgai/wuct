import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wuct/shared/custom_app_bar.dart';
import 'package:wuct/pages/map_menu_page.dart'; // Import MapMenuPage

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  final LatLng _defaultPosition = const LatLng(-33.86, 151.20);
  LatLng? _currentPosition;
  double _currentZoom = 17.0; // Default zoom level

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _updateCurrentLocation();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  Future<void> _updateCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      Position? position = await Geolocator.getCurrentPosition();
      if (position != null) {
        _currentPosition = LatLng(position.latitude, position.longitude);

        if (mapController != null) {
          // Use the current zoom level to animate the camera
          mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(_currentPosition!, _currentZoom),
          );
        }
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    if (_currentPosition != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, _currentZoom),
      );
    }
  }

  // This function updates `_currentZoom` whenever the camera moves
  void _onCameraMove(CameraPosition position) {
    _currentZoom = position.zoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        label: 'Maps',
        withHamburger: true,
        onHamburgerPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const MapMenuPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0); // Slide in from right
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        },
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            onCameraMove: _onCameraMove, // Updates zoom level on camera move
            initialCameraPosition: CameraPosition(
              target: _defaultPosition,
              zoom: _currentZoom,
            ),
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

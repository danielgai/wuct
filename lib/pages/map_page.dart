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
  LatLng? _currentPosition; // User's current position
  String? _searchedPositionName;
  LatLng? _searchedPosition; // Position selected from the search menu
  double _currentZoom = 17.0; // Default zoom level

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _updateCurrentLocation(); // Fetch current location immediately
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
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_currentPosition!, _currentZoom),
        );
      }
    } catch (e) {
      print('Error fetching location: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // Animate camera to the current position when the map is ready
    if (_currentPosition != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, _currentZoom),
      );
    }
  }

  void _onCameraMove(CameraPosition position) {
    _currentZoom = position.zoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        label: 'Maps',
        withHamburger: true,
        onHamburgerPressed: () async {
          final result = await Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const MapMenuPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0); // Slide in from right
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );

          // Handle the selected position returned from MapMenuPage
          if (result != null && result is List) {
            setState(() {
              _searchedPosition = result[0];
              _searchedPositionName = result[1];
              _currentZoom = 19; //zoom in more
            });

            mapController?.animateCamera(
              CameraUpdate.newLatLngZoom(_searchedPosition!, _currentZoom),
            );
          }
        },
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            onCameraMove: _onCameraMove, // Updates zoom level on camera move
            initialCameraPosition: CameraPosition(
              target: _currentPosition ?? _defaultPosition,
              zoom: _currentZoom,
            ),
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            markers: _buildMarkers(_searchedPositionName ?? ""),
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

  Set<Marker> _buildMarkers(String searchedPositionName) {
    final markers = <Marker>{};

    if (_searchedPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('searched_position'),
          position: _searchedPosition!,
          infoWindow: InfoWindow(
            title: searchedPositionName.isNotEmpty
                ? searchedPositionName
                : "Searched Location",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
    return markers;
  }
}

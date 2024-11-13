import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:wuct/shared/custom_app_bar.dart';

class LatLngTween extends Tween<LatLng> {
  LatLngTween({super.begin, super.end});

  @override
  LatLng lerp(double t) => LatLng(
        ui.lerpDouble(begin!.latitude, end!.latitude, t)!,
        ui.lerpDouble(begin!.longitude, end!.longitude, t)!,
      );
}

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
      appBar: CustomAppBar(label: 'Maps'),
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

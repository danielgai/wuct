import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wuct/pages/loading.dart';
import 'package:wuct/services/geolocation_service.dart';
import 'package:wuct/shared/custom_app_bar.dart';
import 'dart:ui' as ui;

class LatLngTween extends Tween<LatLng> {
  LatLngTween({LatLng? begin, LatLng? end}) : super(begin: begin, end: end);

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

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  GoogleMapController? mapController;
  final LatLng _defaultPosition = const LatLng(-33.86, 151.20);
  LatLng? _currentPosition;
  bool isLoading = false;
  bool _isFirstLocation = true;

  static const double _smoothZoom = 17.0;

  late StreamSubscription<Position> _positionStreamSubscription;
  late AnimationController _animationController;
  Animation<LatLng>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _positionStreamSubscription.cancel();
    mapController?.dispose();
    super.dispose();
  }

  void _startLocationUpdates() {
    _positionStreamSubscription =
        GeolocationService().getPositionStream().listen((Position position) {
      final newPosition = LatLng(position.latitude, position.longitude);

      if (_currentPosition != null) {
        _animateToPosition(_currentPosition!, newPosition);
      } else {
        _currentPosition = newPosition;
        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(newPosition, _smoothZoom),
          );
        }
      }
    });
  }

  void _animateToPosition(LatLng from, LatLng to) {
    double distance = Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );

    // Set a minimum and maximum duration
    int duration = (distance * 10).clamp(500, 2000).toInt();

    _animationController.duration = Duration(milliseconds: duration);
    _animationController.reset();

    _animation = LatLngTween(begin: from, end: to).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    _animation!.addListener(() {
      mapController?.moveCamera(
        CameraUpdate.newLatLng(_animation!.value),
      );
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _currentPosition = to;
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentPosition != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, _smoothZoom),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
          ),
          if (isLoading)
            const Center(
              child: Loading(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_currentPosition != null && mapController != null) {
            await mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(_currentPosition!, _smoothZoom),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

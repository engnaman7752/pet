// location_finder.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationFinderScreen extends StatefulWidget {
  const LocationFinderScreen({super.key});

  @override
  _LocationFinderScreenState createState() => _LocationFinderScreenState();
}

class _LocationFinderScreenState extends State<LocationFinderScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final MarkerId _markerId = const MarkerId("current_location");

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled.
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied.')));
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Finder')),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: _markerId,
            position: _currentPosition!,
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        },
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _determinePosition,
        tooltip: 'Refresh Location',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

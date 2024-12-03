/*import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  LocationScreen({required this.latitude, required this.longitude});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    // LatLng from the passed arguments
    final LatLng location = LatLng(widget.latitude, widget.longitude);

    return Scaffold(
      appBar: AppBar(title: Text('Location')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: location,
          zoom: 14.0, // Set the zoom level
        ),
        markers: {
          Marker(
            markerId: MarkerId('marker_1'),
            position: location,
            infoWindow: InfoWindow(
              title: 'Selected Location',
              snippet: 'This is the location from the booking.',
            ),
          ),
        },
      ),
    );
  }
}
*/

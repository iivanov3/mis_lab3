import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapClass extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String locationName;

  const MapClass(
      {required this.latitude,
      required this.longitude,
      required this.locationName});

  @override
  State<MapClass> createState() => _MapClassState();
}

class _MapClassState extends State<MapClass> {
  late GoogleMapController googleMapController;

  void _onMapCreated(GoogleMapController googleMapController) {
    googleMapController = this.googleMapController;
  }

  void _openGoogleMaps() async {
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=${widget.latitude},${widget.longitude}";

    if (await canLaunchUrlString(googleMapsUrl)) {
      await launchUrlString(googleMapsUrl);
    } else {
      throw Exception("Could not launch google maps.");
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng _center = LatLng(widget.latitude, widget.longitude);
    String location = widget.locationName;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Location for exam'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(location),
                  position: _center,
                ),
              },
            ),
          ),
          Center(
            child: SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: _openGoogleMaps,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text(
                  'Open in Google Maps',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_map/flutter_map.dart';

class Gmaps extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Gmaps> {

  late final CameraPosition _initialPosition ;

  @override
  void initState() {
    super.initState();

    // Obtenemos la posición actual del dispositivo.
    Geolocator.getCurrentPosition().then((position) {
      setState(() {
        // Convertimos la posición en LatLng.
        _initialPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _initialPosition,
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

// ignore: constant_identifier_names
const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoicGF0cmlrLXYxNiIsImEiOiJjbHhhanU4OGQxbjg0Mmtvamp5cnU0aGo0In0.6vWOIb4LSw6U65vYpXHeCg';

class HotMapScreen extends StatefulWidget {
  final double latitud = 0.00012;
  final double longitud = 0.00001;

  @override
  State<HotMapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<HotMapScreen> {
  LatLng? myPosition;
  List<Marker> marcadores = [];

  @override
  void initState() {
    super.initState();
    getLocation(widget.latitud, widget.longitud);
    // Llamar a obtenerUbicaciones() después de obtener la ubicación actual
    obtenerUbicaciones();
  }

  Future<void> obtenerUbicaciones() async {
    // Obtener una referencia a la colección 'denuncias'
    final firestore = FirebaseFirestore.instance;
    final referenciaColeccion = firestore.collection('denuncias');

    // Recuperar todos los documentos de la colección
    final querySnapshot = await referenciaColeccion.get();

    // Limpiar la lista de marcadores antes de agregar nuevos marcadores
    marcadores.clear();

    // Procesar cada documento
    for (final documento in querySnapshot.docs) {
      // Obtener los campos latitud y longitud (manejar la ausencia potencial)
      double latitud = documento.get('latitud');
      double longitud = documento.get('longitud');

      if (latitud != 0 && longitud != 0) {
        // Crear un objeto LatLng a partir de la latitud y longitud recuperadas
        final posicionMarcador = LatLng(latitud, longitud);

        // Opcionalmente personalizar la apariencia del marcador (considerar las preferencias del usuario)
        final marcador = Marker(
          point: posicionMarcador,
          builder: (context) => Container(
            child: const Icon(
              Icons.location_on, // Considerar usar un icono más específico
              color: Colors.greenAccent, // Considerar la preferencia del usuario para el color
              size: 40,
            ),
          ),
        );

        // Agregar el marcador a la lista
        marcadores.add(marcador);
      }
    }

    // Actualizar la lista de 'marcadores' en tu estado o widget (reemplazar con tu configuración)
    setState(() {
      this.marcadores = marcadores; // Suponiendo que 'marcadores' es una variable de estado
    });
  }

  Future<void> getLocation(double latitud, double longitud) async {
    final position = await determinePosition();
    setState(() {
      myPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mapa de Reportes'),
        backgroundColor: Colors.blueAccent,
      ),
      body: myPosition == null
          ? const CircularProgressIndicator()
          : FlutterMap(
              options: MapOptions(
                center: myPosition,
                minZoom: 5,
                maxZoom: 25,
                zoom: 18,
              ),
              nonRotatedChildren: [
                TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                  additionalOptions: const {
                    'accessToken': MAPBOX_ACCESS_TOKEN,
                    'id': 'mapbox/streets-v12',
                  },
                ),
                MarkerLayer(
                  markers: marcadores, // Usa la lista de marcadores poblada
                ),
              ],
            ),
    );
  }
}


 
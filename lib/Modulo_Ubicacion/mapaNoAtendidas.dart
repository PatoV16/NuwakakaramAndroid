import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nuwakakaram/Modulo_Admin/mostrarNoAtendidos.dart';

// ignore: constant_identifier_names
const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoicGl0bWFjIiwiYSI6ImNsY3BpeWxuczJhOTEzbnBlaW5vcnNwNzMifQ.ncTzM4bW-jpq-hUFutnR1g';

class ClodMapScreen extends StatefulWidget {
  final double latitud = 0.00012;
  final double longitud = 0.00001;

  @override
  State<ClodMapScreen> createState() => _CMapScreenState();
}

class _CMapScreenState extends State<ClodMapScreen> {
  LatLng? myPosition;
  List<Marker> marcadores = [];

  @override
  void initState() {
    super.initState();
    getLocation(widget.latitud, widget.longitud);
    // Llamar a obtenerUbicaciones() después de obtener la ubicación actual
    obtenerUbicaciones();
  }
  
void _mostrarMensaje(BuildContext context, cadena, uid) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("¿Está seguro que desea atender esta denuncia?"),
      content: Text(cadena),
      actions: [
        TextButton(
          child: Text("Atender"),
          onPressed: () {
            handleAccount(uid, context);
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
  Future<void> obtenerUbicaciones() async {
  // Obtener una referencia a la colección 'denuncias'
  final firestore = FirebaseFirestore.instance;
  final referenciaColeccion = firestore.collection('denuncias');

  // Realizar una consulta para obtener solo los documentos con estado_denuncia igual a 'NO_ATENDIDO'
  final querySnapshot = await referenciaColeccion.where('estado_denuncia', isEqualTo: 'NO ATENDIDO').get();

  // Limpiar la lista de marcadores antes de agregar nuevos marcadores
  marcadores.clear();

  // Procesar cada documento
  for (final documento in querySnapshot.docs) {
    // Obtener los campos latitud y longitud (manejar la ausencia potencial)
    double latitud = documento.get('latitud');
    double longitud = documento.get('longitud');
 String nombre = documento.get('nombre');
  String apellido = documento.get('apellido');
  String nombreCompleto = '$nombre $apellido';
  String uid = documento.get('UID');
    if (latitud != 0 && longitud != 0) {
      // Crear un objeto LatLng a partir de la latitud y longitud recuperadas
      final posicionMarcador = LatLng(latitud, longitud);

      // Opcionalmente personalizar la apariencia del marcador (considerar las preferencias del usuario)
      final marcador = Marker(
  point: posicionMarcador,
  builder: (context) => GestureDetector(
    onTap: () {
      _mostrarMensaje(context, nombreCompleto, uid); // Función para mostrar el mensaje
    },
    child: Stack(
      children: [
        Container( // Contenedor para el icono
          child: Icon(
            Icons.location_on, // Considerar usar un icono más específico
            color: Colors.redAccent, // Considerar la preferencia del usuario para el color
            size: 40,
          ),
        ),
      ],
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
        title: const Text('Denuncias no Atendidas'),
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


 /*
  GestureDetector(
    onTap: () { // Función a ejecutar al tocar el marcador
      _mostrarMensaje(context); // Ejemplo de función para mostrar el mensaje
    },
    child: Stack( // Mantener la estructura Stack para el icono y el texto
      children: [
        // ... (Icono y texto como antes)
      ],
    ),
  ), 

  */
   Future<void> handleAccount( uid, BuildContext context) async {
    
     // Accedemos a la colección de denuncias en Firestore
  final denunciasRef = FirebaseFirestore.instance.collection('denuncias');

  // Filtramos los documentos donde 'UID' sea igual al valor especificado
  final query = denunciasRef.where('UID', isEqualTo: uid);

  // Obtenemos los documentos coincidentes
  final querySnapshot = await query.get();

  // Recorremos cada documento coincidente y actualizamos el estado
  for (final doc in querySnapshot.docs) {
    await doc.reference.update({
      'estado_denuncia': 'ATENDIDO',
    });
  
  }
  }
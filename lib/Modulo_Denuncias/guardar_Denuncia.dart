// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nuwakakaram/Modulo_Ubicacion/geolocator.dart';

final String? uid = FirebaseAuth.instance.currentUser?.uid;

Future<DocumentSnapshot> buscarUsuario(String uid) async {
  CollectionReference usuarios =
      FirebaseFirestore.instance.collection('usuarios');
  QuerySnapshot usuariosEncontrados =
      await usuarios.where('UID', isEqualTo: uid).get();
  DocumentSnapshot usuario = usuariosEncontrados.docs.first;
  return usuario;
}

DocumentSnapshot documento =
    buscarUsuario(uid.toString()) as DocumentSnapshot<Object?>;
// Esta función utiliza el documento "DocumentSnapshot" para extraer los datos
// "nombre", "apellido", "cedula", "telefono", "correo", "direccion", "descripcion".

/////////
Future<Map<String, dynamic>> obtenerDatosUsuario(
  context,
  DocumentSnapshot documento,
  var direccion,
  String descripcion,
  recipiente,
  String hora,
) async {
  // Obtenemos los datos del documento.
  Map<String, dynamic> usuario = documento.data()! as Map<String, dynamic>;
  Position position = await determinePosition();
  double latitud = position.latitude;
  double longitud = position.longitude;
  // Creamos un nuevo mapa con los datos que necesitamos.
  Map<String, dynamic> datosUsuario = {
    'nombre': usuario['Nombres'],
    'apellido': usuario['Apellidos'],
    'cedula': usuario['cedula'],
    'telefono': usuario['Telefono'],
    'correo': usuario['Correo'],
    'latitud': latitud,
    'longitud': longitud,
    'descripcion': descripcion,
    'UID': uid.toString(),
    'Hora': hora,
    'estado_denuncia': 'NO ATENDIDO'
  };
  CollectionReference denuncias =
      FirebaseFirestore.instance.collection('denuncias');
  DocumentReference document = denuncias.doc(datosUsuario['uid']);

  // Agregamos los datos del usuario al documento.
  await document.set(datosUsuario);

  return datosUsuario;
}

Future<void> mostrarMensaje(BuildContext context, String mensaje) async {
  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text('Mensaje'),
        content: Text(mensaje),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}




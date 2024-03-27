// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nuwakakaram/Modulo_Usuario/home.dart';

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

  // Creamos un nuevo mapa con los datos que necesitamos.
  Map<String, dynamic> datosUsuario = {
    'nombre': usuario['Nombres'],
    'apellido': usuario['Apellidos'],
    'cedula': usuario['cedula'],
    'telefono': usuario['Telefono'],
    'correo': usuario['Correo'],
    'direccion': direccion,
    'descripcion': descripcion.toString(),
    'UID': uid.toString(),
    'Hora': hora,
  };
  CollectionReference denuncias =
      FirebaseFirestore.instance.collection('denuncias');
  DocumentReference document = denuncias.doc(datosUsuario['uid']);

  // Agregamos los datos del usuario al documento.
  await document.set(datosUsuario);

  // Formateamos los datos del usuario como una cadena de texto.
  String datosUsuarioTexto = '''
    Nombre: ${datosUsuario['nombre']}
    Apellido: ${datosUsuario['apellido']}
    Cedula: ${datosUsuario['cedula']}
    Teléfono: ${datosUsuario['telefono']}
    Correo: ${datosUsuario['correo']}
    Dirección: ${datosUsuario['direccion']}
    Descripción: ${datosUsuario['descripcion']}
    UID: ${datosUsuario['UID']}
    FechaRegistro: ${datosUsuario['Hora']}''';
  enviarCorreo(recipiente, datosUsuario);
  // Devolvemos el mapa con los datos.

  return datosUsuario;
}

Future<void> mostrarMensaje(BuildContext context, String mensaje) async {
  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Mensaje'),
        content: Text(mensaje),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Aceptar'),
          ),
        ],
      );
    },
  );
}

Future<void> enviarCorreo(String recipiente, mensaje) async {
  String usuario = 'patrik59.pv@gmail.com';
  String contrasena = 'vlvo zsjd cldy yqfd';
  final smtpServer = gmail(usuario, contrasena);
  final message = Message()
    ..from = Address(usuario, 'mail')
    ..recipients.add(recipiente)
    ..subject = 'test'
    ..text = 'Message: $mensaje';
  try {
    await send(message, smtpServer);
    print('correo enviado');
  } catch (e) {
    print(e.toString());
  }
}

void enviarWhatsapp() async {
  String telefono = "+593998286593";
  String mensaje = "ahora tambien envia whatsapp";

  String url =
      "whatsapp://send?phone=$telefono&text=${Uri.encodeComponent(mensaje)}";

  try {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('No se pudo lanzar la URL: $url');
    }
  } catch (e) {
    print('Error al lanzar la URL: $e');
  }
}

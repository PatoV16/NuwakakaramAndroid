import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nuwakakaram/main.dart';

import '../logicaLogin.dart';

var UID;
// Esta función guarda los datos en una colección llamada `usuarios` en Firestore.
Future<void> guardarDatos(String cedula, String firstName, String lastName,
    String correo, String password, String telefono, context) async {
  final firestore = FirebaseFirestore.instance;
  try {
    // Usa el método set para guardar los datos en Firebase Auth.
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: generarCorreoElectronico(cedula),
      password: password,
    );

    // El usuario se ha registrado exitosamente
    User? user = userCredential.user;
    UID = user?.uid;

    // Despliega un cuadro de texto con el UID del usuario
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Usuario registrado'),
          content: Text('El usuario ha sido registrado con UID: ${user?.uid}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage(title: 'Iniciar Sesión')));
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  } catch (error) {
    // Ocurrió un error durante el registro de usuario
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error al registrar el usuario'),
          content: Text('El usuario no se ha podido registrar: $error'),
          actions: [
            TextButton(
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
  Map<String, dynamic> data = {
    'Nombres': firstName,
    'Apellidos': lastName,
    'Correo': correo,
    'Telefono': telefono,
    'Contraseña': password,
    'cedula': cedula,
    'UID': UID,
    'Tipo': 'usuario',
    'imageURL': 'null',
    'pdfURL': 'null'
  };

  // Utiliza try-catch para manejar cualquier excepción que pueda ocurrir al intentar guardar los datos.
  try {
    // Usa el método set para guardar los datos en Firestore.
    await firestore.collection('usuarios').add(data);
    print('Los datos se guardaron correctamente');
    //crearCarpeta(cedula);
  } catch (error) {
    print('No se pudo guardar los datos');
  }
}


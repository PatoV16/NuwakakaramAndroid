import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nuwakakaram/login.dart';

String UID = '';
Map<String, dynamic> data = {};
// Esta función guarda los datos en una colección llamada `usuarios` en Firestore.
Future<bool> existeUsuario(String cedula) async {
  // Obtener la referencia a la colección
  final coleccion = FirebaseFirestore.instance.collection('usuarios');

  // Crear la consulta
  final consulta = coleccion.where('cedula', isEqualTo: cedula);

  // Obtener el documento
  final snapshot = await consulta.get();

  // Retornar true si el documento existe, false si no
  return snapshot.docs.isNotEmpty;
}

Future<String> creaeUserAuth(String correo, password) async {
  // Crear usuario en Firebase Auth
  UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: correo,
    password: password,
  );
  User? user = userCredential.user;
  UID = user!.uid;
  return UID;
}

//----------------------------------------------------------------
Future<void> guardarDatos(String cedula, String firstName, String lastName,
    String correo, String password, String telefono, context) async {
  final firestore = FirebaseFirestore.instance;
  // Verificar si el usuario ya existe
  if (await existeUsuario(cedula) == true) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error al registrar el usuario'),
          content: const Text('Ya existe un usuario con la misma cédula.'),
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
  }else {
    
     UID = await creaeUserAuth(correo, password);
    // Guardar datos en Firestore
    data = {
      'Nombres': firstName,
      'Apellidos': lastName,
      'Correo': correo,
      'Telefono': telefono,
      'Contraseña': password,
      'cedula': cedula,
      'UID': UID,
      'Tipo': 'usuario',
      'imageURL': 'null',
      'pdfURL': 'null',
      'estado': 'null',
    };
    await firestore.collection('usuarios').add(data);
   
  // Mostrar mensaje de éxito
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Usuario registrado'),
        content: const Text('El usuario ha sido registrado con éxito'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                           MyHomePage()));
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}
    
  }
  bool validarCedulaEcuatoriana(String cedula) {
    if (cedula.length != 10) {
      return false; // La cédula debe tener 10 dígitos
    }

    int suma = 0;
    for (int i = 0; i < 9; i++) {
      int digito = int.parse(cedula[i]);
      int multiplicador = (i % 2 == 0) ? 2 : 1;
      int resultado = digito * multiplicador;
      suma += (resultado >= 10) ? resultado - 9 : resultado;
    }

    int residuo = suma % 10;
    int digitoVerificador = int.parse(cedula[9]);

    return (residuo == 0 && digitoVerificador == 0) ||
        (10 - residuo == digitoVerificador);
  } 

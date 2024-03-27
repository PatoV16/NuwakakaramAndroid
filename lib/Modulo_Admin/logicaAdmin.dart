import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nuwakakaram/logicaLogin.dart';

var UID_admin = '';
final _formKey = GlobalKey<FormState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

void registrarDatos(
    _firstName, _lastName, _password, _cedula, _occupation, context) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: generarCorreoElectronico(_cedula),
      password: _password,
    );

    // El usuario se ha registrado exitosamente
    User? user = userCredential.user;
    UID_admin = user!.uid;

    // Despliega un cuadro de texto con el UID del usuario
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Registrar usuario'),
          content: Text('El usuario ha sido registrado con UID: ${user.uid}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
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
          title: Text('Error al registrar el usuario'),
          content: Text('El usuario no se ha podido registrar: $error'),
          actions: [
            TextButton(
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
  try {
    // Crea un mapa con los datos a guardar en Firestore
    Map<String, dynamic> userData = {
      'nombre': _firstName,
      'apellido': _lastName,
      'contraseña': _password,
      'cédula': _cedula,
      'ocupación': _occupation,
      'Tipo': 'admin',
      'UID': UID_admin,
    };

    // Guarda los datos en Firestore
    await FirebaseFirestore.instance.collection('usuarios').add(userData);

    // Datos guardados exitosamente
    // Aquí puedes realizar acciones adicionales después del registro,
    // como navegar a otra página o mostrar un mensaje de éxito.

    print('Datos registrados exitosamente en Firestore');
  } catch (error) {
    // Ocurrió un error al guardar los datos en Firestore
    // Aquí puedes manejar el error, como mostrar un mensaje de error.

    print('Error al registrar los datos en Firestore: $error');
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

var UID_admin = '';
final _formKey = GlobalKey<FormState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

void registrarDatos(
    email,firstName, lastName, password, cedula, occupation, context) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // El usuario se ha registrado exitosamente
    User? user = userCredential.user;
    UID_admin = user!.uid;

    // Despliega un cuadro de texto con el UID del usuario
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar usuario'),
          content: Text('El usuario ha sido registrado con UID correctamente'),
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
  try {
    // Crea un mapa con los datos a guardar en Firestore
    Map<String, dynamic> userData = {
      'Nombres': firstName,
      'Apellidos': lastName,
      'contraseña': password,
      'Correo': email,
      'cedula': cedula,
      'ocupación': occupation,
      'Tipo': 'admin',
      'UID': UID_admin,
      'root': false,
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

Future<bool> isCurrentUserRoot() async {
  // Obtiene el ID del usuario actualmente loggeado
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  // Si no hay un usuario loggeado, retorna false
  if (currentUserId == null) return false;

  // Obtiene el documento del usuario en la colección de usuarios
  final userDoc = await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(currentUserId)
      .get();

  // Si el documento del usuario no existe, retorna false
  if (!userDoc.exists) return false;

  // Obtiene el valor del atributo 'Root' del documento del usuario
  final isRoot = userDoc.data()?['Root'] as bool? ?? false;

  // Retorna el valor del atributo 'Root'
  return isRoot;
}

Future<void> mostrarMsj(context) async{
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error al registrar el admin'),
          content: Text('El usuario no tiene permisos para registrar otro administrador'),
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
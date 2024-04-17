import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nuwakakaram/Modulo_Admin/homeAdmin.dart';
import 'package:nuwakakaram/login.dart';
import 'Modulo_Usuario/home.dart';

//toma la cedula del usuario, para registrar un correo y asociarlo a firebase auth


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
//inicia sesion con correo y pass, verifica firebase auth
  Future<User?> signInWithEmailAndPassword(
      context, String email, String password) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text('Iniciando sesión...'),
              ],
            ),
          );
        },
      );
    } catch (e) {
      print("error");
    }
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error de inicio de sesión: $e');
      return null;
    }
  }

//inica sesion  y muestra un mensaje si no se logro logear
  Future<dynamic> manejoLogin(
      dynamic context, dynamic email, dynamic password) async {
    final user =
        await _authService.signInWithEmailAndPassword(context, email, password);
    if (user != null) {
      // El inicio de sesión fue exitoso, puedes realizar acciones adicionales aquí
      print('Inicio de sesión exitoso para ${user.email}');
      buscaUID(context, user.uid);
    } else {
      // El inicio de sesión falló, muestra un mensaje de error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error de inicio de sesión'),
          content: const Text('Las credenciales son incorrectas.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                           MyHomePage())),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

//cierra sesion y retorna a login page
  void signOut(context) async {
    await _auth.signOut();
    Navigator.of(context).popAndPushNamed('/');
  }

//En esta versión, la función login realiza una consulta en la colección 'usuarios' de Firebase Firestore para encontrar al usuario con el correo y la contraseña proporcionados. Luego, verifica el campo 'userType' en los datos del usuario recuperados y redirige al usuario al panel de control adecuado según su tipo.

//Ten en cuenta que esta es una solución básica y que deberías implementar la autenticación con Firebase Authentication y manejar las contraseñas de forma segura en la base de datos. Además, asegúrate de que Firebase esté configurado correctamente en tu proyecto de Flutter antes de usar esta función.

  //obtener datos de usuarios
  Future<void> buscaUID(context, dynamic value) async {
    final collectionRef = FirebaseFirestore.instance.collection("usuarios");

    final query = collectionRef.where('UID', isEqualTo: value);
    final querySnapshot = await query.get();
    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs[0].data();
      if (userData['Tipo'] == 'usuario') {
        // Redirigir al dashboard de usuario
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashboardPage()));
        print('es usuario');
      } else if (userData['Tipo'] == 'admin') {
        // Redirigir al dashboard de admin
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashboardPageA()));
        print('es administador');
      }
    } else {
      // Mostrar un mensaje de error de credenciales inválidas
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Credenciales inválidas. Intente nuevamente.'),
      ));
    }
  }
}

final AuthService _authService = AuthService();


  Future<void> buscarDocumento(String valor, context) async {
  String campo = 'cedula';
  // Obtener la referencia a la colección
  final coleccion = FirebaseFirestore.instance.collection('usuarios');

  // Crear la consulta
  final consulta = coleccion.where(campo, isEqualTo: valor);

  // Obtener el documento
  final documento = await consulta.get().then((snapshot) {
    if (snapshot.docs.isNotEmpty) {
      // Si hay documentos, retornar el valor del campo 'Correo'
      final correo = snapshot.docs.first.get('Correo');
      print(correo);
      return correo;
    } else {
      // Si no hay documentos, lanzar un mensaje de error
      return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text('El usuario no existe'),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () async {
              
              Navigator.of(context).pop(); // Cerrar el diálogo al presionar "Cancelar"
              // Reemplazar la ruta actual con la pantalla de inicio de sesión
            },
            child: const Text('Volver a Ingresar'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el diálogo al presionar "Cancelar"
              exit(0);
            },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
      //throw Exception('No se encontró ningún documento con la cédula proporcionada');
    }
  });

  // Retornar el valor del campo
  return documento;
}


import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
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


  Future<dynamic> manejoLogin(dynamic context, String password, String cedula) async
  
   {
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

    dynamic email = await buscarCorreo(cedula);
    final user =
        await _authService.signInWithEmailAndPassword(context, email,  password.toString());
    if (user != null) {
     
      buscaUID(context, user.uid);
    } else {
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
    signOutWithConfirmation(context);
  // Navigator.of(context).popAndPushNamed('/');
  }

Future<void> signOutWithConfirmation(context) async {
  final shouldSignOut = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('¿Estás seguro de que quieres cerrar sesión?'),
      content: const Text('Esta acción te cerrará la sesión de la aplicación.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Cerrar sesión'),
        ),
      ],
    ),
  );

  if (shouldSignOut == true) {
    await _auth.signOut();
    Navigator.of(context).popAndPushNamed('/');
  }
}
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


Future<String> buscarCorreo(dynamic cedula) async {
    final db = FirebaseFirestore.instance;
  final collection = db.collection('usuarios'); 

  try {
    final snapshot = await collection.where('cedula', isEqualTo: cedula).get();
    if (snapshot.docs.isEmpty) {
      print("No se encontró ningún documento con la cédula indicada.");
      return "";
    } else {
      final docData = snapshot.docs[0].data();
      if (docData != null && docData['Correo'] != null) {
        return docData['Correo'] as String;
      } else {
        print("El documento encontrado no contiene el campo 'correo'.");
        return "";
      }
    }
  } catch (error) {
    print("Error al buscar correo electrónico:");
    return "";
  }
}


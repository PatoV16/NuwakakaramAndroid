import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:nuwakakaram/logicaLogin.dart';
import 'package:nuwakakaram/Modulo_Denuncias/guardar_Denuncia.dart';
Future<String?> buscarNombreUsuario(String uid) async {
  try {
    CollectionReference usuarios =
        FirebaseFirestore.instance.collection('usuarios');
    QuerySnapshot usuariosEncontrados =
        await usuarios.where('UID', isEqualTo: uid).get();

    if (usuariosEncontrados.docs.isNotEmpty) {
      // Verificar que haya al menos un usuario encontrado
      String? nombre = usuariosEncontrados.docs.first['Nombres'];
      //String? apellid = usuariosEncontrados.docs.first['Apellidos'];
      return nombre;
    } else {
      // Manejar el caso en el que no se encontró ningún usuario
      return null;
    }
  } catch (e) {
    // Manejar errores si ocurren
    print('Error al buscar el usuario: $e');
    return null;
  }
}

Future<void> mostrarConfirmacion(
    BuildContext context, String mensaje, var direccion, var receptor) async {
  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text('¿Está seguro que desea continuar?'),
        content: Text(mensaje),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () async {
              String hora = DateTime.now().toString();
              DocumentSnapshot<Object?> documentoSnapshot =
                  await buscarUsuario(uid.toString());
              if (documentoSnapshot.exists) {
                obtenerDatosUsuario(context, documentoSnapshot, direccion,
                    mensaje, receptor, hora);
              } else {
                print('El usuario no fue encontrado.');
              }
              // Cerrar el diálogo al presionar "Aceptar"
              await mostrarMensaje(context,
                  'LAS AUTORIDADES HAN SIDO PUESTAS EN ALERTA SOBRE SU CASO');
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context)
                  .pop(); // Cerrar el diálogo al presionar "Cancelar"
            },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}
Future<void> mostrarConfirmacionSalida(BuildContext context, String mensaje, AuthService authService) async {
  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text('¿Está seguro que desea continuar?'),
        content: Text(mensaje),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () async {
              authService.signOut(context); // Aquí authService está disponible
              // Reemplazar la ruta actual con la pantalla de inicio de sesión
              exit(0);
            },
            child: const Text('Aceptar'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el diálogo al presionar "Cancelar"
            },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}

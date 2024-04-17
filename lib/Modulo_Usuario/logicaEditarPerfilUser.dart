import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nuwakakaram/Modulo_Usuario/pdf_view.dart';
import 'package:file_picker/file_picker.dart';

bool validarCorreo(String correo) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(correo);
}

bool validarTelefono(String telefono) {
  return RegExp(r'^\d{10}$').hasMatch(telefono);
}

  Future<void> actualizarValor(String campo, String nuevoValor) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference usuarios =
        FirebaseFirestore.instance.collection('usuarios');
    QuerySnapshot usuariosEncontrados =
        await usuarios.where('UID', isEqualTo: uid).get();
    if (usuariosEncontrados.docs.isNotEmpty) {
      DocumentSnapshot usuario = usuariosEncontrados.docs.first;
      String documentoId = usuario.id;

      await usuarios.doc(documentoId).update({
        campo: nuevoValor,
      });
    }
  }

  Future<DocumentSnapshot> buscarUsuario(String uid) async {
    CollectionReference usuarios =
        FirebaseFirestore.instance.collection('usuarios');
    QuerySnapshot usuariosEncontrados =
        await usuarios.where('UID', isEqualTo: uid).get();
    DocumentSnapshot usuario = usuariosEncontrados.docs.first;
    return usuario;
  }

//solo debe subir una imagen
 Future<void> uploadImage(BuildContext context) async {
  final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  String cedula = '';
  cedula = await buscarCedulaUsuario(Auth.uid, 'cedula');
  if (pickedFile == null) return; // El usuario canceló la selección

  // Obtiene una referencia al Storage de Firebase
  final ref = FirebaseStorage.instance
      .ref()
      .child('images')
      .child(cedula)
      .child('profilePicture_$cedula.jpg');

  // Muestra un cuadro de diálogo de progreso
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        title: Text('Subiendo imagen'),
        content: LinearProgressIndicator(),
      ));

  // Sube la imagen
  try {
    await ref.putFile(File(pickedFile.path));
    String imageUrl = await ref.getDownloadURL();
    actualizarValor('imageURL', imageUrl);
    // Cierra el cuadro de diálogo
    // ignore: unnecessary_cast
    Navigator.of(context as BuildContext).pop();
    // Muestra un mensaje de éxito
    mostrarSnackBar('Imagen subida correctamente', context);
  } catch (error) {
    // Se ha producido un error al subir la imagen
    Navigator.of(context).pop();
    // Muestra un mensaje de error
    mostrarSnackBar('Se ha producido un error al subir la imagen: $error',context);
  }
}
void mostrarSnackBar(String mensaje, BuildContext context) {
  ScaffoldMessenger.of(context ).showSnackBar(
    SnackBar(
      content: Text(mensaje),
      duration: const Duration(seconds: 2),
    ),
  );
}


//controlar que solo se suba una vez el archivo por cada usuario

  Future<void> uploadPDF(String uid, BuildContext context) async {
    final picker = FilePicker.platform;
    final FilePickerResult? pickedFile = await picker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    String? cedula = '';
    cedula = await buscarCedulaUsuario(uid, 'cedula');

    if (pickedFile != null) {
      final List<File> filteredFiles = pickedFile.files
          .where((file) => file.path!.endsWith('.pdf'))
          .map((file) => File(file.path!))
          .toList();

      if (filteredFiles.isNotEmpty) {
        final file = filteredFiles.first;

        try {
          final reference = FirebaseStorage.instance
              .ref()
              .child('PDFs')
              .child(cedula)
              .child('documento_$cedula.pdf');
          final uploadTask = reference.putFile(file);

          await uploadTask.whenComplete(() async {
            final url = await reference.getDownloadURL();
            print('URL de descarga: $url');
            mostrarSnackBar('Archivo Subido correctamente', context);
            // Aquí puedes usar la URL para mostrar un enlace de descarga o realizar otras acciones
            actualizarValor('pdfURL', url);
          });
        } catch (e) {
          mostrarSnackBar('Error al subir PDF: $e', context);
        }
      } else {
        mostrarSnackBar('No se seleccionó ningún archivo PDF', context);
      }
    } else {
      mostrarSnackBar('No se seleccionó ningún archivo PDF', context);
    }
  }

  Future<String> buscarCedulaUsuario(String uid, campo) async {
    CollectionReference usuarios =
        FirebaseFirestore.instance.collection('usuarios');
    QuerySnapshot usuariosEncontrados =
        await usuarios.where('UID', isEqualTo: uid).get();

    if (usuariosEncontrados.docs.isNotEmpty) {
      return usuariosEncontrados.docs.first[campo] ??
          ''; // Devuelve la cedula del primer usuario encontrado
    } else {
      return ''; // Devuelve una cadena vacía si no se encuentra ningún usuario con el UID proporcionado
    }
  }


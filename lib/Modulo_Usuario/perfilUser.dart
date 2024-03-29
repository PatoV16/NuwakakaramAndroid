import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nuwakakaram/Modulo_Usuario/pdf_view.dart';
import 'package:file_picker/file_picker.dart';


// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  final String? uid = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController newcontroller = TextEditingController();
  String nuevoValor = '';
  String url = '';

  ProfilePage({super.key});

  ProfilePage createState() => ProfilePage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: buscarUsuario(uid.toString()),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        var correo = snapshot.data?['Correo'] ?? '';
        var telefono = snapshot.data?['Telefono'] ?? '';
        url = snapshot.data?['imageURL'] ?? '';
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF7E43B1),
            title: const Text(
              'Perfil',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    // Sube la imagen y luego carga la URL de descarga
                    uploadImage(context);
                    //final url = await buscarImagenUsuario(uid.toString());
                    print(url);
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(url),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: _buildEditableText(
                      'Correo', correo, correoController, context),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: _buildEditableText(
                      'Teléfono', telefono, telefonoController, context),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
    onPressed: () {
      // Acción al presionar el botón flotante
      uploadPDF(uid.toString(), context);
    },
    child: Icon(Icons.document_scanner), // Icono del botón flotante
    backgroundColor: Colors.blue, // Color de fondo del botón flotante
    foregroundColor: Colors.white, // Color del icono del botón flotante
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0), // Forma del botón flotante
    ),
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Ubicación del botón flotante en la esquina inferior derecha
        );
        
      },
    );
  }

  Widget _buildEditableText(String label, String value, TextEditingController controller, context) {
  bool esCorreoValido = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  bool esTelefonoValido = RegExp(r'^\d{10}$').hasMatch(value);

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        '$label: ',
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController newController = TextEditingController();
              newController.text = value;

              return AlertDialog(
                title: Text('Editar $label'),
                content: TextField(
                  controller: newController,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Validar el nuevo valor
                      String nuevoValor = newController.text;
                      bool esNuevoValorValido =
                          (label == 'Correo' && validarCorreo(nuevoValor)) ||
                          (label == 'Telefono' && validarTelefono(nuevoValor));

                      if (esNuevoValorValido) {
                        print(nuevoValor);
                        await actualizarValor(label, nuevoValor);
                      } else {
                        // Mostrar un mensaje de error al usuario
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Debes introducir un valor válido'),
                          ),
                        );
                      }

                      Navigator.pop(context);
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              );
            },
          );
        },
        child: Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
                color: esCorreoValido || esTelefonoValido ? Colors.black : Colors.red, // Cambiar el color del texto si no es válido
              ),
            ),
            const Icon(Icons.edit),
          ],
        ),
      ),
    ],
  );
}

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
      .child('profilePicture_' + cedula + '.jpg');

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

  Future<void> uploadPDF(String _uid, BuildContext context) async {
    final picker = FilePicker.platform;
    final FilePickerResult? pickedFile = await picker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    String? cedula = '';
    cedula = await buscarCedulaUsuario(_uid, 'cedula');

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
              .child('documento_' + cedula + '.pdf');
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
}

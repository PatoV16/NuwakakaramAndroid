import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nuwakakaram/Modulo_Usuario/logicaEditarPerfilUser.dart';
import 'package:nuwakakaram/recuperarContra.dart'; 
import 'package:nuwakakaram/Modulo_Admin/contactanos.dart';


// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  final String? uid = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController newcontroller = TextEditingController();
  final TextEditingController passController = TextEditingController();
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
    onPressed: () => Navigator.pop(context),
  ),
  actions: <Widget>[
    // Add your menu button here
    PopupMenuButton<String>(
      onSelected: (String choice) {
        // Handle menu item selection here
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'contactanos',
            child: Text('Contáctanos'),
            onTap: () { 
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViolenciaDeGeneroScreen()),
            );
              },
          ),
          PopupMenuItem<String>(
            value: 'acercaDe',
            child: Text('Acerca de..'),
          ),
        ];
      },
    ),
  ],
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
                  alignment: Alignment.center,
                  child: _buildEditableText(
                      'Correo', correo, correoController, context),
                ),
                Align(
                  alignment: Alignment.center,
                  child: _buildEditableText(
                      'Teléfono', telefono, telefonoController, context),
                ),
                Align(
  alignment: Alignment.bottomCenter,
  child: TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordRecoveryPage(),
      ),
    );
  },
  child: Text('Cambiar contraseña'),
),
),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
    onPressed: () {
      // Acción al presionar el botón flotante
      uploadPDF(uid.toString(), context);
    }, // Icono del botón flotante
    backgroundColor: Colors.blue, // Color de fondo del botón flotante
    foregroundColor: Colors.white, // Color del icono del botón flotante
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0), // Forma del botón flotante
    ),
    child: const Icon(Icons.document_scanner),
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
}
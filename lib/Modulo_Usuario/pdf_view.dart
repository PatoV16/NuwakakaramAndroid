import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Auth {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String get uid {
    final currentUser = _auth.currentUser;
    return currentUser?.uid ?? "";
  }
}

class LauncherUrl {
  final String url;

  LauncherUrl(this.url);

  void launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se puede abrir la URL $url';
    }
  }
}

class MyPDFScreen extends StatefulWidget {
  @override
  _MyPDFScreenState createState() => _MyPDFScreenState();
}

class _MyPDFScreenState extends State<MyPDFScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String aux2 = Auth.uid;
            // Aquí recuperas el enlace del PDF desde Firebase Database
            String URLpdf = '';
            URLpdf = await obtenerURLDocumento('usuarios', aux2);
            // Muestra el PDF usando el paquete flutter_pdfview
            print(URLpdf);
            final lanzador = new LauncherUrl(URLpdf);
            lanzador.launchURL();
          },
          child: Text('Abrir PDF'),
        ),
      ),
    );
  }
}

Future<String> obtenerURLDocumento(String coleccion, String uid) async {
  final documento = await FirebaseFirestore.instance
      .collection("usuarios")
      .where('UID', isEqualTo: uid)
      .get();

  if (documento.docs.isNotEmpty) {
    // Hay documentos que cumplen la condición
    final documentoUsuario = documento.docs.first; // Primer documento
    final pdfURL = documentoUsuario.data()["pdfURL"];

    if (pdfURL != null) {
      return pdfURL;
    } else {
      throw Exception("El usuario no tiene un campo 'pdfURL'.");
    }
  } else {
    // No se encontraron documentos para el UID
    throw Exception("No se encontró usuario con el UID proporcionado.");
  }
}

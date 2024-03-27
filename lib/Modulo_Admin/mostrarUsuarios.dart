import 'package:nuwakakaram/Modulo_Admin/homeAdmin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

void main() {
  runApp(MaterialApp(
    home: getUsersAll(),
  ));
}

class getUsersAll extends StatefulWidget {
  @override
  _getUsersAllState createState() => _getUsersAllState();
}

class _getUsersAllState extends State<getUsersAll> {
  Future<List<Map<String, dynamic>>> getUsuarios() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('usuarios').get();
    List<Map<String, dynamic>> usuariosL = [];
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        usuariosL.add(doc.data() as Map<String, dynamic>);
      }
    }
    return usuariosL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final usuario = snapshot.data![index];
                return ListTile(
                  title: Text(
                      'Nombre: ${usuario['Nombres']} ${usuario['Apellidos']}'),
                  subtitle: Text('Cédula: ${usuario['cedula']}'),
                 // trailing: Text('Contraseña: ${usuario['contraseña']}'),
                );
              },
            );
          } else {
            return Center(child: Text('Error al cargar los datos'));
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListaDenunciasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener el UID del usuario actualmente autenticado
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Denuncias'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('denuncias')
            .where('UID', isEqualTo: uid) // Filtrar por UID del usuario
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
  itemCount: snapshot.data!.docs.length,
  itemBuilder: (context, index) {
    var document = snapshot.data!.docs[index];
    var denuncia = Denuncia.fromMap(document.data() as Map<String, dynamic>);
    return Column(
      children: [
        ListTile(
          title: Text(denuncia.titulo),
          subtitle: Text(denuncia.descripcion),
          onTap: () {
            // Aquí puedes agregar la lógica para mostrar más detalles de la denuncia
          },
        ),
        Divider(), // Agregar un Divider después de cada ListTile
      ],
    );
  },
);

          }

          return Center(child: Text('No hay denuncias disponibles'));
        },
      ),
    );
  }
}

class Denuncia {
  final String titulo;
  final String descripcion;

  Denuncia(this.titulo, this.descripcion);

  factory Denuncia.fromMap(Map<String, dynamic> map) {
    return Denuncia(
      map['nombre'] ?? '',
      map['descripcion'] ?? '',
    );
  }
}

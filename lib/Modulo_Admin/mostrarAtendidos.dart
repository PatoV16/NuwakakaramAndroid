import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AtendidosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atendidos'),
      ),
      body: Container(
        color: Colors.white, // Color de fondo blanco
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('denuncias')
              .where('estado_denuncia', isEqualTo: 'ATENDIDO')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error al cargar los datos'));
            }
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No hay documentos atendidos'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                // Chequeo para asegurar que data no sea nulo
                if (data == null) {
                  return SizedBox(); // O cualquier otro widget que desees mostrar
                }
                // Aquí puedes construir el widget para cada elemento de la lista
                return ListTile(
                  title: Text(data['nombre']+data['apellido'] ?? ''),
                  subtitle: Text(data['descripcion'] ?? ''),
                  // Otros widgets según la estructura de tus documentos
                );
              },
            );
          },
        ),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
//funcion para leer informacion de la bd

Future<List<dynamic>> getUsuarios() async {
  List usuarios = [];
  CollectionReference collectionReferenceUsuarios = db.collection('usuarios');
  QuerySnapshot queryUsuarios = await collectionReferenceUsuarios.get();
  for (var documento in queryUsuarios.docs) {
    usuarios.add(documento.data);
  }
  return usuarios;
}

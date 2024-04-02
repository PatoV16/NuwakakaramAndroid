import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

void main() {
  runApp(const MaterialApp(
    home: getUsersAll(),
  ));
}

class getUsersAll extends StatefulWidget {
  const getUsersAll({super.key});

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
        usuariosL.add(doc.data());
      }
    }
    return usuariosL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final usuario = snapshot.data![index];
                return ListTile(
                  title: Text(
                      'Nombre: ${usuario['Nombre']} ${usuario['Apellido']}'),
                  subtitle: Text('Cédula: ${usuario['cedula']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                         onPressed: () async {
                            final usuario = snapshot.data![index];
    final uid = usuario['UID']; // Suponiendo que el campo UID existe

    // Muestra un diálogo de confirmación
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar deshabilitación'),
        content: const Text('¿Seguro que desea deshabilitar a este usuario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deshabilitar'),
          ),
        ],
      ),
    );

    if (confirm) {
      handleAccount('estado', 'deshabilitado', uid);
    }
                       
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                            final usuario = snapshot.data![index];
    final uid = usuario['UID']; // Suponiendo que el campo UID existe

    // Muestra un diálogo de confirmación
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar la eliminación de la cuenta'),
        content: const Text('¿Seguro que desea eliminar a este usuario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm) {
      eliminarUsuario(uid);
    }
                       
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Error al cargar los datos'));
          }
        },
      ),
    );
  }
/*
Future<void> eliminarUsuario(String UID) async {
  try {
    // Reemplaza "coleccion" con el nombre real de tu colección
    final collectionRef = FirebaseFirestore.instance.collection('coleccion');
    final docRef = collectionRef.doc(UID);

    await docRef.delete();

    // Actualiza la lista de usuarios localmente (opcional)
    if (mounted) {
      setState(() {
        getUsuarios();
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usuario eliminado correctamente')),
    );
  } catch (error) {
    print('Error al eliminar el usuario: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al eliminar el usuario')),
    );
  }
}*/

Future<void> eliminarUsuario(dynamic valorCampo) async {
  String nombreCampo = 'UID';
  try {
    // Referencia a la colección donde se buscará el documento
    final collectionRef = FirebaseFirestore.instance.collection('usuarios');

    // Consulta para buscar el documento por el campo especificado
    final querySnapshot = await collectionRef.where(nombreCampo, isEqualTo: valorCampo).get();

    // Verificar si se encontraron documentos que coincidan con la consulta
    if (querySnapshot.docs.isNotEmpty) {
      // Eliminar el primer documento que coincida (puedes ajustar la lógica según tus necesidades)
      final docRef = querySnapshot.docs.first.reference;
      await docRef.delete();
       if (mounted) {
      setState(() {
        getUsuarios();
      });
    }
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario eliminado correctamente')),
    );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se encontraron documentos que coincidan con la consulta.')),
    );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error al eliminar el usuario')),
    );
  }
}

Future<void> handleAccount(String campo, String nuevoValor, uid) async {
    
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


}


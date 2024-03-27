import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nuwakakaram/Modulo_Admin/registroAdmin.dart';
import 'package:nuwakakaram/Modulo_Admin/mostrarUsuarios.dart';
import 'package:nuwakakaram/Modulo_Ubicacion/mapaScreen.dart';
import 'package:nuwakakaram/Modulo_Ubicacion/map_screen.dart';
import 'package:nuwakakaram/logicaLogin.dart';
import 'contactanos.dart';
//port 'package:nuwakakaram/Modulo_Ubicacion/mapaScreen.dart';


void main() {
  runApp(MaterialApp(
    home: DashboardPageA(),
  ));
}

class DashboardPageA extends StatelessWidget {
  final AuthService authService = AuthService();

  DashboardPageA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido - Administrador'),
        leading: SizedBox(
          height: 40.0,
          width: 40.0,
          child: Image.asset('assets/logo.png'),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'cerrar sesion':
                  authService.signOut(context);
                  break;
                case 'contactanos':
                  // Abre una página de contacto
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViolenciaDeGeneroScreen()),
                  );
                  break;
                case 'Registrar otro Administrador':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterAPage()),
                  );
                  break;
                case 'Limpiar Registro':
                  deleteDenuncias();
                  break;
                case 'Limpiar Usuarios':
                  borrarUsuarios();
                  break;
                case 'mostrar mapa':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapScreen()),
                  );

              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'cerrar sesion',
                  child: Text('Cerrar sesión'),
                ),
                const PopupMenuItem(
                  value: 'contactanos',
                  child: Text('Contactanos'),
                ),
                const PopupMenuItem(
                  value: 'Registrar otro Administrador',
                  child: Text('Registrar otro Administrador'),
                ),
                const PopupMenuItem(
                  value: 'Limpiar Registro',
                  child: Text('Limpiar Registro'),
                ),
                const PopupMenuItem(
                  value: 'Limpiar Usuarios',
                  child: Text('Limpiar usuarios'),
                ),
                const PopupMenuItem(
                  value: 'mostrar mapa',
                  child: Text('Mostrar Mapa'),
                  )
              ];
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => getUsersAll()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            child: const Text(
              'Usuarios Registrados',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('denuncias')
                  .orderBy('Hora', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var denuncias = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: denuncias.length,
                  itemBuilder: (context, index) {
                    var denuncia =
                        denuncias[index].data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text('Denuncia ${index + 1}'),
                      subtitle:
                          Text(denuncia['descripcion'] ?? 'Sin descripción'),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        // Acción al presionar una denuncia específica
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Gmaps()),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> deleteDenuncias() async {
  try {
    // Obtener una referencia a la colección 'denuncias'
    CollectionReference denuncias =
        FirebaseFirestore.instance.collection('denuncias');

    // Obtener todos los documentos en la colección 'denuncias'
    QuerySnapshot querySnapshot = await denuncias.get();

    // Iterar sobre cada documento y borrarlo
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    print(
        'Todos los registros de la colección "denuncias" han sido eliminados exitosamente.');
  } catch (e) {
    print('Error al eliminar los registros de la colección "denuncias": $e');
  }
}

Future<void> borrarUsuarios() async {
  String nombreColeccion = 'usuarios';

  // Crea una consulta que filtre por documentos con "Tipo: "usuario""
  Query query = FirebaseFirestore.instance
      .collection(nombreColeccion)
      .where('Tipo', isEqualTo: 'usuario');

  // Obtén los documentos que coinciden con la consulta
  QuerySnapshot snapshot = await query.get();

  // Itera sobre cada documento y bórralo
  for (DocumentSnapshot doc in snapshot.docs) {
    await doc.reference.delete();
  }

  print(
      'Todos los documentos en la colección "$nombreColeccion" con "Tipo: "usuario"" han sido borrados.');
}



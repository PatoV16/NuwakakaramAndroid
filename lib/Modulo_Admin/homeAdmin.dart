import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nuwakakaram/Modulo_Admin/registroAdmin.dart';
import 'package:nuwakakaram/Modulo_Admin/mostrarUsuarios.dart';
import 'package:nuwakakaram/Modulo_Ubicacion/map_screen.dart';
import 'package:nuwakakaram/logicaLogin.dart';
import 'contactanos.dart';
import 'package:flutter/cupertino.dart';
//port 'package:nuwakakaram/Modulo_Ubicacion/mapaScreen.dart';


void main() {
  runApp(MaterialApp(
    home: DashboardPageA(),
  ));
}

class DashboardPageA extends StatelessWidget {
  final AuthService authService = AuthService();

  DashboardPageA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido - Administrador'),
        leading: SizedBox(
          height: 40.0,
          width: 40.0,
          child: Image.asset('assets/logo.png'),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
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
                        builder: (context) => const ViolenciaDeGeneroScreen()),
                  );
                  break;
                case 'Registrar otro Administrador':
                
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterAPage()),
                  );
                  break;
                  
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
                MaterialPageRoute(builder: (context) => const getUsersAll()),
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
                      title: Text(denuncia['nombre']+denuncia['apellido']),
                      subtitle:
                          Text(denuncia['descripcion'] ?? 'Sin descripción'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () async {
              // Recupera los valores de latitud y longitud (maneja la ausencia potencial)
                            showContextMenu(context, denuncia);
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
 void showContextMenu(BuildContext context, denuncia) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(denuncia['nombre']+denuncia['apellido']),
        content: Text(denuncia['cedula']),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('Ver Mapa'),
            onPressed: () {
              // Código para cuando se presiona "Ver Mapa"
              double? latitud = denuncia['latitud'];
              double? longitud = denuncia['longitud'];

              // Valida la latitud y longitud antes de navegar
              if (latitud != null && longitud != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(
                      latitud: latitud,
                      longitud: longitud,
                    ),
                  ),
                );
              } else {
                // Maneja datos de ubicación faltantes (por ejemplo, muestra un mensaje)
                print(' Faltan datos de ubicación.');
                // Considera mostrar un mensaje amigable para el usuario aquí
                Navigator.pop(context);
              }
              
            },
          ),
          CupertinoDialogAction(
            child: const Text('Atender'),
            onPressed: () {
              
              // Código para cuando se presiona "Atender"
              print('Atender');
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

}


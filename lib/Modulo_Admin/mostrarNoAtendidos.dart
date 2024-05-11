import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nuwakakaram/Modulo_Ubicacion/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:nuwakakaram/Modulo_Ubicacion/mapaNoAtendidas.dart';
class NoAtendidosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('No Atendidos'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              // Aquí puedes agregar la lógica para abrir el mapa
              // Por ejemplo, navegar a la pantalla del mapa
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClodMapScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('denuncias')
                  .where('estado_denuncia', isEqualTo: 'NO ATENDIDO')
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
                      title: Text(denuncia['nombre'] + denuncia['apellido']),
                      subtitle: Text(
                          denuncia['descripcion'] ?? 'Sin descripción'),
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
          title: Text(denuncia['nombre'] + denuncia['apellido']),
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
                  print('Faltan datos de ubicación.');
                  // Considera mostrar un mensaje amigable para el usuario aquí
                  Navigator.pop(context);
                }
              },
            ),
            CupertinoDialogAction(
              child: const Text('Atender'),
              onPressed: () {
                handleAccount(denuncia['UID']);
                // Código para cuando se presiona "Atender"
                print(denuncia['UID']);
                print('Atender');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> handleAccount( uid) async {
    
     // Accedemos a la colección de denuncias en Firestore
  final denunciasRef = FirebaseFirestore.instance.collection('denuncias');

  // Filtramos los documentos donde 'UID' sea igual al valor especificado
  final query = denunciasRef.where('UID', isEqualTo: uid);

  // Obtenemos los documentos coincidentes
  final querySnapshot = await query.get();

  // Recorremos cada documento coincidente y actualizamos el estado
  for (final doc in querySnapshot.docs) {
    await doc.reference.update({
      'estado_denuncia': 'ATENDIDO',
    });
  }
  }
}
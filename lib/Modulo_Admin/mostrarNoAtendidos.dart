import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nuwakakaram/Modulo_Admin/logicaAdmin.dart';
import 'package:nuwakakaram/Modulo_Ubicacion/map_screen.dart';
import 'package:flutter/cupertino.dart';
class NoAtendidosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('No Atendidos'),
      ),
      body: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
        children:[
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
        ]
      )
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
              var id = denuncia['UID'];
              print(id);
              handleAccount('estado_denuncia', 'ATENDIDO', id);
              
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


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nuwakakaram/Modulo_Admin/logicaAdmin.dart';
import 'package:nuwakakaram/Modulo_Admin/registroAdmin.dart';
import 'package:nuwakakaram/Modulo_Admin/mostrarUsuarios.dart';
import 'package:nuwakakaram/logicaLogin.dart';
import 'contactanos.dart';
import 'package:flutter/cupertino.dart';
import 'package:nuwakakaram/Modulo_Ubicacion/hotMapScreen.dart';
import 'package:nuwakakaram/Modulo_Admin/mostrarNoAtendidos.dart';
import 'package:nuwakakaram/Modulo_Admin/mostrarAtendidos.dart';


class DashboardPageA extends StatelessWidget {
  final AuthService authService = AuthService();

  //DashboardPageA({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
          await mostrarConfirmacionSalida(
            context, '¿Seguro que desea salir?', authService);
        return false; 
      },
      child: 
        Scaffold(
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
                onSelected: (value) async{
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
                      bool aux = await isCurrentUserRoot();
                      if( aux == true){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterAPage()),
                      );
                      
                      }else{
                        mostrarMsj(context);
                      }
                      
                      break;
                      case 'Mostrar Reportes':
                     Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HotMapScreen()),
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
                      child: Text('Contáctanos'),
                    ),
                    const PopupMenuItem(
                      value: 'Registrar otro Administrador',
                      child: Text('Registrar otro Administrador'),
                    ),
                    const PopupMenuItem(
                      value: 'Mostrar Reportes',
                      child: Text('Mostrar Reportes'),
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
               SizedBox(height: 20),
               ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  NoAtendidosScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: const Text(
                  'Denuncias No Atendidas',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  AtendidosScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: const Text(
                  'Denuncias Atendidas',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
 

}



Future<void> mostrarConfirmacionSalida(BuildContext context, String mensaje, AuthService authService) async {
  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text('¿Está seguro que desea continuar?'),
        content: Text(mensaje),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () async {
              authService.signOut(context); // Aquí authService está disponible
              // Reemplazar la ruta actual con la pantalla de inicio de sesión
              exit(0);
            },
            child: const Text('Aceptar'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el diálogo al presionar "Cancelar"
            },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}
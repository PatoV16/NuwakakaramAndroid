import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuwakakaram/Modulo_Usuario/pdf_view.dart';
import 'package:nuwakakaram/logicaLogin.dart';
import 'perfilUser.dart';
import 'package:nuwakakaram/Modulo_Denuncias/mis_Denuncias.dart';
import 'package:nuwakakaram/Modulo_Usuario/logicaHomeUser.dart';
import 'package:nuwakakaram/Modulo_Usuario/logicaEditarPerfilUser.dart';
bool confirmacion = false;

// ignore: must_be_immutable
class DashboardPage extends StatelessWidget {
  String receptor = 'greysvilla99@gmail.com';
  final AuthService authService = AuthService();
  String mensaje = '';
  var direccion = 0;
  ProfilePage objetoBuscar = ProfilePage();

  late String profileImageUrl;

  DashboardPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    //profileImageUrl = objetoBuscar.buscarCedulaUsuario(Auth.uid, 'imageURL') as String;
    return WillPopScope(
      onWillPop: () async {
        // Mostrar el diálogo de confirmación al presionar el botón de retroceso
        await mostrarConfirmacionSalida(
            context, '¿Seguro que desea salir?', authService);
        return false; // Regresar false para evitar que se cierre la página automáticamente
      },
    child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF7E43B1),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
        title: FutureBuilder<String?>(
          future: buscarNombreUsuario(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Cargando...',
                  style: TextStyle(color: Colors.white));
            } else if (snapshot.hasError) {
              return const Text('Error al obtener datos',
                  style: TextStyle(color: Colors.white));
            } else if (snapshot.hasData) {
              return Text(
                'Bienvenido, ${snapshot.data}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            } else {
              return const Text('Título Alternativo',
                  style: TextStyle(color: Colors.white));
            }
          },
        ),
        centerTitle: true,
        elevation: 5,
        leading: FutureBuilder<String>(
          future: buscarCedulaUsuario(Auth.uid, 'imageURL'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Muestra un indicador de carga mientras se espera
            } else if (snapshot.hasError) {
              return const Text('Error al obtener la URL de la imagen');
            } else if (snapshot.hasData) {
              return CircleAvatar(
                backgroundImage: NetworkImage(snapshot.data!),
                radius: 10,
              );
            } else {
              return const CircleAvatar(); // O cualquier otro valor por defecto
            }
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;
          final double itemSize = availableWidth /
              3; // Ajusta el tamaño de los elementos según el ancho disponible

          return Center(
            child: GridView.count(
              crossAxisCount: 2, // Número de columnas
              padding: const EdgeInsets.all(16.0),
              mainAxisSpacing: 16.0, // Espacio vertical entre los botones
              crossAxisSpacing: 16.0, // Espacio horizontal entre los botones
              childAspectRatio:
                  1.0, // Relación de aspecto cuadrada para los botones
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Acción al presionar el botón de perfil
                    String mensaje1 =
                        'Violencia leve, agresiones verbales no graves, empujones, bofetadas y patadas que no sean en sitios críticos y no causen demasiado daño. Agresiones físicas leves.';
                    mostrarConfirmacion(context, mensaje1, direccion, receptor);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    height: itemSize,
                    width: itemSize,
                    child: Image.asset('assets/amarillo.png'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String mensaje2 =
                        'Agresiones verbales que afecten directamente el autoestima de la persona, ofensas graves, palabras de grueso calibre, golpes que provoquen hematomas en el cuerpo o rostro de la víctima.';
                    mostrarConfirmacion(context, mensaje2, direccion, receptor);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    height: itemSize,
                    width: itemSize,
                    child: Image.asset('assets/verde.png'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String mensaje3 =
                        'Agresiones verbales recurrentes que han causado daño en la autoestima y efectos como depresión de primer y segundo grado, lesiones que necesitan atención médica, suturas y reposo de hasta tres días.';

                    mostrarConfirmacion(context, mensaje3, direccion, receptor);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    height: itemSize,
                    width: itemSize,
                    child: Image.asset('assets/rosa.png'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String mensaje4 =
                        'Depresión aguda o falta de defensa, pone a sus familiares la denuncia porque no tiene voluntad propia, por la afectación de la violencia recurrente. Violencia física con armas de fuego, armas blancas como cuchillos y machetes, ahogos, utilización de cables y correas, lesiones que duran más de tres días, fracturas de nariz y extremidades, heridas que necesitan sutura, golpes con palos, configuran delitos.';

                    mostrarConfirmacion(context, mensaje4, direccion, receptor);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    height: itemSize,
                    width: itemSize,
                    child: Image.asset('assets/naranja.png'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    //show_notification();
                    String mensaje5 =
                        'Intento de asesinato, intento de feminicidio, violaciones sexuales, abuso sexual agravado, contagio de enfermedades de transmisión sexual graves como el VIH/SIDA, consumo de alcohol y drogas, amenazas de suicidio o homicidio, agresiones bajo los efectos de alcohol y/o drogas.';
                    mostrarConfirmacion(context, mensaje5, direccion, receptor);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    height: itemSize,
                    width: itemSize,
                    child: Image.asset('assets/rojo.png'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String mensaje6 =
                        'Femicidio, otra clase de denuncia de infracciones o delitos, debe tener un código que identifique la gravedad y la peligrosidad, y en base a ellos se deberá activar el protocolo de acuerdo a las características descritas en la denuncia.';

                    mostrarConfirmacion(context, mensaje6, direccion, receptor);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB695C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    height: itemSize,
                    width: itemSize,
                    child: Image.asset('assets/violeta.png'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF7E43B1), // Color del footer
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              icon: const Icon(Icons.person, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                // Acción al presionar el botón de noticias
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListaDenunciasScreen()));
              },
              icon: const Icon(Icons.list, color: Colors.white),
            ),
           
            IconButton(
              onPressed: () {
                //Acción al presionar el botón de inicio
                Navigator.push(
                context,
                 MaterialPageRoute(builder: (context) => const MyPDFScreen()),
               );
               //getCurrentPosition();
              },
              icon: const Icon(Icons.file_open, color: Colors.white),
            ),
             IconButton(
              onPressed: () {
                // Acción al presionar el botón de inicio
                authService.signOut(context);
                //exit(0);
              },
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
      ),
    )
    );
  }
}


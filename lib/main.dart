import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuwakakaram/Modulo_Ubicacion/geolocator.dart';
import 'package:nuwakakaram/Modulo_Usuario/registroUsuario.dart';
import 'package:nuwakakaram/recuperarContra.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'package:nuwakakaram/logicaLogin.dart';
import "package:nuwakakaram/services/notification_services.dart";
import 'package:nuwakakaram/Modulo_Admin/registroAdmin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  await determinePosition();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NUWA KAKARAM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'INICIAR SESIÓN'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF7E43B1),
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(
                  20.0), // Ajusta el valor para obtener la curvatura deseada en los bordes inferiores
            ),
          ),
          centerTitle: true,
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 150.0, // Ajusta la altura deseada
                    width: 150.0, // Ajusta el ancho deseado
                    child: Image.asset('assets/logo.png'), // Ruta de la imagen
                  ),
                  const SizedBox(height: 20.0),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffac79fdb),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Cédula',
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 16.0),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingresa tu cédula';
                        } else {
                          print(email);
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const SizedBox(
                    height: 10.0,
                    width: 15.0,
                  ), // Espacio entre el campo de cédula y contraseña
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffac79fdb),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      obscureText: true, // Ocultar el texto de la contraseña
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        labelText: 'Contraseña',
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 16.0),
                      ),
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingresa tu contraseña';
                        } else {}
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(
                      height:
                          20.0), // Espacio entre el campo de contraseña y el botón de inicio de sesión

                  ElevatedButton(
                    onPressed: () async {
                      String correos = await buscarDocumento(email);
                      authService.manejoLogin(context, correos, password);
                      clearTextField();
                                        },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(const Color(0xFFB695C0)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ), // Espacio entre el botón y el texto de registro
                  const SizedBox(
                      height:
                          20.0), // Espacio entre el campo de contraseña y el botón de inicio de sesión

                  const SizedBox(height: 20.0),
                  const Text(
                    '¿Aún no te has registrado?',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      'Regístrate',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PasswordRecoveryPage()),
                      );
                    },
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterAPage()),
                      );
                    },
                    child: const Text(
                      'Administrador',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  void clearTextField() {
    _emailController.clear();
    _passwordController.clear();
  }

  Future<String> buscarDocumento(String valor) async {
    String campo = 'cedula';
    // Obtener la referencia a la colección
    final coleccion = FirebaseFirestore.instance.collection('usuarios');

    // Crear la consulta
    final consulta = coleccion.where(campo, isEqualTo: valor);

    // Obtener el documento
    final documento =
        await consulta.get().then((snapshot) => snapshot.docs.first);

    // Retornar el documento
    final correo = documento.get('Correo');
    print(correo);
    // Retornar el valor del campo
    return correo;
  }
}

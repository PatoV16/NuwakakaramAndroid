
import 'package:flutter/material.dart';
import 'package:nuwakakaram/Modulo_Usuario/registroUsuario.dart';
import 'package:nuwakakaram/logicaLogin.dart';
import 'package:nuwakakaram/recuperarContra.dart';
import 'package:animate_do/animate_do.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simula una carga ficticia
    Future.delayed(Duration(seconds: 3), () {
      // Navega a la pantalla de inicio de sesión después de 3 segundos (puedes ajustar el tiempo según sea necesario)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Container(
              height: 150, // Altura deseada para la imagen
              width: 150, // Anchura deseada para la imagen
              child: Image.asset('assets/logo.png'),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // Barra de progreso
          ],
        ),
      ),
    );
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NUWAKAKARAM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  LoadingScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService authService = AuthService();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
   void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
 
                     
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
      	child: Container(
	        child: Column(
	          children: <Widget>[
	            Container(
	              height: 400,
	              decoration: const BoxDecoration(
	                image: DecorationImage(
	                  image: AssetImage('assets/background.png'),
	                  fit: BoxFit.fill
	                )
	              ),
	              child: Stack(
	                children: <Widget>[
	                  Positioned(
	                    left: 30,
	                    width: 80,
	                    height: 200,
	                    child: FadeInUp(duration: Duration(seconds: 1), child: Container(
	                      decoration: const BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/light-1.png')
	                        )
	                      ),
	                    )),
	                  ),
	                  Positioned(
	                    left: 140,
	                    width: 80,
	                    height: 150,
	                    child: FadeInUp(duration: Duration(milliseconds: 1200), child: Container(
	                      decoration: const BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/light-2.png')
	                        )
	                      ),
	                    )),
	                  ),
	                 
	                  Positioned(
	                    child: FadeInUp(duration: Duration(milliseconds: 1600), child: Container(
	                      margin: EdgeInsets.only(top: 50),
	                      child: Center(
	                        child: Text("NuwaKakaram...", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
	                      ),
	                    )),
	                  )
	                ],
	              ),
	            ),
	            Padding(
	              padding: EdgeInsets.all(30.0),
	              child: Column(
	                children: <Widget>[
	                  FadeInUp(duration: Duration(milliseconds: 1800), child: Container(
	                    padding: EdgeInsets.all(5),
	                    decoration: BoxDecoration(
	                      color: Colors.white,
	                      borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color.fromRGBO(143, 148, 251, 1)),
	                      boxShadow: const [
	                        BoxShadow(
	                          color: Color.fromRGBO(143, 148, 251, .2),
	                          blurRadius: 20.0,
	                          offset: Offset(0, 10)
	                        )
	                      ]
	                    ),
	                    child:Column(
  children: <Widget>[
    Container(
      padding: EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color:  Color.fromRGBO(143, 148, 251, 1)))
      ),
      child: TextField(
        controller: _cedulaController, // Controlador para el campo de email
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Cédula",
          hintStyle: TextStyle(color: Colors.grey[700]),
          prefixIcon: Icon(Icons.person),
        ),
        keyboardType: TextInputType.number,
      ),
    ),
    Container(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: _passwordController, // Controlador para el campo de contraseña
        obscureText: _obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Contraseña",
          hintStyle: TextStyle(color: Colors.grey[700]),
          prefixIcon: Icon(Icons.lock), // Ícono de candado como prefijo
          suffixIcon: IconButton(
            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: _toggleObscureText,
          ),
        ),
      ),
    ),
  ],
),
	                  )),
	                  SizedBox(height: 30,),
	                  FadeInUp(duration: Duration(milliseconds: 1900), child: Container(
	                    height: 50,
	                    decoration: BoxDecoration(
	                      borderRadius: BorderRadius.circular(10),
	                      gradient: const LinearGradient(
	                        colors: [
	                          Color.fromRGBO(155, 2, 197, 0.996),
	                          Color.fromRGBO(135, 3, 236, 0.993),
	                        ]
	                      )
	                    ),
                
	                    child: MaterialButton(
                        onPressed: () {
                  // Obtener el texto del TextEditingController como String
                  String cedula = _cedulaController.text;
                  String contrasena = _passwordController.text;
                  authService.manejoLogin(context, contrasena, cedula);
                  print('Texto ingresado: $cedula');
                }, // Llama a la función _loginPressed cuando se presiona el botón
                        child: const Center(
                          child: Text("Iniciar sesión", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                         ),
                        ),
	                  )),
	                 GestureDetector(
                    onTap: () {
                         // Implementa aquí la lógica para el caso de olvido su contrseña
                          Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PasswordRecoveryPage()),
                      );
                    },
                    child: SizedBox(
                     height: 70,
                     child: FadeInUp(
                     duration: Duration(milliseconds: 2000),
                     child: Text("Olvidó su Contraseña?",style: TextStyle(color: Color.fromRGBO(2, 14, 255, 1)),),
                     ),
                    ),
                     ),

                    GestureDetector(
                     onTap: () {
                       // Implementa aquí la lógica para el caso de "Regístrate"
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                      },
                     child: SizedBox(
                     height: 70,
                     child: FadeInUp(
                     duration: Duration(milliseconds: 2000),
                     child: Text( "Regístrate", style: TextStyle(color: Color.fromRGBO(2, 14, 255, 1)), ),
                             ),
                           ),
                         ),


	                ],
	              ),
	            )
	          ],
	        ),
	      ),
      )
    );
  }
}
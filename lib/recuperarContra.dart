import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';


class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({super.key});

  @override
  _PasswordRecoveryPageState createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  final _formKey = GlobalKey<FormState>();
  String _cedula = '';
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7E43B1),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(
                20.0), // Ajusta el valor para obtener la curvatura deseada en los bordes inferiores
          ),
        ),
        title: const Text('Recuperación de Contraseña', style: TextStyle(color: Colors.white, fontWeight:  FontWeight.bold,),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffac79fdb),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Cédula',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                    color:  Colors.white,
                    fontSize: 16.0,
                    //fontWeight:  FontWeight.bold
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa tu cédula';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _cedula = value!;
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffac79fdb),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Correo',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                    color:  Colors.white,
                    fontSize: 16.0,
                    //fontWeight:  FontWeight.bold
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa tu correo';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Aquí puedes realizar acciones con los datos ingresados, como enviar una solicitud de recuperación de contraseña
                    print('Cédula: $_cedula');
                    print('Correo: $_email');
                    recuperarContrasena(context, _email);
                  }
                },
                child: const Text('Recuperar Contraseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}
//aqui poner el mailer
TextEditingController emailController = TextEditingController();
 Future<void> recuperarContrasena(BuildContext context,  String email) async {
    

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Mostrar mensaje de éxito o redirigir a otra página
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Se ha enviado un correo electrónico para restablecer tu contraseña.'),
      ));
    } catch (e) {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al enviar el correo electrónico para restablecer la contraseña.'),
      ));
    }
  }
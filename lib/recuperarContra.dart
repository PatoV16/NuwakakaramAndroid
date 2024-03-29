import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() {
  runApp(MaterialApp(
    home: PasswordRecoveryPage(),
  ));
}

class PasswordRecoveryPage extends StatefulWidget {
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
        backgroundColor: Color(0xFF7E43B1),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(
                20.0), // Ajusta el valor para obtener la curvatura deseada en los bordes inferiores
          ),
        ),
        title: Text('Recuperación de Contraseña', style: TextStyle(color: Colors.white, fontWeight:  FontWeight.bold,),),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFAC79FDB),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
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
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFAC79FDB),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
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
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Aquí puedes realizar acciones con los datos ingresados, como enviar una solicitud de recuperación de contraseña
                    print('Cédula: $_cedula');
                    print('Correo: $_email');
                  }
                },
                child: Text('Recuperar Contraseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }


Future<void> sendEmail(String recipientEmail, String subject, String body) async {
  String username = 'patrik59.pv@gmail.com'; // Tu correo electrónico
  String password = 'jmuf mvad kavd sjii'; // Tu contraseña de correo electrónico

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username)
    ..recipients.add(recipientEmail)
    ..subject = subject
    ..text = body;

  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ${sendReport.toString()}');
  } catch (e) {
    print('Error sending email: $e');
  }
}
Future<DocumentSnapshot> buscarDocumento( String valor) async {
   String campo = 'cedula';
  // Obtener la referencia a la colección
  final coleccion = FirebaseFirestore.instance.collection('usuarios');

  // Crear la consulta
  final consulta = coleccion.where(campo, isEqualTo: valor);

  // Obtener el documento
  final documento = await consulta.get().then((snapshot) => snapshot.docs.first);

  // Retornar el documento
  return documento;
}

Future<bool?> confirmarCambioContrasena(BuildContext context) async {
  return await showCupertinoDialog<bool>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text('Confirmar cambio de contraseña'),
      content: Text('¿Estás seguro de que deseas solicitar un cambio de contraseña?'),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text('Cancelar'),
          onPressed: () { 
            Navigator.pop(context, false);
            },
        ),
        CupertinoDialogAction(
          child: Text('Solicitar cambio'),
          onPressed: () {
            
          },
        ),
      ],
    ),
  );
}


}
//aqui poner el mailer
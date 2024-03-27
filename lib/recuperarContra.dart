import 'package:flutter/material.dart';

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
}

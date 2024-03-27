import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuwakakaram/main.dart';
import 'logicaRegistro.dart';

void main() {
  runApp(MaterialApp(
    home: RegisterPage(),
  ));
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _cedula = '';
  String _firstName = '';
  String _lastName = '';
  String _correo = '';
  String _telefono = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7E43B1),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Registro de Usuario',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFAC79FDB),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Cédula',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                    prefixIcon: Icon(
                      Icons.perm_identity,
                      color: Colors.white,
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
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
              const SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFAC79FDB),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nombres',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa tu nombre';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Aquí puedes guardar los nombres ingresados como prefieras
                    List<String> names = value!.split(' ');
                    _firstName = names.toString();
                    // names[0] contiene el primer nombre
                    // names[1] contiene el segundo nombre (si está presente)
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFAC79FDB),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Apellidos',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                    prefixIcon: Icon(
                      Icons.person_2,
                      color: Colors.white,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa tu apellido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    List<String> lasts = value!.split(' ');
                    _lastName = lasts.toString();
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFAC79FDB),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa tu correo electrónico';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Por favor, ingresa un correo electrónico válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _correo = value!;
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFAC79FDB),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                    prefixIcon: Icon(
                      Icons.password,
                      color: Colors.white,
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa tu contraseña';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFAC79FDB),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa tu teléfono';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _telefono = value!;
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    guardarDatos(_cedula, _firstName, _lastName, _correo,
                        _password, _telefono, context);
                  }
                },
                child: Text('Ingresar Datos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

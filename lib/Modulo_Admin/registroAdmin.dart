import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuwakakaram/Modulo_Admin/homeAdmin.dart';
import '../services/firebase_options.dart';
import 'logicaAdmin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: DashboardPageA(),
  ));
}

class RegisterAPage extends StatefulWidget {
  @override
  _RegisterAPageState createState() => _RegisterAPageState();
}

class _RegisterAPageState extends State<RegisterAPage> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _password = '';
  String _cedula = '';
  String _occupation = '';
  String? _selectedOption; // Variable para almacenar el valor seleccionado

  List<String> _options = [
    'Policía',
    'Bombero',
    'Fiscalía',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB695C0),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(
                20.0), // Ajusta el valor para obtener la curvatura deseada en los bordes inferiores
          ),
        ),
        centerTitle: true,
        title: Text(
          'Registro de Administrador',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        /*leading: SizedBox(
          height: 40.0,
          width: 40.0,
          child: Image.asset('assets/logo.png'),
        ),*/
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF7E43B1),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      //fontWeight:  FontWeight.bold
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa tu nombre';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _firstName = value!;
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
                    labelText: 'Apellido',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      //fontWeight:  FontWeight.bold
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa tu apellido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _lastName = value!;
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
                      //fontWeight:  FontWeight.bold
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
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
                    labelText: 'Cédula',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      //fontWeight:  FontWeight.bold
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
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
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Tipo de autoridad',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      //fontWeight:  FontWeight.bold
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  ),
                  value: _selectedOption,
                  items: _options.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue;
                      _occupation = _selectedOption.toString();
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, seleccione una opción';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    registrarDatos(
                        _firstName, _lastName, _password, _cedula, _occupation, context);
                      
                  }
                },
                child: Text('Registrarse'),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

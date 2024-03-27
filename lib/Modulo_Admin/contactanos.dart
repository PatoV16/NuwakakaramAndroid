import 'package:flutter/material.dart';

class ViolenciaDeGeneroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Violencia de género en Morona Santiago'),
      ),
      body: ListView(
        children: [
          // **Contactos**

          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Contactos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text('Línea 180'),
            subtitle: Text('Atención a víctimas de violencia de género'),
            onTap: () {
              // Llamar a la línea 180
            },
          ),
          ListTile(
            title: Text('Policía Nacional'),
            subtitle: Text('101'),
            onTap: () {
              // Llamar a la Policía Nacional
            },
          ),
          ListTile(
            title: Text('Fiscalía General del Estado'),
            subtitle: Text('1800-020-020'),
            onTap: () {
              // Llamar a la Fiscalía General del Estado
            },
          ),

          // **Reglamentos**

          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Reglamentos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text('Ley Orgánica Integral para Prevenir y Erradicar la Violencia contra las Mujeres'),
            subtitle: Text('https://www.wipo.int/edocs/lexdocs/laws/es/ec/ec005es.pdf'),
            onTap: () {
              // Abrir el enlace a la ley
            },
          ),
          ListTile(
            title: Text('Reglamento de la Ley Orgánica Integral para Prevenir y Erradicar la Violencia contra las Mujeres'),
            subtitle: Text('https://www.wipo.int/edocs/lexdocs/laws/es/ec/ec006es.pdf'),
            onTap: () {
              // Abrir el enlace al reglamento
            },
          ),
        ],
      ),
    );
  }
}

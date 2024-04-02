import 'package:flutter/material.dart';

class ViolenciaDeGeneroScreen extends StatelessWidget {
  const ViolenciaDeGeneroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Violencia de género en Morona Santiago'),
      ),
      body: ListView(
        children: [
          // **Contactos**

          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Contactos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: const Text('Línea 180'),
            subtitle: const Text('Atención a víctimas de violencia de género'),
            onTap: () {
              // Llamar a la línea 180
            },
          ),
          ListTile(
            title: const Text('Policía Nacional'),
            subtitle: const Text('101'),
            onTap: () {
              // Llamar a la Policía Nacional
            },
          ),
          ListTile(
            title: const Text('Fiscalía General del Estado'),
            subtitle: const Text('1800-020-020'),
            onTap: () {
              // Llamar a la Fiscalía General del Estado
            },
          ),

          // **Reglamentos**

          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Reglamentos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: const Text('Ley Orgánica Integral para Prevenir y Erradicar la Violencia contra las Mujeres'),
            subtitle: const Text('https://www.wipo.int/edocs/lexdocs/laws/es/ec/ec005es.pdf'),
            onTap: () {
              // Abrir el enlace a la ley
            },
          ),
          ListTile(
            title: const Text('Reglamento de la Ley Orgánica Integral para Prevenir y Erradicar la Violencia contra las Mujeres'),
            subtitle: const Text('https://www.wipo.int/edocs/lexdocs/laws/es/ec/ec006es.pdf'),
            onTap: () {
              // Abrir el enlace al reglamento
            },
          ),
        ],
      ),
    );
  }
}

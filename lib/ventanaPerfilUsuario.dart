import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAppVentanaPerfilUsuario extends StatelessWidget {
  const MyAppVentanaPerfilUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmacias en Ecuador',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePageVentanaPerfilUsuario(title: 'Farmacias Asociadas a nosotros en Ecuador'),
    );
  }
}

class MyHomePageVentanaPerfilUsuario extends StatefulWidget {
  const MyHomePageVentanaPerfilUsuario({super.key, required this.title});

  final String title;

  @override
  State<MyHomePageVentanaPerfilUsuario> createState() =>
      _MyHomePageStateVentanaPerfilUsuario();
}

class _MyHomePageStateVentanaPerfilUsuario
    extends State<MyHomePageVentanaPerfilUsuario> {
  final List<Map<String, String>> pharmacies = [
    {
      'name': 'Farmacia Fybeca',
      'url': 'https://www.fybeca.com',
      'logo': 'assets/fybecalogo.png',
    },
    {
      'name': 'Farmacia SanaSana',
      'url': 'https://www.sanasana.com.ec',
      'logo': 'assets/sanasanalogo.png',
    },
    {
      'name': 'Farmacia Cruz Azul',
      'url': 'https://farmaciascruzazul.ec/',
      'logo': 'assets/cruzazullogo.png',
    },
  ];

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir la URL: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pharmacies.length,
        itemBuilder: (context, index) {
          final pharmacy = pharmacies[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: Image.asset(
                pharmacy['logo']!,
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, size: 50);
                },
              ),
              title: Text(pharmacy['name']!),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => _openUrl(pharmacy['url']!),
            ),
          );
        },
      ),
    );
  }
}


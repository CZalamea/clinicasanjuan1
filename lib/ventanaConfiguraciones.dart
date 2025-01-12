import 'package:flutter/material.dart';

class MyAppVentanaConfiguracion extends StatelessWidget {
  const MyAppVentanaConfiguracion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const MyHomePageVentanaConfiguracion(title: 'Clinica San Juan'),
    );
  }
}

class MyHomePageVentanaConfiguracion extends StatefulWidget {
  const MyHomePageVentanaConfiguracion({super.key, required this.title});

  final String title;

  @override
  State<MyHomePageVentanaConfiguracion> createState() => _MyHomePageStateVentanaConfiguracion();
}

class _MyHomePageStateVentanaConfiguracion extends State<MyHomePageVentanaConfiguracion> {

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
          body: Center(child: Text('Ventana de Configuración')),
          );
  }
}

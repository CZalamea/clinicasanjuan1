import 'package:flutter/material.dart';

class MyAppVentanaPerfilUsuario extends StatelessWidget {
  const MyAppVentanaPerfilUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePageVentanaPerfilUsuario(title: 'Clinica San Juan'),
    );
  }
}

class MyHomePageVentanaPerfilUsuario extends StatefulWidget {
  const MyHomePageVentanaPerfilUsuario({super.key, required this.title});

  final String title;

  @override
  State<MyHomePageVentanaPerfilUsuario> createState() => _MyHomePageStateVentanaPerfilUsuario();
}

class _MyHomePageStateVentanaPerfilUsuario extends State<MyHomePageVentanaPerfilUsuario> {

  String cedula="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Center(
            child: SizedBox(width: 300,

                    child: ListView(
                        padding: const EdgeInsets.symmetric(vertical:10),
                          children: <Widget>[
                                datosUsuario(),
                                botones()
                          ]
                    )
                  ),
          ),
          );
  }

  

  Widget datosUsuario()
  {
    return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                          TextField(decoration: const InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: 'Cedula'),
                                                      onChanged: (value){
                                                            cedula = value;
                                                        },
                                                    ),
                                          const SizedBox(height:10),
                                          TextField(decoration: const InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: 'Nombres'),
                                                      onChanged: (value){
                                                            cedula = value;
                                                        },
                                                    ),
                                          const SizedBox(height:10),
                                          TextField(decoration: const InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: 'Apellidos'),
                                                      onChanged: (value){
                                                            cedula = value;
                                                        },
                                                    ),
                                          const SizedBox(height:10),
                                          TextField(decoration: const InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: 'Direccion'),
                                                      onChanged: (value){
                                                            cedula = value;
                                                        },
                                                    ),
                                          const SizedBox(height:10),
                                          TextField(decoration: const InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: 'Correo Electrónico'),
                                                      onChanged: (value){
                                                            cedula = value;
                                                        },
                                                    ),
                                          const SizedBox(height:10),
                                          TextField(decoration: const InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: 'Titulo  '),
                                                      onChanged: (value){
                                                            cedula = value;
                                                        },
                                                    ),
                                          const SizedBox(height:20),


                            ],)
            );
  }

  Widget botones()
  {
    return Center(
              child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(onPressed: (){}, child: const Text('Guardar')),
                          ElevatedButton(onPressed: (){}, child: const Text('Limpiar')),
                        ]
                      ));
  }
}

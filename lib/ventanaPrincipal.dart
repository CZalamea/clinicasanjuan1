import 'package:clinicasanjuan/ventanaRSSFeed.dart';
import 'package:clinicasanjuan/ventanaRSSFeedElPais.dart';
import 'package:flutter/material.dart';
import 'ventanaPerfilUsuario.dart';
import 'ventanaConfiguraciones.dart';

class MyAppVentanaPrincipal extends StatelessWidget {
  const MyAppVentanaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const MyHomePageVentanaPrincipal(title: 'TAREA RSS FEED'),
    );
  }
}

class MyHomePageVentanaPrincipal extends StatefulWidget {
  const MyHomePageVentanaPrincipal({super.key, required this.title});

  final String title;

  @override
  State<MyHomePageVentanaPrincipal> createState() =>
      _MyHomePageStateVentanaPrincipal();
}

class _MyHomePageStateVentanaPrincipal
    extends State<MyHomePageVentanaPrincipal> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings_applications_outlined),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const MyAppVentanaConfiguracion()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amberAccent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.person_2),
              label: 'Perfil'),
          NavigationDestination(
              icon: Badge(child: Icon(Icons.rss_feed)), label: 'RSS CLARIN'),
          NavigationDestination(
              icon: Badge(
                child: Icon(Icons.rss_feed_outlined),
              ),
              label: 'RSS EL PAIS'),
        ],
      ),
      body: [
        const MyAppVentanaPerfilUsuario(),
        const MyAppVentanaRSSFeed(),
        MyAppVentanaRSSFeedElPais(),
      ][currentPageIndex],
    );
  }
}

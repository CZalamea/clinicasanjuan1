import 'package:clinicasanjuan/ventanaRSSFeed.dart';
import 'package:clinicasanjuan/MedicinasScreen.dart';
import 'package:flutter/material.dart';
import 'ventanaPerfilUsuario.dart';

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
      home: const MyHomePageVentanaPrincipal(title: 'PROYECTO DAM'),
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
              icon: Icon(Icons.local_pharmacy_rounded),
              label: 'FARMACIAS'),
          NavigationDestination(
              icon: Badge(child: Icon(Icons.rss_feed)), label: 'RSS MEDICO'),
          NavigationDestination(
              icon: Badge(
                child: Icon(Icons.medication_rounded),
              ),
              label: 'MEDICINAS'),
        ],
      ),
      body: [
        const MyAppVentanaPerfilUsuario(),
        const MyAppVentanaRSSFeed(),
        MedicinasScreen(),
      ][currentPageIndex],
    );
  }
}

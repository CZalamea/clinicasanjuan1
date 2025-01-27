import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MedicinasScreen extends StatefulWidget {
  @override
  _MedicinasScreenState createState() => _MedicinasScreenState();
}

class _MedicinasScreenState extends State<MedicinasScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("categorias");
  Map<String, dynamic> _categorias = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategorias();
  }

  Future<void> _fetchCategorias() async {
    try {
      final dataSnapshot = await _database.get();
      if (dataSnapshot.exists) {
        setState(() {
          _categorias = Map<String, dynamic>.from(dataSnapshot.value as Map);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar las categorías: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorías y Medicinas"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _categorias.isEmpty
              ? Center(child: Text("No hay categorías disponibles."))
              : ListView.builder(
                  itemCount: _categorias.length,
                  itemBuilder: (context, index) {
                    final categoria = _categorias.keys.elementAt(index);
                    final medicinas =
                        Map<String, dynamic>.from(_categorias[categoria]['medicinas']);
                    return ExpansionTile(
                      title: Text(categoria, style: TextStyle(fontWeight: FontWeight.bold)),
                      children: medicinas.entries.map((entry) {
                        return ListTile(
                          title: Text(entry.key),
                          subtitle: Text(entry.value['descripcion']),
                        );
                      }).toList(),
                    );
                  },
                ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class MyAppVentanaRSSFeedElPais extends StatefulWidget {
  const MyAppVentanaRSSFeedElPais({super.key});

  @override
  _MyAppVentanaRSSFeedElPais createState() => _MyAppVentanaRSSFeedElPais();
}

class _MyAppVentanaRSSFeedElPais extends State<MyAppVentanaRSSFeedElPais> {
  List<RssItem> _noticias = []; // Lista para almacenar las noticias completas
  bool _isLoading = true; // Indicador de carga
  String _errorMessage = ''; // Mensaje de error en caso de fallo

  @override
  void initState() {
    super.initState();
    _fetchFeed(); // Llama a la función para obtener el feed al iniciar la pantalla
  }

  // Función para obtener el feed RSS de El País
  Future<void> _fetchFeed() async {
    try {
      String elPaisUrl =
          'https://feeds.elpais.com/mrss-s/pages/ep/site/elpais.com/section/ultimas-noticias/portada';
      var response = await http.get(Uri.parse(elPaisUrl));

      if (response.statusCode == 200) {
        RssFeed feed = RssFeed.parse(response.body);
        setState(() {
          _noticias = feed.items ?? []; // Almacena todas las noticias
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Error al cargar el feed. Código: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Últimas Noticias - El País'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Muestra un indicador de carga
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage)) // Muestra un mensaje de error
              : ListView.builder(
                  itemCount: _noticias.length,
                  itemBuilder: (context, index) {
                    final item = _noticias[index];
                    return _NewsItem(item); // Usa el widget _NewsItem para mostrar cada noticia
                  },
                ),
    );
  }
}

// Widget para mostrar cada noticia
class _NewsItem extends StatelessWidget {
  final RssItem item;

  const _NewsItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        leading: item.media?.contents?.isNotEmpty == true
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  item.media!.contents!.first.url!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Si la imagen no se puede cargar, muestra un ícono de error
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              )
            : null, // Si no hay imagen, continuar con el diseño del `ListTile` sin imagen

        title: Text(
          item.title ?? 'Sin título',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _cleanDescription(item.description ?? 'Sin descripción'),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          // Aquí puedes agregar la lógica para abrir la noticia completa
        },
      ),
    );
  }

  String _cleanDescription(String description) {
    return utf8.decode(description.codeUnits).replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
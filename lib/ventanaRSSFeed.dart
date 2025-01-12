import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class MyAppVentanaRSSFeed extends StatelessWidget {
  const MyAppVentanaRSSFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const MyHomePageVentanaRSSFeed(title: 'Periódico Clarín'),
    );
  }
}

class MyHomePageVentanaRSSFeed extends StatefulWidget {
  const MyHomePageVentanaRSSFeed({super.key, required this.title});

  final String title;

  @override
  State<MyHomePageVentanaRSSFeed> createState() => _MyHomePageVentanaRSSFeedState();
}

class _MyHomePageVentanaRSSFeedState extends State<MyHomePageVentanaRSSFeed> {
  Future<RssFeed>? _feedFuture;

  @override
  void initState() {
    super.initState();
    _feedFuture = _fetchFeed();
  }

  // Función para obtener el feed RSS
  Future<RssFeed> _fetchFeed() async {
    try {
      final response = await http.get(Uri.parse('https://www.clarin.com/rss/lo-ultimo/'));
      if (response.statusCode == 200) {
        return RssFeed.parse(response.body);
      } else {
        throw Exception('Error al cargar el feed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<RssFeed>(
        future: _feedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.items == null || snapshot.data!.items!.isEmpty) {
            return const Center(child: Text('No hay datos disponibles'));
          } else {
            final feed = snapshot.data!;
            return _buildFeedList(feed);
          }
        },
      ),
    );
  }

  // Widget para construir la lista de noticias
  Widget _buildFeedList(RssFeed feed) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: feed.items!.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildFeedHeader(feed);
        }
        return _NewsItem(feed.items![index - 1]);
      },
    );
  }

  // Widget para el encabezado del feed (imagen y descripción)
  Widget _buildFeedHeader(RssFeed feed) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Row(
        children: [
          if (feed.image?.url != null)
            Image.network(
              feed.image!.url!,
              width: 150,
              height: 35,
              fit: BoxFit.cover,
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feed.description ?? 'Sin descripción',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsItem extends StatelessWidget {
  final RssItem item;

  const _NewsItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la noticia (si está disponible)
            if (item.enclosure?.url != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  item.enclosure!.url!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 12.0),
            // Contenido de la noticia (título, descripción y autor)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? 'Sin título',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    item.description?.split('<')[0] ?? 'Sin descripción',
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Autor: ${item.dc?.creator ?? 'Desconocido'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget independiente para mostrar cada ítem de noticia

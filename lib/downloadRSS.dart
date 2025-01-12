import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

Future<RssFeed> getFeed(String url) async {
  try {
    var response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      return RssFeed.parse(response.body);
    } else {
      throw Exception('Failed to load RSS feed. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching RSS feed: $e');
  }

}

void fetchMultipleFeeds() async {
  List<String> rssUrls = [
    'https://www.clarin.com/rss/lo-ultimo/',
    'https://feeds.elpais.com/mrss-s/pages/ep/site/elpais.com/section/ultimas-noticias/portada',
  ];

  for (String url in rssUrls) {
    try {
      RssFeed feed = await getFeed(url);
      print('Feed from $url:');
      feed.items?.forEach((item) {
        print('- ${item.title}');
      });
    } catch (e) {
      print('Error fetching feed from $url: $e');
    }
  }
}



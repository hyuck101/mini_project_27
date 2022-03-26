import 'package:intl/intl.dart';

class News {
  String title;
  String link;
  String time;

  News({required this.title, required this.link, required this.time});

  factory News.fromsJson(Map<String, dynamic> item) {
    String text = item['title'] ?? '';
    text = text.replaceAll('<b>', '');
    text = text.replaceAll('</b>', '');
    text = text.replaceAll('&quot;', '');

    return News(
        title: text, link: item['link'] ?? "", time: item['pubDate'] ?? "");
  }
}

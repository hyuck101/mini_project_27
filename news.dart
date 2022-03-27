import 'package:intl/intl.dart';

class News {
  String title;
  String link;
  String time;
  String description;

  News(
      {required this.title,
      required this.link,
      required this.time,
      required this.description});

  factory News.fromsJson(Map<String, dynamic> item) {
    String text = item['title'] ?? '';
    text = text.replaceAll('<b>', '');
    text = text.replaceAll('</b>', '');
    text = text.replaceAll('&quot;', '');

    String dec = item['description'] ?? "";
    dec = dec.replaceAll('<b>', '');
    dec = dec.replaceAll('</b>', '');
    dec = dec.replaceAll('&quot;', '');

    return News(
        title: text,
        link: item['link'] ?? "",
        time: item['pubDate'] ?? "",
        description: dec);
  }
}

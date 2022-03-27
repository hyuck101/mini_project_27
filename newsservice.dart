import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mini_project27/news.dart';

class NewsService extends ChangeNotifier {
  NewsService() {
    getNewsData('경제');
  }
  List<News> newsList = [];

  void getNewsData(String q) async {
    newsList.clear();
    String url =
        'https://openapi.naver.com/v1/search/news.json?query=$q&display=20&start=1&sort=sim';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "X-Naver-Client-Id": "Y8DvdLki1KqA7wcCiTxP",
        "X-Naver-Client-Secret": "YoAWYV9gih",
      },
    );
    final map = jsonDecode(response.body).cast<String, dynamic>();

    final items = map['items'] ?? [];

    for (Map<String, dynamic> item in items) {
      News news = News.fromsJson(item);
      newsList.add(news);
    }

    print(newsList);
    notifyListeners();
  }
}

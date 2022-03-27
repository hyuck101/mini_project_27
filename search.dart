import 'package:flutter/material.dart';
import 'package:mini_project27/main.dart';
import 'package:mini_project27/news.dart';
import 'package:mini_project27/newsservice.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsService>(
      builder: (context, newsService, child) {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomePage(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  "NEWSDAILY",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              actions: [
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    "total${newsService.newsList.length}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size(double.infinity, 80),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: "내용을 입력해주세요.",
                        // 테두리
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),

                        /// 돋보기 아이콘
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search, color: Colors.black),
                          onPressed: () {
                            // 돋보기 아이콘 클릭
                            newsService
                                .getNewsData(_textEditingController.text);
                          },
                        ),
                      ),
                      onSubmitted: (v) {
                        // 엔터를 누르는 경우
                        newsService.getNewsData(_textEditingController.text);
                      },
                    ),
                  ),
                ),
              ),
            ),
            body: newsService.newsList.isEmpty
                ? Center(
                    child: Text(
                    '검색어를 입력해 주세요',
                    style: TextStyle(fontSize: 21, color: Colors.grey),
                  ))
                : ListView.separated(
                    itemBuilder: (coontext, index) {
                      News news = newsService.newsList[index];
                      return ListTile(
                        leading: Text('${index + 1}'),
                        title: Text(news.title),
                        subtitle: Text(news.description),
                        onTap: () {
                          launch(news.link);
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 9,
                        color: Colors.black,
                      );
                    },
                    itemCount: newsService.newsList.length));
      },
    );
  }
}

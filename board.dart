import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project27/auth_service.dart';
import 'package:mini_project27/board_service.dart';
import 'package:mini_project27/main.dart';
import 'package:provider/provider.dart';

class Board extends StatefulWidget {
  Board({Key? key}) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return Consumer<BoardService>(
      builder: (context, boardService, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            title: Text(
              'NEWSDAILY',
              style: TextStyle(fontSize: 35, color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            boardService.create(
                                _textEditingController.text, user.uid);
                            _textEditingController.clear();
                          },
                          icon: Icon(Icons.plus_one)),
                      hintText: '내용을 입력해 주세요',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                  child: FutureBuilder<QuerySnapshot>(
                future: boardService.read(user.uid),
                builder: (context, snapshot) {
                  final docs = snapshot.data?.docs ?? []; // 문서들 가져오기
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      String uid = doc.get('uid');
                      String content = doc.get('content');
                      return ListTile(
                        title: Text(content),
                        trailing: IconButton(
                          onPressed: () {
                            boardService.delete(doc.id);
                          },
                          icon: Icon(CupertinoIcons.delete),
                        ),
                      );
                    },
                  );
                },
              ))
            ],
          ),
        );
      },
    );
  }
}

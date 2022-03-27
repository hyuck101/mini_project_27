import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BoardService extends ChangeNotifier {
  final BoardCollection = FirebaseFirestore.instance.collection('mini27');

  Future<QuerySnapshot> read(String uid) async {
    // 내 bucketList 가져오기
    return BoardCollection.where('uid', isEqualTo: uid).get();
  }

  void create(String content, String uid) async {
    // bucket 만들기

    await BoardCollection.add({
      'uid': uid, // 유저 식별자
      'content': content, // 하고싶은 말
    });
    notifyListeners(); // 화면 갱신
  }

  void update(String docId, String content) async {
    // bucket isDone 업데이트
  }

  void delete(String docId) async {
    // bucket 삭제

    await BoardCollection.doc(docId).delete();
    notifyListeners(); // 화면 갱신
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  String? title;
  String? content;
  String? id;

  NotesModel({this.title, this.content, this.id});


  static NotesModel fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    // print("======================================12122");

    final title = e.data()["title"];
    final content = e.data()["content"];
    final id = e.data()["id"];
    // print(title);
    // print("======================================");
    // return NotesModel(title, content, id);
return NotesModel(title: title, content: content, id: id);

  }
  // fromSnapshots(){
  //
  // }

}
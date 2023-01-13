import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNotes extends StatefulWidget {
   const AddNotes({Key? key}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance.collection("notes");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
               final document = ref.doc();
               document.set({
                 "title": title.text,
                 "content": content.text,
                 "id": document.id,
               }).then((value) => Navigator.pop(context));
              // .then(() => Navigator.pop(context));
              },
              child: const Text("Save",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
            ),
            child: TextField(
              controller: title,
              decoration: const InputDecoration(
                hintText: "Title",
              ),
            ),
          ),
          // const SizedBox(height: 10,),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
              ),
              child: TextField(
                controller: content,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: "Content",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/model/notes_model.dart';
import 'package:notes/ui/posts/home_screen.dart';

class EditNotes extends StatefulWidget {
  NotesModel docToEdit;


  EditNotes({Key? key, required this.docToEdit}) : super(key: key);

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();


  final ref = FirebaseFirestore.instance.collection('notes');

  @override
  void initState() {

    // title = TextEditingController(text: ref.doc("title").get().toString());
    // content = TextEditingController(text: ref.doc("title").get().toString());

    title = TextEditingController(text: widget.docToEdit.title);
    content = TextEditingController(text: widget.docToEdit.content);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        ),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {

              // final provider = Provider.of<EditNotesProvider>(context, listen: false);
              // provider.updateNotes();
              // Navigator.pop(context);

              ref.doc(widget.docToEdit.id).update(
                  {
                "title": title.text,
                "content": content.text,
              }).whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen())));
            },
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.doc(widget.docToEdit.id).delete().whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen())));
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
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

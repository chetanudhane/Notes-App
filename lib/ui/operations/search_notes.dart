
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/model/notes_model.dart';
import 'package:notes/ui/posts/home_screen.dart';

class SearchNotes extends StatefulWidget {
  const SearchNotes({Key? key}) : super(key: key);

  @override
  State<SearchNotes> createState() => _SearchNotesState();
}

class _SearchNotesState extends State<SearchNotes> {

  final ref = FirebaseFirestore.instance.collection('notes');

  Icon cusIcon = const Icon(Icons.search);
  Widget cusSearchBar = const Text("Notes");

  static List<NotesModel> list = [];

  fetchNotes() async {
    final snapshot= await ref.get();
    debugPrint("**************************************${snapshot.docs.length}");
    // snapshot.docs.map((e) => NotesModel.fromQuerySnapshot(e));
    for (var element in snapshot.docs) {
      final note = NotesModel.fromQuerySnapshot(element);
      list.add(note);
    }
    debugPrint("**************************************${list.toString()}");
  }
  @override
  void initState() {
    fetchNotes();
    // TODO: implement initState
    super.initState();
  }

  List<NotesModel> displayList = List.from(list);

  void updateList(String value) {

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          alignment: Alignment.centerRight,
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if(cusIcon.icon == Icons.search) {
                  cusIcon = const Icon(Icons.cancel);
                  cusSearchBar = TextField(
                    onChanged: (value) {},
                    textInputAction: TextInputAction.go,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Notes Here"
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  );
                }else {
                  cusIcon = const Icon(Icons.search);
                  cusSearchBar = const Text("Notes");
                }
              });
            },
            icon: cusIcon,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Search For Notes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Type Title",
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Colors.purple.shade900,
              ),
            ),
            const SizedBox(height: 20.0,),
            Expanded(
                child: FutureBuilder<QuerySnapshot>(
                    future: ref.get(),
                    builder: (context, snapshot){
                      return ListView.builder(
                          itemCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
                          itemBuilder: (context, index){
                            // Random random = Random();
                            // Color bg = colors[random.nextInt(4)];
                            return Column(
                              children: [
                                Text(snapshot.data!.docs[index].get("title"),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                    fontSize: 32.0,
                                  ),),
                                Text(snapshot.data!.docs[index].get("content"),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54,
                                    fontSize: 25.0,
                                  ),),
                              ],
                            );

                          });
                    }),
            ),
          ],
        ),
      ),
    );
  }
}

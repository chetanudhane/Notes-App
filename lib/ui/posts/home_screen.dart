import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/model/notes_model.dart';
import 'package:notes/provider/shared_pref_provider.dart';
import 'package:notes/ui/auth/login_screen.dart';
import 'package:notes/ui/operations/add_notes.dart';
import 'package:notes/ui/operations/edit_notes.dart';
import 'package:notes/ui/posts/trash_screen.dart';
import 'package:notes/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseFirestore.instance.collection('notes');
  DocumentSnapshot? lastDocument;
  List<NotesModel> list = [];
  final ScrollController scrollController = ScrollController();

  bool isInSearchMode = false;
  bool isLoadingData = false;
  bool hasMoreData = true;

  List<Color> colors = [
    Colors.yellow.shade100,
    Colors.red.shade100,
    Colors.green.shade100,
    Colors.deepPurple.shade100,
  ];

  Icon cusIcon = const Icon(Icons.search);
  Widget cusSearchBar = const Text("Notes");

  void paginatedData() async {
    if (hasMoreData) {
      setState(() {
        isLoadingData = true;
      });
      late QuerySnapshot<Map<String, dynamic>> querySnapshot;

      if (lastDocument == null) {
        querySnapshot = await ref.limit(11).get();
      } else {
        querySnapshot = await ref
            .limit(10)
            .startAfterDocument(lastDocument!)
            .get();
      }
      lastDocument = querySnapshot.docs.last;
      for (var element in querySnapshot.docs) {
        final note = NotesModel.fromQuerySnapshot(element);
        list.add(note);
        // list.add(note);
      }
      isLoadingData = false;
      debugPrint("++++++++++++++++++++++++++++++${list.length}");
      setState(() {});

      if (querySnapshot.docs.length < 11) {
        hasMoreData = false;
      }
    } else {
      debugPrint("No More data");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paginatedData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        paginatedData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    list.clear();
    super.dispose();
  }

  List<NotesModel> filteredList = [];

  void updateList(String value) {
    setState(() {
      filteredList = list
          .where((element) =>
              element.title!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  if (cusIcon.icon == Icons.search) {
                    cusIcon = const Icon(Icons.cancel);
                    cusSearchBar = TextField(
                      onChanged: (value) {
                        isInSearchMode = value.isNotEmpty;
                        updateList(value);
                      },
                      textInputAction: TextInputAction.go,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search Notes Here"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    );
                  } else {
                    cusIcon = const Icon(Icons.search);
                    cusSearchBar = const Text("Notes");
                  }
                });
              },
              icon: cusIcon,
            ),
            IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  SharedPreferencesProvider.logOutUser();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout_outlined),
            ),
          ],
          title: cusSearchBar,
        ),
        drawer: Drawer(
          backgroundColor: Colors.grey,
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.deepPurpleAccent),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 50.0,
                  ),
                  child: Text(
                    "Notes",
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              ListTile(
                selected: true,
                selectedColor: Colors.greenAccent,
                // selectedTileColor: Colors.green,
                title: const Text(
                  "Notes",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                },
              ),
              ListTile(
                title: const Text(
                  "Trash",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => TrashScreen()));
                },
              ),
              const Divider(
                thickness: 1.0,
              ),
              ListTile(
                title: const Text(
                  "Manage Notebooks",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                onTap: () {
                  debugPrint("Manage Notebooks");
                },
              ),
              ListTile(
                title: const Text(
                  "Setting",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                onTap: () {
                  debugPrint("Setting");
                },
              ),
              ListTile(
                title: const Text(
                  "Help",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                onTap: () {
                  debugPrint("Get Help");
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddNotes()));
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                  itemCount:
                      !isInSearchMode ? list.length : filteredList.length,
                  itemBuilder: (context, index) {
                    Random random = Random();
                    Color bg = colors[random.nextInt(4)];
                    final note =
                        !isInSearchMode ? list[index] : filteredList[index];
                    return ListTile(
                      focusColor: bg,
                      contentPadding: const EdgeInsets.all(8),
                      title: Text(
                        note.title!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 32.0,
                        ),
                      ),
                      subtitle: Text(note.content!,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black54,
                            fontSize: 25.0,
                          )),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditNotes(docToEdit: note)));
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    );
                  }),
            ),
            isLoadingData ? const Center(child: CircularProgressIndicator(),) : const SizedBox(),
          ],
        ));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/provider/shared_pref_provider.dart';
import 'package:notes/ui/auth/login_screen.dart';
import 'package:notes/ui/posts/home_screen.dart';
import 'package:notes/utils/utils.dart';

class TrashScreen extends StatelessWidget {
  TrashScreen({Key? key}) : super(key: key);

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trash"),
        actions: [
          IconButton(
            onPressed: () {

              },
            icon: const Icon(Icons.search),
          ),
          // IconButton(
          //   onPressed: () {
          //     debugPrint("Add Notes");
          //   },
          //   icon: const Icon(Icons.add_box),
          // ),
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
          const SizedBox(
            width: 10.0,
          ),
        ],
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
              // selected: true,
              // selectedColor: Colors.greenAccent,
              // selectedTileColor: Colors.green,
              title: const Text(
                "Notes",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) =>  const HomeScreen()));
              },
            ),
            ListTile(
              selected: true,
              selectedColor: Colors.greenAccent,
              title: const Text(
                "Trash",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TrashScreen()));
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
    );
  }
}

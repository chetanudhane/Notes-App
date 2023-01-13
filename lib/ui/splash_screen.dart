import 'package:flutter/material.dart';
import 'package:notes/firebase_services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    super.initState();
    splashServices.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Icon(
        Icons.event_note,
        size: 250,
        color: Colors.deepPurple,
      )
          // Text("Notes", style: TextStyle(
          //   fontSize: 30,
          // ),),
          ),
    );
  }
}

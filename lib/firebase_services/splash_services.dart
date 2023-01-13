import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes/helper/shared_pref_helper.dart';
import 'package:notes/ui/auth/login_screen.dart';
import 'package:notes/ui/posts/home_screen.dart';

class SplashServices {
  Future<void> isLogin(BuildContext context) async {
    Future.delayed(const Duration(seconds: 3), () async {
      final token = await SharedPreferencesHelper().getAuthToken();

      if (token != null && token.isNotEmpty) {
        Navigator.push((context),
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        Navigator.push((context),
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }
}

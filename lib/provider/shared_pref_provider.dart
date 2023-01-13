import 'package:notes/helper/shared_pref_helper.dart';

class SharedPreferencesProvider {
  static Future<void> loginUser() async {
    String token = "aaa";
    await SharedPreferencesHelper.setAuthToken(token);
  }

  static Future<void> logOutUser() async {
    // String token = "aaa";
    await SharedPreferencesHelper.removeAuthToken();
  }
}

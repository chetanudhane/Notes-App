import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<bool> setAuthToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(UserPref.authToken.toString(), token);
  }

  static Future<bool> removeAuthToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(UserPref.authToken.toString(), "");
  }

  Future<String?> getAuthToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(UserPref.authToken.toString());
    // return pref.getString(UserPref.authToken.toString());
  }
}

enum UserPref {
  authToken,
}

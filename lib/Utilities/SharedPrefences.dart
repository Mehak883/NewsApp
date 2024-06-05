// ignore_for_file: file_names, avoid_print

import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreference {
  static Future<bool> saveCredentials(String email, String password) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("email", email);
      await preferences.setString("password", password);
      return true;
    } catch (e) {
      print("Error saving credentials: $e");
      return false;
    }
  }

  static Future<bool> authenticateUser(String email, String password) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? savedEmail = preferences.getString("email");
      String? savedPassword = preferences.getString("password");
      return email == savedEmail && password == savedPassword;
    } catch (e) {
      print("Error saving credentials: $e");
      return false;
    }
  }
}

// ignore_for_file: file_names, avoid_print
import 'package:flutter/foundation.dart';
import 'package:newsapp/Models/Model.dart';
import 'package:newsapp/Utilities/FirebaseDatabase.dart';

class GreetProv with ChangeNotifier {
  String _greet = '';
  String get greet => _greet;
  String _name = '';
  // String get name => _name;
  // ignore: unused_field
  String _email = '';
  // String get email => _email;

  void setGreet() {
    int hour = DateTime.now().hour;
    if (hour > 5 && hour < 12) {
      _greet = 'Good Morning';
    } else if (hour >= 12 && hour < 14) {
      _greet = 'Good Noon';
    } else if (hour >= 14 && hour < 17) {
      _greet = 'Good AfterNoon';
    } else if (hour >= 17 && hour < 20) {
      _greet = 'Good Evening';
    } else {
      _greet = 'Good Night';
    }
    notifyListeners();
  }

  Future<String> userInfor() async {
    try {
      Usermodel user = await FirebaseStore.userInfo();
      print("greet ${user.name}");
      _name = user.name ?? '';
      print("name : ${Future.value( _name.toString())}");
      _email = user.email ?? '';

      return _name;
    } catch (e) {
      print("An Error Occured");
    }
    return '';
  }
}

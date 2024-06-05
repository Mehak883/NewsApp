// ignore_for_file: void_checks, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newsapp/Providers/GreetProv.dart';
import 'package:newsapp/Providers/NewsProv.dart';
import 'package:newsapp/Screens/BodyScreens/Home.dart';

import 'package:newsapp/Screens/LoginScreens/Signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newsapp/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String keyLogin = 'login';

  Future<bool> stateChange() async {
    try {
      var sharedPref = await SharedPreferences.getInstance();
      var isLoggedIn = sharedPref.getBool(keyLogin);
      print("print => ${sharedPref.getBool(keyLogin)}");
      if (isLoggedIn != null) {
        print("ho");
        return isLoggedIn;
      }
      return false;
    } catch (e) {
      print('An Error Occured $e');
      return false;
    }
  }

  bool futureBoolConv() {
    bool log =true ;
    stateChange().then((value) => log = value);
    print('futureBoolConv = > $log');
    return log;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GreetProv()),
          ChangeNotifierProvider(create: (_) => NewsProv())
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            // theme: ThemeData(
            //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            //   useMaterial3: true,
            // ),
            home: futureBoolConv() ? const Home() : const Signup()));
  }
}

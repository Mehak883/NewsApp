import 'package:flutter/material.dart';
import 'package:newsapp/Providers/GreetProv.dart';
import 'package:newsapp/Providers/NewsProv.dart';

import 'package:newsapp/Screens/LoginScreens/Signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newsapp/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GreetProv()),
          ChangeNotifierProvider(create: (_)=> NewsProv())
        ],
        child:const MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            // theme: ThemeData(
            //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            //   useMaterial3: true,
            // ),
            home: Signup()));
  }
}

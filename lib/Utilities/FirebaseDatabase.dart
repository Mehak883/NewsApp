// ignore_for_file: avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapp/Models/Model.dart';

final FirebaseFirestore store = FirebaseFirestore.instance;
final CollectionReference reference = store.collection("Users");
final CollectionReference newsref = store.collection("News");

class FirebaseStore {
  static Future createUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e;
    }
  }

  static Future signinUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e;
    }
  }

  static Future<Usermodel> userInfo() async {
    var doc = await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Usermodel user = Usermodel.fromDocument(doc);
    print(user.email);
    print(user.name);

    return user;
  }

  static Future<List<Newsmodel>> getQueryData(String type) async {
    try {
      var querySnapshot = await store
          .collection('News')
          .doc('FToQXviFMx6ADrx1ul1X')
          .collection(type)
          .get();

      List<Newsmodel> newslist = [];
      if (querySnapshot.docs.isNotEmpty) {
        // ignore: avoid_function_literals_in_foreach_calls
        querySnapshot.docs.forEach((doc) {
          // ignore: unnecessary_cast
          Newsmodel a = Newsmodel.fromDocument(doc);
          newslist.add(a);
          // print(a);
        });
      }
      if (newslist.isEmpty) {
        return [];
      }
      return newslist;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<Newsmodel>> getLatestData(String type) async {
    try {
      var querySnapshot = await store
          .collection('News')
          .doc('FToQXviFMx6ADrx1ul1X')
          .collection(type)
          .orderBy('ntime', descending: true)
          .get();

      List<Newsmodel> newslist = [];
      if (querySnapshot.docs.isNotEmpty) {
        // ignore: avoid_function_literals_in_foreach_calls
        querySnapshot.docs.forEach((doc) {
          // ignore: unnecessary_cast
          Newsmodel a = Newsmodel.fromDocument(doc);
          newslist.add(a);
          // print(a);
        });
      }
      if (newslist.isEmpty) {
        return [];
      }
      return newslist;
    } catch (e) {
      print(e);
      return [];
    }
  }
}

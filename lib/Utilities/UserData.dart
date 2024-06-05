// ignore_for_file: avoid_print, non_constant_identifier_names, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newsapp/Models/Model.dart';
import 'dart:developer';
final FirebaseFirestore store = FirebaseFirestore.instance;
final CollectionReference reference = store.collection("User");

class UserData {
  static userdata(String uid, String email, String name) async {
    Usermodel d = Usermodel(uid: uid, email: email, name: name);
    try {
      await store.collection("User").doc(uid).set(d.toMap());
    } catch (e) {
      print(e);
      log(e.toString());
    }
  }
  
}

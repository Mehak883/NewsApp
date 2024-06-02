import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore store = FirebaseFirestore.instance;
final CollectionReference reference = store.collection("Users");

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
}

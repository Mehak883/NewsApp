// ignore_for_file: use_build_context_synchronously, avoid_unnecessary_containers, avoid_print, file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newsapp/Screens/BodyScreens/Home.dart';
import 'package:newsapp/Utilities/FirebaseDatabase.dart';
import 'package:newsapp/widgets/CustomWidget.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:newsapp/Screens/LoginScreens/Login.dart';
import 'package:newsapp/Utilities/UserData.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formkey1 = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController cpass = TextEditingController();

  Future<UserCredential?> signUpWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        await UserData.userdata(FirebaseAuth.instance.currentUser!.uid,
            userCredential.user!.email.toString(), name.text);
        await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Home(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      }
      // Once signed in, return the UserCredential
    } on FirebaseAuthException catch (e) {
      CustomSnackBar.showSnackBar(context, "ok", () => {}, e.code.toString());
    }
    return null;
  }

  // Future<void> moveToSignup() async {}
  Future<void> moveToSignup() async {
    print("Success");
    if (_formkey1.currentState != null && _formkey1.currentState!.validate()) {
      var result = await FirebaseStore.createUser(email.text, pass.text.trim());
      print(result);
      if (result == true) {
        print('hloo');
        // var SharedPref = await SharedPreferences.getInstance();
        // SharedPref.setBool(splash_screenState.KEYLOGIN, true);
        await UserData.userdata(
            FirebaseAuth.instance.currentUser!.uid, email.text, name.text);

        // context.go('/');

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Home(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );

        print("Succes");
      } else if (result is String) {
        String errorCode = result;
        if (errorCode == "invalid-email") {
          CustomSnackBar.showSnackBar(
              context, "ok", () => {}, "Please Enter a Valid Email");
        } else if (errorCode == "email-already-in-use") {
          CustomSnackBar.showSnackBar(
              context, "ok", () => {}, "User Already Exist");
        } else if (errorCode == 'weak-password') {
          CustomSnackBar.showSnackBar(context, "ok", () => {}, "Weak Password");
        } else if (errorCode == 'network-request-failed') {
          CustomSnackBar.showSnackBar(
              context, "Ok", () => null, "Pleace Check Your Internet ");
        }
      } else {
        print('hii');
        // context.go('/signup_screen');
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => Home(),
        //     ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Form(
          key: _formkey1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 3,
                  child: SvgPicture.asset(
                    'assets/sign_up.svg',
                    colorFilter: const ColorFilter.mode(
                        Color.fromARGB(255, 52, 81, 105), BlendMode.modulate),
                  )),
              Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: name,
                        decoration: const InputDecoration(
                            label: Text('Name'),
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 52, 81, 105))),
                            hintText: 'Mehak dhawan'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name can not be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                            label: Text('Email'),
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 52, 81, 105))),
                            hintText: 'dhawanmehak10@gmail.com'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email can not be empty";
                          } else if (value.contains('@') == false) {
                            return "Please enter a valid Email";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          controller: pass,
                          decoration: const InputDecoration(
                              label: Text('Password'),
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 52, 81, 105))),
                              hintText: 'Mehak123@456'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password can not be empty";
                            } else if (value.length < 6) {
                              return "Password should be greater then 6 digits";
                            } else {
                              return null;
                            }
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: cpass,
                        obscureText: true,
                        decoration: const InputDecoration(
                            label: Text('Confirm Password'),
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 52, 81, 105))),
                            hintText: 'Mehak123@456'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password can not be empty";
                          } else if (value.length < 6) {
                            return "Password Should Be Greater Then 6 Digits";
                          } else if (value != pass.text) {
                            return "Password Match Failed";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomElevatedButton(
                        message: "Sign Up",
                        function: moveToSignup,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: const Divider(
                                thickness: 1,
                                color: Colors.black,
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text('or'),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: const Divider(
                                thickness: 1,
                                color: Colors.black,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SignInButton(
                        Buttons.google,
                        text: 'Sign up with Google',
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 72, vertical: 10),
                        onPressed: () {
                          signUpWithGoogle();
                        },
                        // icon: ,
                      ),
                      Row(children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                        ),
                        const Text("Already have an account ?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ));
                          },
                          child: const Text("Sign In"),
                        ),
                      ])
                    ],
                  ),
                ),
              ),
            ],
          )),
    )));
  }
}

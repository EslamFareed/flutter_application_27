import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailCon = TextEditingController();
  final passCon = TextEditingController();
  Future<UserCredential> signInWithGoogle() async {
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

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            controller: emailCon,
          ),
          TextField(
            controller: passCon,
          ),
          MaterialButton(
            onPressed: () {
              FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: emailCon.text, password: passCon.text)
                  .then((value) {
                print(value.user!.email);
              }).catchError((error) {
                print(error);
              });
            },
            child: const Text("create user"),
            color: Colors.deepOrange,
          ),
          MaterialButton(
            onPressed: () {
              FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: emailCon.text, password: passCon.text)
                  .then((value) {
                print(value.user!.email);
              }).catchError((error) {
                print(error);
              });
            },
            child: const Text("Login user"),
            color: Colors.deepOrange,
          ),
          MaterialButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: const Text("Logout user"),
            color: Colors.deepOrange,
          ),
          MaterialButton(
            onPressed: () {
              signInWithGoogle();
            },
            child: const Text("Sign in with google"),
            color: Colors.deepOrange,
          ),
          MaterialButton(
            onPressed: () {
              FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: emailCon.text,
                verificationCompleted: (PhoneAuthCredential credential) {
                  FirebaseAuth.instance.signInWithCredential(credential);
                },
                verificationFailed: (FirebaseAuthException e) {
                  print(e.toString());
                },
                codeSent: (String verificationId, int? resendToken) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Column(
                            children: [
                              TextField(
                                controller: passCon,
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  // Update the UI - wait for the user to enter the SMS code
                                  String smsCode = passCon.text;

                                  // Create a PhoneAuthCredential with the code
                                  PhoneAuthCredential credential =
                                      PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: smsCode,
                                  );

                                  // Sign the user in (or link) with the credential
                                  await FirebaseAuth.instance
                                      .signInWithCredential(credential);
                                },
                                child: Text("Verify  Code"),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                codeAutoRetrievalTimeout: (String verificationId) {},
                timeout: const Duration(seconds: 30),
              );
            },
            child: const Text("Using Phone"),
            color: Colors.deepOrange,
          )
        ],
      ),
    );
  }
}

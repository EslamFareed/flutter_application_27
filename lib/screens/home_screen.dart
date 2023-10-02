import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_27/screens/login_screen.dart';
import 'package:overlay_support/overlay_support.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final auth = FirebaseAuth.instance;

  void checkLogin(context) {
    auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
      } else {
        print(user.uid);
      }
    });
  }

  final db = FirebaseFirestore.instance;

  _getDataOnce() {
    db.collection("users").get().then((value) {
      for (var element in value.docs) {
        print(element.data());
        print(element.id);
      }
    });
  }

  _getDataStream() {
    return db.collection("users").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    checkLogin(context);
    // _getDataOnce();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            auth.signOut();
            // showSimpleNotification(
            //   Text("this is a message from simple notification"),
            //   background: Colors.green,
            //   autoDismiss: false,
            // );
            //Add
            // db.collection("users").add({
            // "email": "reemZefta@neela.com",
            // "password": "123456789",
            // });

            //! set
            // db.collection("users").doc("JiNFf32xEEbKw7RuOdSj").set({
            //   "email": "reemZefta@neela.com",
            //   "password": "751225412358129512691259",
            // });

            //! update
            // db.collection("users").doc("JiNFf32xEEbKw7RuOdSj").update({
            //   "email": "es@es.com",
            // });

            //! delete
            // db.collection("users").doc("JiNFf32xEEbKw7RuOdSj").delete();

            //! where query
            // db.collection("users").where(field)
          },
          child: const Text("Add User"),
        ),
      ),
      // body: StreamBuilder(
      //   stream: db.collection("users").snapshots(),
      //   builder: (context, snapshot) {
      //     for (var element in snapshot.data!.docs) {
      //       print(element.data());
      //     }

      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return CircularProgressIndicator();
      //     }
      //     return Text("data");
      //   },
      // ),
    );
  }
}

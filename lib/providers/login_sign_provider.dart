import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class LoginSignProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  // String emailFinding = "";
  // bool result = false;

  // Future<String> getUserEmail(String username) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   final userdata = await FirebaseFirestore.instance
  //       .collection('user')
  //       .doc(user!.uid)
  //       .get();
  //   return userdata["email"];
  // }

  Future<Map<String, dynamic>> findUserAvailable(String username) async {
    // bool foundUser = false;
    Map<String, dynamic> theMap = {};
    // print(username);
    // final user = FirebaseAuth.instance.currentUser;
    final collectionUsers = FirebaseFirestore.instance.collection('user');
    final userAvailable = await collectionUsers.get(); //this dapatkan all
    final allData = userAvailable.docs.map((e) => e.data()).toList();
    for (var element in allData) {
      // print(element['username']);
      if (element['username'] == username) {
        // foundUser = true;
        theMap = {
          'username': element['username'],
          'email': element['email'],
        };
      }
    }
    return theMap;
  }

  Future<void> createUser(
    String username,
    String email,
    String password,
    String phoneNo,
    DateTime birthDate,
    BuildContext context,
  ) async {
    UserCredential userCredential;

    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final userSignUp = FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user!.uid);

      final user = UserModel(
        username: username,
        email: email,
        password: password,
        uid: userCredential.user!.uid,
        phoneNo: phoneNo,
        birthDate: birthDate,
      );
      final json = user.toJson();
      await userSignUp.set(json);
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          },
        );
      }
    }
  }

  void loginUser(String username, String password, BuildContext context) async {
    if (username == '' || password == '') {
      return;
    }

    var result = await findUserAvailable(username);
    // print(result);

    // if (result) {
    //   emailFinding = await getUserEmail(username);
    // }
    try {
      await _auth.signInWithEmailAndPassword(
          email: result['email'], password: password);
    } catch (e) {
      // print(e.runtimeType);

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("wrong password or username"),
            );
          },
        );
      }
    }
  }

  Future<String> fetchUser() async {
    String username = "";
    var stringUsername = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    username = stringUsername.data()!["username"];
    return username;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class UserGoogle {
  static User? user = FirebaseAuth.instance.currentUser;
  static String pfp = '';

  Future<User?> loginWithGoogle() async{
    final googleAccount = await GoogleSignIn().signIn(); // asks for sign in

    // the rest will attempt to authenticate and retrieve values
    final googleAuth = await googleAccount?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential
    );

    // returns instance of user, which contains user info
    return userCredential.user;
  }


  Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
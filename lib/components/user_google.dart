import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/components/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class UserGoogle {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  static User? user;
  /// Returns a user that was logged in through Google and authorized by Firebase. This user is also present in the Firestore database
  Future<User?> loginWithGoogle({reLogin = false, path}) async{
    final googleAccount = await GoogleSignIn().signIn(); // asks for sign in

    // the rest will attempt to authenticate and retrieve values
    if (googleAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleAccount.authentication;


      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;
        String userID = auth.currentUser!.uid.toString();
        String userName = user!.displayName.toString();
        String userEmail = user!.email.toString();
        String userNumber = user!.phoneNumber.toString();

        if(reLogin == true){
          await db.doc(path).update({'firebaseUID': userID});
        } else {
          QuerySnapshot<Map<String,dynamic>> data = await db.collection('accountLink').get();
          final documents = data.docs.map((userdoc) => <String,dynamic> {'id': userdoc.id, 'firebaseUID': userdoc['firebaseUID'], 'userdocID': userdoc['userdocID']}).toList();
          bool foundDoc = false;
          for(int i = 0; i < documents.length; i++){
            if(documents[i]['firebaseUID'] == userID){
              foundDoc = true;
              break;
            }
          }
          // if user doesnt exist, make new user doc(docid not based on anything), then create accountLink doc with reference to user doc
          if(!foundDoc){
            final userInstance = <String, dynamic>{
              "affiliation":'Friend of Cats',
              "email": userEmail,
              "isAdmin": false,
              "name": userName,
              "phoneNumber": userNumber,
              "rescueGroupAffiliaton":'N/A'
              
            };// add new user

            await db.collection('users').add(userInstance).then(
              (DocumentReference doc) async {
                final accountInstance = <String, dynamic>{
                  "firebaseUID": userID,
                  "userdocID": doc
                };

                await db.collection('accountLink').add(accountInstance);
              }
            );
          }
        } 

      } on FirebaseAuthException catch (e) {
        print("Something when wrong");
      } catch (e) {
        print("Something when wrong");
      }
    }
    // returns instance of user, which contains user info
    return user;
  }

  /// Returns a user instance 
  static getUser(){
    if(user != null){
      return user!;
    } else {
      return null;
    }
    
  }

  /// Makes a user of the current Firebase instance and current logged in Google user sign out
  static Future<void> signOut({bool reLogin = false}) async{
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();
    if(reLogin == false){
      runApp( // dont make const, causes more errors
        MaterialApp(
          home: LoginPage(),
        )
      );
    }
  }
  /// Allows for information associated with one user to be transfer to a different email while also authorizing said new email
  Future<void> reLogin(String newEmail, String? name, String? number, String? affiliation, String? rescueGroup) async{
    // get document of user
    // get firebase ID of new user
    // change firebaseID from accountLink to new user
    var id = auth.currentUser?.uid.toString(); // gets FirebaseID
    var docID = await UserGoogle().db.collection('accountLink').where('firebaseUID', isEqualTo:  id).get(); // gets accountLink document based on FirebaseID
    var document = docID.docs.first;
    await signOut(reLogin:true); // sign out
    await loginWithGoogle(reLogin:true,path: document.reference.path); // log in with new email
    // using reference from accountLink document, change user document
    await db.doc(document.get('userdocID').path).update({'email': auth.currentUser!.email, 'name': name, 'phoneNumber': number, 'affiliation': affiliation, 'rescueGroupAffiliaton':rescueGroup});
  }
}
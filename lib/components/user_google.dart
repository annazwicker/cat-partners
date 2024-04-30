import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/components/login_page.dart';
import 'package:flutter_application_1/components/snapshots.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';


/**
 * UserGoogle userGoogle = UserGoogle();
    //get firebase ID
    String? fireBaseID = userGoogle.auth.currentUser?.uid.toString();
    QuerySnapshot<Map<String, dynamic>> docID = await userGoogle.db.collection('accountLink').where('firebaseUID', isEqualTo: fireBaseID).get();

 * 
 */


class UserGoogle {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  static User? user;

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
          print("1");
          await db.doc(path).update({'firebaseUID': userID});
          print("2");
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
              "rescueGroupAffiliation":'N/A'
              
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

  // meant to retrieve user data from outside this class
  static getUser(){
    if(user != null){
      return user!;
    } else {
      return null;
    }
    
  }

  // allows for signing out
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

  Future<void> reLogin(String newEmail, String? name, String? number, String? affiliation, String? rescueGroup) async{
    // get document of user
    // get firebase ID of new user
    // change firebaseID from accountLink to new user
    var id = auth.currentUser?.uid.toString();
    var docID = await UserGoogle().db.collection('accountLink').where('firebaseUID', isEqualTo:  id).get(); // reference of current user
    var document = docID.docs.first;
    // var catData = await db.collection('entry').where('assignUser', arrayContains: db.doc(reference)).get();
    await signOut(reLogin:true);
    await loginWithGoogle(reLogin:true,path: document.reference.path);
    await db.doc(document.get('userdocID').path).update({'email': auth.currentUser!.email, 'name': name, 'phoneNumber': number, 'affiliation': affiliation, 'rescueGroupAffiliation':rescueGroup});

    
    // var newReference = db.collection('users').doc(auth.currentUser!.uid.toString());
    // for(DocumentSnapshot doc in catData.docs){
    //   await doc.reference.update({'assignedUser': newReference});
    // }
    
    

    // await db.collection('users').doc(auth.currentUser!.uid).update({'affiliation':affiliation, 'name': name, 'phoneNumber':number, 'rescueGroupAffiliation':rescueGroup});
    //await db.collection('users').doc(oldID).delete();
  }


  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc() async{
    String? fireBaseID = auth.currentUser?.uid.toString();

    // Query, gets AccountLink docs with this firebaseUID
    QuerySnapshot<Map<String, dynamic>> docID = await db.collection('accountLink').where('firebaseUID', isEqualTo: fireBaseID).get();
    // Extracts (hopefully singular) result.
    QueryDocumentSnapshot<Map<String, dynamic>> document = docID.docs.first;
    var path = document.get('userdocID').path;
    // return Snapshots.fh.usersRef.doc(document.get('userdocID').id); // rets DocumentReference<UserDoc>
    return db.doc(path).get();
  }
}
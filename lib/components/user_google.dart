import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/components/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class UserGoogle {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  static User? user;

  Future<User?> loginWithGoogle() async{
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

        var data = await db.collection('users').doc(userID).get();
        // if user doesnt exist, make new user doc(docid not based on anything), then create accountLink doc with reference to user doc
        if(!data.exists){
          final userInstance = <String, dynamic>{
            "affiliation":'Friend of Cats',
            "email": userEmail,
            "isAdmin": false,
            "name": userName,
            "phoneNumber": userNumber,
            "rescueGroupAffiliaton":'N/A'
            
          };// add new user

          await db.collection('users').doc(userID).set(userInstance);
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
    var oldID = auth.currentUser!.uid.toString();
    var reference = "users/$oldID"; // reference of current user
    // var catData = await db.collection('entry').where('assignUser', arrayContains: db.doc(reference)).get();
    
    signOut(reLogin:true);
    loginWithGoogle();

    
    // var newReference = db.collection('users').doc(auth.currentUser!.uid.toString());
    // for(DocumentSnapshot doc in catData.docs){
    //   await doc.reference.update({'assignedUser': newReference});
    // }

    await db.collection('users').doc(auth.currentUser!.uid).update({'affiliation':affiliation, 'name': name, 'phoneNumber':number, 'rescueGroupAffiliation':rescueGroup});
    //await db.collection('users').doc(oldID).delete();
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FirebaseHelper {
  const FirebaseHelper._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static final FirebaseFirestore _db = FirebaseFirestore.instance;



  static Future <bool> saveStation({
    // required BuildContext context,
    required int stationID,
    required String name,
    required String description,
    required String photo,
  }) async{
    try{
      //either grab or create a document from a collection

        // Create a new user with a first and last name
        final user = <String, dynamic>{
          "first": "Ada",
          "last": "Lovelace",
          "born": 2009
        };

        // Add a new document with a generated ID
        print(user);
        print(_db);
        _db.collection("users").add(user).then((DocumentReference doc) =>
            print('DocumentSnapshot added with ID: ${doc.id}'));



      var stationRef = _db.collection('station').doc("101");

      //create hard coded json document example
      Map <String, dynamic> hardCodedJson = {
        'name' : 'AMogususs',
        'description' : 'The FitnessGram Pacer Test is a multistage aerobic capacity test that progressively gets more difficult as it continues. The 20 meter pacer test will begin in 30 seconds. Line up at the start. The running speed starts slowly but gets faster each minute after you hear this signal bodeboop. A sing lap should be completed every time you hear this sound. ding Remember to run in a straight line and run as long as possible. The second time you fail to complete a lap before the sound, your test is over. The test will begin on the word start. On your mark. Get ready!… Start. ding﻿',
        'photo' : 'placeholder.img',
      };

      //set document to a specific value
      stationRef.set(hardCodedJson);

      print("set stationRef");


      //retrieve document and create a Station object
      return true;
      
    } catch(e){
      return false;
    }
  }
  

  static Future <bool> saveUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = 
        await _auth.createUserWithEmailAndPassword(
          email: email, 
          password: password
        );

        if(credential.user != null){
          return true;
        }

        return false;
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        )
      );
      return false;
    }
  }

  
}
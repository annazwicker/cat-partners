import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_test_data.dart';

import '../models/cat.dart';
import '../models/entry.dart';
import '../models/station.dart';
import '../models/userdoc.dart';

/// Constants for the names of Firestore's collections.
/// To reduce chance of error.
const String userColRef = 'users';
const String stationColRef = 'station';
const String entryColRef = 'entry';
const String catColRef = 'cat';
const String sightingColRef = 'sighting';

class FirebaseHelper {
  // const FirebaseHelper._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  /// References to collections
  late final CollectionReference<Entry> _entriesRef;
  late final CollectionReference<Station> _stationsRef;
  late final CollectionReference<Cat> _catsRef;
  late final CollectionReference<UserDoc> _usersRef;

  FirebaseHelper(){
    // Mapping used by all reference initializers
    Map<String, Object?> toFirestore(item, _) => item.toJson();
    
    _entriesRef = _db.collection(entryColRef).withConverter<Entry>(
      fromFirestore: (snapshots, _) => Entry.fromJson( snapshots.data()!,), 
      toFirestore: toFirestore
      );
    
    _stationsRef = _db.collection(stationColRef).withConverter<Station>(
      fromFirestore: (snapshots, _) => Station.fromJson( snapshots.data()!,), 
      toFirestore: toFirestore
      );
    
    _catsRef = _db.collection(catColRef).withConverter<Cat>(
      fromFirestore: (snapshots, _) => Cat.fromJson( snapshots.data()!,), 
      toFirestore: toFirestore
      );
      
    _usersRef = _db.collection(userColRef).withConverter<UserDoc>(
      fromFirestore: (snapshots, _) => UserDoc.fromJson( snapshots.data()!,), 
      toFirestore: toFirestore
      );
  }

  Stream<QuerySnapshot> getEntryStream() {
    //TEST

    // DocumentReference<Station> stationDocRef = _stationsRef.doc('2');
    // Timestamp date = Timestamp.fromDate(DateTime(2024, DateTime.april, 7)); 

    // DateTime now = DateTime.now();
    // DateTime nowNoSeconds = DateTime(now.year, now.month, now.day);
    // final threeWeeksFromNow = nowNoSeconds.add(const Duration(days: -5));


    // print(nowNoSeconds);
    // print(threeWeeksFromNow);

    // return _entriesRef.where("date", isEqualTo: date).snapshots();
    return _entriesRef.snapshots();
  }

  Stream<QuerySnapshot> getStationStream() {
    return _stationsRef.snapshots();
  }

  Stream<QuerySnapshot> getCatStream() {
    return _catsRef.snapshots();
  }

  Stream<QuerySnapshot> getUserStream() {
    return _usersRef.snapshots();
  }



  //home_page methods
    Stream<QuerySnapshot> getUrgentEntries() {


    // DocumentReference<Station> stationDocRef = _stationsRef.doc('2');
    // Timestamp date = Timestamp.fromDate(DateTime(2024, DateTime.april, 7)); 

    DateTime now = DateTime.now();
    DateTime nowNoSeconds = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = nowNoSeconds.add(const Duration(days: 1));

    return _entriesRef.where("date", isGreaterThanOrEqualTo: nowNoSeconds).where("date", isLessThanOrEqualTo: tomorrow).snapshots();
    
  }

  /// Getters
  CollectionReference<Entry> get entriesRef { return _entriesRef; }
  CollectionReference<Station> get stationsRef { return _stationsRef; }
  CollectionReference<Cat> get catsRef { return _catsRef; }
  CollectionReference<UserDoc> get usersRef { return _usersRef; }

  void addEntry(Entry entry) async {
    _entriesRef.add(entry);
  }

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
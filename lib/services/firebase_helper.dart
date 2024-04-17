import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  void testing() {
    Query<Entry> emptyNoteQuery = _entriesRef.where('note', isEqualTo: '');
    // emptyNoteQuery.
    // Future<QuerySnapshot<Entry>> fut = emptyNoteQuery.get();
    emptyNoteQuery.get().then(
      (querySnapshot) {
        print("Successfully completed");
        List<QueryDocumentSnapshot<Entry>> queryResults = querySnapshot.docs;
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  /// Getters
  CollectionReference<Entry> get entriesRef { return _entriesRef; }
  CollectionReference<Station> get stationsRef { return _stationsRef; }
  CollectionReference<Cat> get catsRef { return _catsRef; }
  CollectionReference<UserDoc> get usersRef { return _usersRef; }
  FirebaseFirestore get db { return _db; }

  /// Let 'colRef' be a CollectionReference
  /// Let 'someDocId' be a doc id
  /// colRef.doc(someDocId) 
  ///   | Returns DocumentReference to doc with id 'someDocId'
  /// colRef.doc() 
  ///   | Returns DocumentReference to newly-created doc with auto-id.
  /// colRef.doc(someDocId).set(Map<String, dynamic> data) 
  ///   | Sets/creates document with ID 'someDocId' with data 'data'
  /// colRef.add(someClassData)
  ///   | Creates a document with auto-ID and data 'data'

  void addEntry(Entry entry) async {
    _entriesRef.add(entry);
  }
  
  /// Ensures that entries exist for [date] by adding them if they don't exist.
  void ensureEntries(DateTime date) async {
    // Remove milliseconds
    date = DateTime(date.year, date.month, date.day);
    Timestamp stamp = Timestamp.fromDate(date);
    _db.runTransaction(
      (transaction) async {
        // Get all stations
        bool isError = false;
        List<QueryDocumentSnapshot<Station>> stations = [];
        _stationsRef.get().then(
          (querySnapshot) {
            stations = querySnapshot.docs;
          },
          onError: (e){ 
            print(e);
            isError = true; },
        );

        // Get entries with given date 
        List<QueryDocumentSnapshot<Entry>> entries = [];
        DateTime nextDate = date.add(const Duration(days: 1));
        Timestamp nextStamp = Timestamp.fromDate(nextDate);
        _entriesRef.where('date', isGreaterThanOrEqualTo: stamp, isLessThan: nextStamp).get().then(
          (querySnapshot) { entries = querySnapshot.docs; },
          onError: (e) { 
            print(e); 
            isError = true;},
        );

        // Check if there isn't an error
        if(!isError) {
          for (QueryDocumentSnapshot<Station> station in stations){
            // Query returns entry with station and date
            List<QueryDocumentSnapshot<Entry>> statEntry = entries.where((element) => element.data().stationID.id == station.id).toList();
            // Add entry if it doesn't exist
            if(statEntry.isEmpty){
              Entry newEntry = 
                Entry(
                  assignedUser: null, 
                  date: stamp, 
                  note: '', 
                  stationID: station.reference,
                  );
              DocumentReference<Entry> newDocRef = _entriesRef.doc();
              transaction.set(newDocRef, newEntry);
            }
          }
        }
    });
    // TODO adds entries for the given date, if they don't exist.
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
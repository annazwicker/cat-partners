import 'dart:js_interop_unsafe';

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

  // TODO get current user ID
  final bool isUserLoggedIn = true;
  final String? currentUserIDTest = 'bGb48S0N1TXE7bzF52yc';

  FirebaseHelper() {
    // Mapping used by all reference initializers
    Map<String, Object?> toFirestore(item, _) => item.toJson();

    _entriesRef = _db.collection(entryColRef).withConverter<Entry>(
        fromFirestore: (snapshots, _) => Entry.fromJson(
              snapshots.data()!,
            ),
        toFirestore: toFirestore);

    _stationsRef = _db.collection(stationColRef).withConverter<Station>(
        fromFirestore: (snapshots, _) => Station.fromJson(
              snapshots.data()!,
            ),
        toFirestore: toFirestore);

    _catsRef = _db.collection(catColRef).withConverter<Cat>(
        fromFirestore: (snapshots, _) => Cat.fromJson(
              snapshots.data()!,
            ),
        toFirestore: toFirestore);

    _usersRef = _db.collection(userColRef).withConverter<UserDoc>(
        fromFirestore: (snapshots, _) => UserDoc.fromJson(
              snapshots.data()!,
            ),
        toFirestore: toFirestore);
  }

  Stream<QuerySnapshot<Entry>> getEntryStream() {
    return _entriesRef.snapshots();
  }

  Stream<QuerySnapshot<Station>> getStationStream() {
    return _stationsRef.snapshots();
  }

  Stream<QuerySnapshot<Cat>> getCatStream() {
    return _catsRef.snapshots();
  }

  Stream<QuerySnapshot<UserDoc>> getUserStream() {
    return _usersRef.snapshots();
  }

  void sortStationList(List stationList) {
    stationList.sort((a, b) {
      String aE = a.data().name;
      String bE = b.data().name;
      int comp = aE.compareTo(bE);
      return comp;
    });
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

  //get user's name given documentReference
  Future getUserName(DocumentReference<Object?>? docRef) async {
    DocumentSnapshot assignedUserSnapshot = await docRef!.get();
    Map<String, dynamic> userData =
        assignedUserSnapshot.data() as Map<String, dynamic>;

    String assignedUserName = userData['name'];
    return assignedUserName;
  }

  //home_page methods

  /**
   * queries all today and tomorrow entries that don't have people assigned to them yet
   */
  Stream<QuerySnapshot> getUrgentEntries() {
    // DocumentReference<Station> stationDocRef = _stationsRef.doc('2');
    // Timestamp date = Timestamp.fromDate(DateTime(2024, DateTime.april, 7));
    DateTime now = DateTime.now();
    DateTime nowNoSeconds = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = nowNoSeconds.add(const Duration(days: 1));

    return _entriesRef
        .where("date", isGreaterThanOrEqualTo: nowNoSeconds)
        .where("date", isLessThanOrEqualTo: tomorrow)
        .where("assignedUser", isNull: true)
        .snapshots();
  }

/**
 * queries all of a given user's upcoming entries
 */
  Stream<QuerySnapshot> getUpcomingUserEntries(DocumentReference userRef) {
    print(userRef);

    // DateTime now = DateTime.now();
    // DateTime now = DateTime.now().add(const Duration(days: -30));
    DateTime now = DateTime.now();
    DateTime nowNoSeconds = DateTime(now.year, now.month, now.day);
    print(nowNoSeconds);
    Timestamp time = Timestamp.fromDate(nowNoSeconds);
    print(time);

    DocumentReference<Station> station = _stationsRef.doc('1');

    return _entriesRef
        .where("date", isGreaterThanOrEqualTo: nowNoSeconds)
        .where("assignedUser", isEqualTo: userRef)

        // .where("stationID", isEqualTo: station)
        .snapshots();
  }
  Stream<QuerySnapshot> getAllUserEntries(DocumentReference userRef) {
    print(userRef);

    // DateTime now = DateTime.now();
    // DateTime now = DateTime.now().add(const Duration(days: -30));
    DateTime now = DateTime.now();
    DateTime nowNoSeconds = DateTime(now.year, now.month, now.day);
    print(nowNoSeconds);
    Timestamp time = Timestamp.fromDate(nowNoSeconds);
    print(time);

    DocumentReference<Station> station = _stationsRef.doc('1');

    return _entriesRef
        .where("assignedUser", isEqualTo: userRef)

        // .where("stationID", isEqualTo: station)
        .snapshots();
  }

  DocumentReference getCurrentUser() {
    return _usersRef.doc('nay@southwestern.edu');
    //  return _usersRef.doc('5SLi4nS54TigU4XtHzAp');
  }


    Stream<QuerySnapshot>  getThisUser(email) {

    return _usersRef.where('email', isEqualTo: email).snapshots();
    //  return _usersRef.doc('5SLi4nS54TigU4XtHzAp');
  }

  //Account Page Methods

  //add security that ensures phone number is valid
  Future changeProfileFields(
      String userID, Map<String, dynamic> accountForm) async {
    Map<String, dynamic> updateForm = {};
    //change name

    if (accountForm['name'] != null) {
      updateForm['name'] = accountForm['name'];
    }
    //change phone number
    if (accountForm['phone'] != null) {
      updateForm['phoneNumber'] = accountForm['phone'];
    }
    //change affiliation
    if (accountForm['affiliation'] != null) {
      updateForm['affiliation'] = accountForm['affiliation'];
    }
    //change rescue group
    if (accountForm['rescueGroup'] != null) {
      updateForm['rescueGroupAffiliaton'] = accountForm['rescueGroup'];
    }

    //perform update
    return _usersRef.doc(userID).update(updateForm);
  }

//Admin_Page Methods

  //delete account
  //get string. delete email

  /**
   * deletes user account given the email address string (currently assuming that email is the doc ID)
   */
  Future deleteAccount(String userEmail) async {
    DocumentReference documentReference = _usersRef.doc(userEmail);

    return documentReference.delete();
  }

  /**
   * changes user account's affiliation
   */
  Future changeUserAffiliation(
      String userEmail, String selectedAffiliation) async {
    DocumentReference documentReference = _usersRef.doc(userEmail);
    return documentReference.update({'affiliation': selectedAffiliation});
  }

  /**
   * returns snapshots of all users with admin permission
   */
  Stream<QuerySnapshot<UserDoc>> getAdminUsers() {
    return _usersRef.where('isAdmin', isEqualTo: true).snapshots();
    // return _usersRef.snapshots();
  }

  /**
   * gives admin status to user account given the email address string 
   * (assuming email is the doc ID)
   */
  Future addAdmin(String userEmail) async {
    DocumentReference documentReference = _usersRef.doc(userEmail);

    return documentReference.update({'isAdmin': true});
  }

  /**
   * removes admin status to user account given the email address string 
   * (assuming email is the doc ID)
   */
  Future removeAdmin(String userEmail) async {
    DocumentReference documentReference = _usersRef.doc(userEmail);

    return documentReference.update({'isAdmin': false});
  }

  /**
   * adds cat to Cat collection given a map of the cat's characteristics
   */
  Future addCat(Map<String, dynamic> catMap) async {
    Cat cat = Cat(
      description: catMap['description'],
      name: catMap['name'],
      photo: catMap['photo'],
      stationID: _stationsRef.doc(catMap['stationID']),
    );

    return _catsRef.add(cat);
  }

  /**
   * deletes cat from Cat collection given a doc reference to that cat
   */
  Future deleteCat(String catToDelete) async {
    DocumentReference cat = _catsRef.doc(catToDelete);
    return cat.delete();
  }

  /**
   * adds station to Station collection given a map of the station's characteristics
   */
  Future addStation(Map<String, dynamic> stationMap) async {
    Station station = Station(
      description: stationMap['description'],
      fullName: stationMap['fullName'],
      name: stationMap['name'],
      photo: stationMap['photo'],
    );

    return _stationsRef.add(station);
  }

  /**
   * deletes station from Station collection given a doc reference to that station
   */
  Future deleteStation(String stationToDelete) async {
    DocumentReference station = _stationsRef.doc(stationToDelete);
    return station.delete();
  }

/**
 * given a search string, returns search results for all user's names and emails for a match
 */
  // Future searchUsers(String searchTerm) async {
  //   //loop through all users to run string.contains method on them
  //   //convert to workable snapshots
  //   //loop through entire collection
  //   //return list
  //   List users = [];
  //   //get collection
  //   _usersRef.get().then(
  //     (querySnapshot) {
  //       print("Successfully completed");
  //       users = querySnapshot.docs;
  //       for (var docSnapshot in querySnapshot.docs) {
  //         print('${docSnapshot.id} => ${docSnapshot.data()}');
  //       }

  //       List<DocumentSnapshot<Map<String, dynamic>>> searchResult = [];

  //       for (final user in users) {
  //         UserDoc userData = user.data();
  //         searchResult.add(userData);
  //         // if ((userData.firstNameString.contains(searchTerm)) ||
  //         //     (userData.email.contains(searchTerm))) {
  //         //   searchResult.add(user);
  //         // }
  //       }
  //       print("users: ");
  //       print(users);
  //       print("searchResult: ");
  //       print(searchResult);

  //       return searchResult;
  //     },
  //     onError: (e) => print("Error completing: $e"),
  //   );

  //   //end get collection

  // }

  /// Getters
  CollectionReference<Entry> get entriesRef {
    return _entriesRef;
  }

  CollectionReference<Station> get stationsRef {
    return _stationsRef;
  }

  CollectionReference<Cat> get catsRef {
    return _catsRef;
  }

  CollectionReference<UserDoc> get usersRef {
    return _usersRef;
  }

  FirebaseFirestore get db {
    return _db;
  }

  /// Returns document ID of current user, as string
  String? getUserIDTest() {
    return currentUserIDTest;
  }

  void addEntry(Entry entry) async {
    _entriesRef.add(entry);
  }

  /// Ensures that entries exist for [date] by adding them if they don't exist.
  void ensureEntries(DateTime date) async {
    // Remove milliseconds
    date = DateTime(date.year, date.month, date.day);
    Timestamp stamp = Timestamp.fromDate(date);
    _db.runTransaction((transaction) async {
      // Get all stations
      bool isError = false;
      List<QueryDocumentSnapshot<Station>> stations = [];
      _stationsRef.get().then(
        (querySnapshot) {
          stations = querySnapshot.docs;
        },
        onError: (e) {
          print(e);
          isError = true;
        },
      );

      // Get entries with given date
      List<QueryDocumentSnapshot<Entry>> entries = [];
      entriesOnDateQuery(date).get().then(
        (querySnapshot) {
          entries = querySnapshot.docs;
        },
        onError: (e) {
          print(e);
          isError = true;
        },
      );

      // Check if there isn't an error
      if (!isError) {
        for (QueryDocumentSnapshot<Station> station in stations) {
          // Query returns entry with station and date
          List<QueryDocumentSnapshot<Entry>> statEntry = entries
              .where((element) => element.data().stationID.id == station.id)
              .toList();
          // Add entry if it doesn't exist
          if (statEntry.isEmpty) {
            Entry newEntry = Entry(
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

  /// Returns a timestamp with the same date as [stamp], with hours, minutes, seconds and
  /// milliseconds set to 0.
  Timestamp equalizeTime(Timestamp stamp) {
    DateTime date = stamp.toDate();
    date = DateTime(date.year, date.month, date.day);
    return Timestamp.fromDate(date);
  }

  List<QueryDocumentSnapshot<Entry>> getEntries(DateTime date) {
    ensureEntries(date);
    List<QueryDocumentSnapshot<Entry>> entries = [];
    entriesOnDateQuery(date).get().then((querySnapshot) {
      entries = querySnapshot.docs.toList();
    });
    return entries;
  }

  /// Returns a query that queries the database for all entries on the given [date].
  Query<Entry> entriesOnDateQuery(DateTime date) {
    DateTime nextDate = date.add(const Duration(days: 1));

    Timestamp stamp = Timestamp.fromDate(date);
    Timestamp nextStamp = Timestamp.fromDate(nextDate);
    return _entriesRef.where('date',
        isGreaterThanOrEqualTo: stamp, isLessThan: nextStamp);
  }

  static Future<bool> saveStation({
    // required BuildContext context,
    required int stationID,
    required String name,
    required String description,
    required String photo,
  }) async {
    try {
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
      Map<String, dynamic> hardCodedJson = {
        'name': 'AMogususs',
        'description':
            'The FitnessGram Pacer Test is a multistage aerobic capacity test that progressively gets more difficult as it continues. The 20 meter pacer test will begin in 30 seconds. Line up at the start. The running speed starts slowly but gets faster each minute after you hear this signal bodeboop. A sing lap should be completed every time you hear this sound. ding Remember to run in a straight line and run as long as possible. The second time you fail to complete a lap before the sound, your test is over. The test will begin on the word start. On your mark. Get ready!… Start. ding﻿',
        'photo': 'placeholder.img',
      };

      //set document to a specific value
      stationRef.set(hardCodedJson);

      print("set stationRef");

      //retrieve document and create a Station object
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        return true;
      }

      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return false;
    }
  }

//name getters

  Future getStationName(String stationID) async {
    // Fetch the document referenced by stationID
    _stationsRef.doc(stationID).get().then((stationSnapshot) {
      final data = stationSnapshot.data() as Map<String, dynamic>;
      return data['name'];
    });
  }
}

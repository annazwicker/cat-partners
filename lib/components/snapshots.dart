import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/services/firebase_helper.dart';

import '../models/entry.dart';
import '../models/cat.dart';
import '../models/userdoc.dart';
import '../models/station.dart';

/// Contains common data used by various pages of the database.
/// Facilitates access to such data.
class Snapshots {
  FirebaseHelper fh = FirebaseHelper();


  // Late instance variables 
  
  late final Stream<QuerySnapshot<Entry>> _entryStream = fh.getEntryStream();
  late final Stream<QuerySnapshot<Cat>> _catStream = fh.getCatStream();
  late final Stream<QuerySnapshot<Station>> _stationStream = fh.getStationStream();
  late final Stream<QuerySnapshot<UserDoc>> _userStream = fh.getUserStream();

  
  late Future<List<QueryDocumentSnapshot<Station>>> _stationQuery;
  late Future<List<QueryDocumentSnapshot<Entry>>> _entryQuery;
  late Future<List<QueryDocumentSnapshot<Cat>>> _catQuery;
  late Future<List<QueryDocumentSnapshot<UserDoc>>> _userQuery;

  /// A Stream returning all entries. Dynamically updates.
  Stream<QuerySnapshot<Entry>> get entryStream => _entryStream;
  /// A Stream returning all cats. Dynamically updates.
  Stream<QuerySnapshot<Cat>> get catStream => _catStream;
  /// A Stream returning all stations. Dynamically updates.
  Stream<QuerySnapshot<Station>> get stationStream => _stationStream;
  /// A Stream returning all users. Dynamically updates.
  Stream<QuerySnapshot<UserDoc>> get userStream => _userStream;


  /// Returns a list of stations. Does not dynamically update.
  Future<List<QueryDocumentSnapshot<Station>>>  get stationQuery => _stationQuery;
  /// Returns a list of entries. Does not dynamically update.
  Future<List<QueryDocumentSnapshot<Entry>>>    get entryQuery => _entryQuery;
  /// Returns a list of cats. Does not dynamically update.
  Future<List<QueryDocumentSnapshot<Cat>>>      get catQuery => _catQuery;
  /// Returns a list of users. Does not dynamically update.
  Future<List<QueryDocumentSnapshot<UserDoc>>>  get userQuery => _userQuery;

  /// Returns all documents in the collection referenced by [ref].
  Future<List<QueryDocumentSnapshot<T>>> _initQuery<T>(CollectionReference<T> ref) async {
    // bool isError = false;
    List<QueryDocumentSnapshot<T>> results = [];
    await ref.get().then(
      (snapshot) {
        results = snapshot.docs;
      },
      onError: (e) {
        print(e);
        // isError = true;
      }
    );
    return results;
  }
  
  /// Returns DocumentSnapshots for all Stations in the collection.
  Future<List<QueryDocumentSnapshot<Station>>> _initStations() async {
    List<QueryDocumentSnapshot<Station>> listStations = [];
    await _initQuery(fh.stationsRef).then((value) => listStations = value);
    listStations.sort((a, b) {
      return a.id.compareTo(b.id);
    });
    return listStations;
  }

  /// Returns DocumentSnapshots for all Users in the collection.
  Future<List<QueryDocumentSnapshot<UserDoc>>> _initUsers() async {
    List<QueryDocumentSnapshot<UserDoc>> listUsers = [];
    await _initQuery(fh.usersRef).then((value) => listUsers = value);
    return listUsers;
  }

  /// Returns DocumentSnapshots for all Cats in the collection.
  Future<List<QueryDocumentSnapshot<Cat>>> _initCats() async {
    List<QueryDocumentSnapshot<Cat>> listUsers = [];
    await _initQuery(fh.catsRef).then((value) => listUsers = value);
    return listUsers;
  }

  /// Returns DocumentSnapshots for all Entries in the collection.
  Future<List<QueryDocumentSnapshot<Entry>>> _initEntries() async {
    List<QueryDocumentSnapshot<Entry>> listUsers = [];
    await _initQuery(fh.entriesRef).then((value) => listUsers = value);
    return listUsers;
  }
  
  Snapshots(){
    _stationQuery = _initStations();
    _catQuery = _initCats();
    _entryQuery = _initEntries();
    _userQuery = _initUsers();
  }

  // Methods

  Future<Station> getStation(DocumentReference stationRef) async {
    List<QueryDocumentSnapshot<Station>> stationsList = await _stationQuery;
    var desired = stationsList.where((element) => element.reference.id == stationRef.id).toList();
    assert (desired.length == 1);
    return desired[0].data();
  }

}
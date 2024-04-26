import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/services/firebase_helper.dart';

import '../models/entry.dart';
import '../models/cat.dart';
import '../models/model.dart';
import '../models/userdoc.dart';
import '../models/station.dart';

/// Contains common data used by various pages of the database.
/// Facilitates access to such data.
class Snapshots {
  static FirebaseHelper fh = FirebaseHelper();


  // Late instance variables 
  
  static final Stream<QuerySnapshot<Entry>> _entryStream = fh.getEntryStream();
  static final Stream<QuerySnapshot<Cat>> _catStream = fh.getCatStream();
  static final Stream<QuerySnapshot<Station>> _stationStream = fh.getStationStream();
  static final Stream<QuerySnapshot<UserDoc>> _userStream = fh.getUserStream();

  
  static Future<List<QueryDocumentSnapshot<Station>>> _stationQuery = _initStations();
  static Future<List<QueryDocumentSnapshot<Entry>>> _entryQuery = _initEntries();
  static Future<List<QueryDocumentSnapshot<Cat>>> _catQuery = _initCats();
  static Future<List<QueryDocumentSnapshot<UserDoc>>> _userQuery = _initUsers();

  /// A Stream returning all entries. Dynamically updates.
  static Stream<QuerySnapshot<Entry>> get entryStream => _entryStream;
  /// A Stream returning all cats. Dynamically updates.
  static Stream<QuerySnapshot<Cat>> get catStream => _catStream;
  /// A Stream returning all stations. Dynamically updates.
  static Stream<QuerySnapshot<Station>> get stationStream => _stationStream;
  /// A Stream returning all users. Dynamically updates.
  static Stream<QuerySnapshot<UserDoc>> get userStream => _userStream;


  /// Returns a list of stations. Does not dynamically update.
  static Future<List<QueryDocumentSnapshot<Station>>>  get stationQuery => _stationQuery;
  /// Returns a list of entries. Does not dynamically update.
  static Future<List<QueryDocumentSnapshot<Entry>>>    get entryQuery => _entryQuery;
  /// Returns a list of cats. Does not dynamically update.
  static Future<List<QueryDocumentSnapshot<Cat>>>      get catQuery => _catQuery;
  /// Returns a list of users. Does not dynamically update.
  static Future<List<QueryDocumentSnapshot<UserDoc>>>  get userQuery => _userQuery;

  /// Returns all documents in the collection referenced by [ref].
  static Future<List<QueryDocumentSnapshot<T>>> _initQuery<T>(CollectionReference<T> ref) async {
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
  static Future<List<QueryDocumentSnapshot<Station>>> _initStations() async {
    List<QueryDocumentSnapshot<Station>> listStations = [];
    await _initQuery(fh.stationsRef).then((value) => listStations = value);
    listStations.sort((a, b) {
      return a.id.compareTo(b.id);
    });
    return listStations;
  }

  /// Returns DocumentSnapshots for all Users in the collection.
  static Future<List<QueryDocumentSnapshot<UserDoc>>> _initUsers() async {
    List<QueryDocumentSnapshot<UserDoc>> listUsers = [];
    await _initQuery(fh.usersRef).then((value) => listUsers = value);
    return listUsers;
  }

  /// Returns DocumentSnapshots for all Cats in the collection.
  static Future<List<QueryDocumentSnapshot<Cat>>> _initCats() async {
    List<QueryDocumentSnapshot<Cat>> listUsers = [];
    await _initQuery(fh.catsRef).then((value) => listUsers = value);
    return listUsers;
  }

  /// Returns DocumentSnapshots for all Entries in the collection.
  static Future<List<QueryDocumentSnapshot<Entry>>> _initEntries() async {
    List<QueryDocumentSnapshot<Entry>> listUsers = [];
    await _initQuery(fh.entriesRef).then((value) => listUsers = value);
    return listUsers;
  }

  // Methods

  /// Returns a QueryDocumentSnapshot with type [T], given a DocumentReference referring
  /// to a document in the collection modelled by [T]. Throws an exception if T is not
  /// Station, UserDoc, Entry or Cat.
  static Future<QueryDocumentSnapshot<T>> getDocument<T extends Model>(DocumentReference docRef) async {
    Future<List<QueryDocumentSnapshot<T>>> query;
    switch(T){
      case Station:
        query = _stationQuery as Future<List<QueryDocumentSnapshot<T>>>;
      case Cat:
        query = _catQuery as Future<List<QueryDocumentSnapshot<T>>>;
      case Entry:
        query = _entryQuery as Future<List<QueryDocumentSnapshot<T>>>;
      case UserDoc:
        query = _userQuery as Future<List<QueryDocumentSnapshot<T>>>;
      default:
        throw FormatException('DocumentReference is not in the right collection: ${docRef.parent.runtimeType}.'
        ' Please provide a DocumentReference in the Station, Cat, Users or Entry collections.');
    }
    List<QueryDocumentSnapshot<T>> docsList = await query;

    // TODO add checks for when docRef's document doesn't exist
    var desired = docsList.where((element) => element.reference.id == docRef.id).toList();
    assert (desired.length == 1);
    return desired[0];
  }

  /// Returns the DocumentSnapshot<UserDoc> of the user document referenced by the
  /// entry in [entrySnapshot]. The bool in the first part of the tuple
  /// is true if and only if such a user exists; i.e., if [entrySnapshot] both has
  /// a non-null assignedUser field and that user exists in the database.
  static Future<(bool, DocumentSnapshot<UserDoc>?)> getAssignedUser(QueryDocumentSnapshot<Entry> entrySnapshot) async {
    /// A tuple with a bool is used to allow this Future to return a non-null value
    /// even when the given Entry has no assignedUser. Otherwise, FutureBuilders using
    /// this function won't be able to differentiate waiting on this function from the
    /// function returning a null value.
    DocumentReference? userID = entrySnapshot.data().assignedUser;
    DocumentSnapshot<UserDoc>? toReturn;
    bool userExists = false;
    if(userID != null){
      var snap = await fh.usersRef.doc(userID.id).get();
      toReturn = snap;
      userExists = true;
    }
    assert (userExists == (toReturn != null));
    return (userExists, toReturn);
  }

  /// TEMPORARY FUNCTION.
  /// Returns whether there is a user logged in.
  static bool isUserLoggedIn() { return fh.isUserLoggedIn; }

  /// TEMPORARY FUNCTION.
  /// Returns the DocumentReference of the current HARD-CODED user.
  static Future<DocumentReference> getCurrentUserTEST() async {
    assert (isUserLoggedIn());
    String currentUserID = fh.currentUserIDTest!;
    return await fh.usersRef.doc(currentUserID);
  }

}
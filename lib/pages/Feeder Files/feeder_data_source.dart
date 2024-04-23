import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/entry.dart';
import '../../models/station.dart';
import '../../models/userdoc.dart';
import '../../services/firebase_helper.dart';


var formatDashes = DateFormat('yyyy-MM-dd');
var formatAbbr = DateFormat('yMMMd');

class FeederDataSource extends ChangeNotifier {

  FirebaseHelper fh;
  late Stream<QuerySnapshot<Entry>> tableStream;
  late Future<List<QueryDocumentSnapshot<Station>>> stations;
  

  FeederDataSource({
    required this.fh,
  }){
    stations = _initStations();
    tableStream = fh.getEntryStream();
  }

  Future<List<QueryDocumentSnapshot<Station>>> _initStations() async {
    // bool isError = false;
    List<QueryDocumentSnapshot<Station>> listStations = [];
    await fh.stationsRef.get().then(
      (stationSnapshot) {
        listStations = stationSnapshot.docs;
      },
      onError: (e) {
        print(e);
        // isError = true;
      }
    );
    listStations.sort((a, b) {
      return a.id.compareTo(b.id);
    });
    return listStations;
  }

  /// Returns the DocumentSnapshot<UserDoc> of the user document referenced by the
  /// entry in the given QueryDocumentSnapshot. The bool in the first part of the tuple
  /// is true if and only if such a user exists; i.e., if [entrySnapshot] both has
  /// a non-null assignedUser field and that user exists in the database.
  Future<(bool, DocumentSnapshot<UserDoc>?)> getAssignedUser(QueryDocumentSnapshot<Entry> entrySnapshot) async {
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
  
  /// Returns the station referenced by [stationRef].
  /// Said station must be in the list of stations in this FeederDataSource.
  Future<Station> getStation(DocumentReference stationRef) async {
    List<QueryDocumentSnapshot<Station>> stationsList = await stations;
    var desired = stationsList.where((element) => element.reference.id == stationRef.id).toList();
    assert (desired.length == 1);
    return desired[0].data();
  }

  bool isUserLoggedIn() { return fh.isUserLoggedIn; }

  Future<DocumentReference> getCurrentUserTEST() async{
    assert (isUserLoggedIn());
    String currentUserID = fh.currentUserIDTest!;
    return await fh.usersRef.doc(currentUserID);
  }

  // Future<DocumentReference> getUserWithRef(String path) {
  //   fh.usersRef.doc(path);
  // }


}

class EntryWrapper {
  late QueryDocumentSnapshot<Entry> entrySnapshot;
  late DocumentSnapshot<UserDoc>? entryUser;
  late bool hasUser;
  late DocumentSnapshot<Station> entryStation;
}
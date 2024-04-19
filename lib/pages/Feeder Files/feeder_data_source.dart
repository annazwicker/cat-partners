import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/entry.dart';
import '../../models/userdoc.dart';
import '../../services/firebase_helper.dart';

class FeederDataSource extends ChangeNotifier {

  FirebaseHelper fh;
  late Stream<QuerySnapshot<Entry>> tableStream;

  FeederDataSource({
    required this.fh,
  }){
    tableStream = fh.getEntryStream();
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
  
}
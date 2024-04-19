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

  // Future<DocumentSnapshot<UserDoc>> getAssignedUser(QueryDocumentSnapshot<Entry> entrySnapshot) async {
  //   DocumentReference? userID = entrySnapshot.data().assignedUser;
  //   String futureCellText = '';
  //   DocumentSnapshot<UserDoc> toReturn;
  //   if(userID != null){
  //     await fh.usersRef.doc(userID.id).get().then((value) {
  //       toReturn = value;
  //     },
  //     onError: (e) => print(e));
  //   }
  //   return toReturn;
  // }
  
}
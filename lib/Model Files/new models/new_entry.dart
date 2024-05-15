import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Model%20Files/doc_model.dart';

import '../../components/types_and_funcs.dart';
import '../doc_checker.dart';
import '../new_models_import.dart';

abstract class EntryInterface {
  
  // Getters
  /// This entry's assigned user, if one exists.
  UserInterface? get user;
  /// Sets this entry's assigned user.
  set user(UserInterface? user); 

  /// The date of this entry.
  DateTime get date;

  /// This entry's station. 
  StationInterface get station;

  /// This entry's note.
  String get note;
  /// Sets this entry's note.
  set note(String note);

}

class NewEntryModel implements EntryInterface {

  DocModel doc;

  NewEntryModel._(this.doc);

  factory NewEntryModel.fromSnapshot(DocumentSnapshot<Json> snapshot){
    return NewEntryModel._(DocModel(snapshot, _getChecker()));
  }

  static const ({
    String note, 
    String user, 
    String date, 
    String station}
  ) _fieldRecord = (
    note: 'note',
    user: 'assignedUser',
    date: 'date',
    station: 'stationID',
  );

  /// Returns a DocChecker which should be run on all instantiated Entries.
  static DocChecker _getChecker () {
    Map<String, FieldChecker> fieldCheckers = {
      _fieldRecord.note: FieldChecker.typeChecker<String>(),
      // TODO should be User?
      _fieldRecord.user: FieldChecker.typeChecker<SiteUser>(),
      _fieldRecord.date: FieldChecker.typeChecker<DateTime>(),
      // TODO should be Station
      _fieldRecord.station: FieldChecker.typeChecker<NewStation>(),
    };

    // No verifier for whole document
    return DocChecker(fieldCheckers, (json) => [] );
  }

  // Overridden members
  @override
  String get note => doc.document[_fieldRecord.note];
  @override
  // TODO implement
  set note (String note) {
    throw UnimplementedError();
  }
  
  @override
  // TODO implement
  UserInterface? get user {
    throw UnimplementedError();
  }
  @override
  // TODO implement
  set user (UserInterface? newUser) {
    doc.document[_fieldRecord.user];
    throw UnimplementedError();
  }
  
  @override
  DateTime get date => doc.document[_fieldRecord.date];
  
  @override
  // TODO: implement
  StationInterface get station {
    throw UnimplementedError();
  }

}
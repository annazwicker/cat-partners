import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Model%20Files/doc_checker.dart';
import 'package:flutter_application_1/Model%20Files/doc_model.dart';
import 'package:flutter_application_1/components/types_and_funcs.dart';

abstract class StationInterface {

  // Getters

  /// The name of this Station.
  String get name;

  /// The date this Station was created.
  Timestamp get dateCreated;

  /// The date this Station was deleted, if it has ever been deleted. Null 
  /// otherwise.
  Timestamp? get dateDeleted;

  /// Whether this Station has ever been deleted.
  bool get isDeleted;


  // Modifiers

  /// Sets the name of this station.
  set name(String name);

  /// Deletes this station. This will delete all of this station's entries
  /// for future dates past the present date. 
  void delete();


}

class NewStation implements StationInterface{
  DocModel doc;

  NewStation._(this.doc);

  static const String collectionId = 'station';

  static const ({
    String dateCreated, 
    String dateDeleted, 
    String description, 
    String name}
  ) _fieldRecord = (
    name: 'name',
    dateCreated: 'dateCreated',
    dateDeleted: 'dateDeleted',
    description: 'description'
  );

  factory NewStation.fromSnapshot(DocumentSnapshot<Json> snapshot){
    return NewStation._(DocModel(snapshot, _getChecker()));
  }

  static DocChecker _getChecker() { 
    Map<String, FieldChecker> fieldCheckers = {
      _fieldRecord.name: FieldChecker.typeChecker<String>(),
      _fieldRecord.dateCreated: FieldChecker.typeChecker<Timestamp>(),
      _fieldRecord.dateDeleted: FieldChecker.typeChecker<Timestamp>(),
      _fieldRecord.description: FieldChecker.typeChecker<String>(),
    };

    List<String> finalVerifier(Json json) {
      List<String> list  = [];
      if(json.containsKey(_fieldRecord.dateDeleted)){
        Timestamp startDate = json[_fieldRecord.dateCreated];
        Timestamp endDate = json[_fieldRecord.dateDeleted];
        if(startDate.toDate().isAfter(endDate.toDate())){
          list.add('Deletion date must come after creation date.'
            ' Creation: $startDate. Deletion: $endDate');
        }
      }
      return list;
    }
    return DocChecker(fieldCheckers, finalVerifier);

  }

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  // TODO: implement dateCreated
  Timestamp get dateCreated => throw UnimplementedError();

  @override
  // TODO: implement dateDeleted
  Timestamp? get dateDeleted => throw UnimplementedError();


  @override
  // TODO: implement
  set name(String newName) => throw UnimplementedError();

  @override
  void delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  // TODO: implement isDeleted
  bool get isDeleted => throw UnimplementedError();


}
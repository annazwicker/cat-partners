import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Model%20Files/doc_checker.dart';
import 'package:flutter_application_1/Model%20Files/new%20models/new_station.dart';

import '../../components/types_and_funcs.dart';
import '../doc_model.dart';

abstract class CatInterface {
  /// This cat's name.
  String get name;
  /// Sets this cat's name.
  set name(String newName);

  /// The station this cat is assigned to.
  StationInterface get station;
  /// Sets this cat's station.
  set station(StationInterface newStation);

}

class NewCat implements CatInterface {

  // ---- Housekeeping ---- //

  DocModel doc;
  
  NewCat._(this.doc);

  static String collectionId = 'cat';
  
  factory NewCat.fromSnapshot(DocumentSnapshot<Json> snapshot){
    return NewCat._(DocModel(snapshot, _getChecker()));
  }

  static const ({
    String description, 
    String name, 
    String stationID,
  }) _fieldRecord = (
    name: 'name',
    stationID: 'stationID',
    description: 'description',
  );

  static DocChecker _getChecker () {
    Map<String, FieldChecker> fieldCheckers = {
      _fieldRecord.description: FieldChecker.typeChecker<String?>(),
      _fieldRecord.name: FieldChecker.typeChecker<String>(),
      _fieldRecord.stationID: 
        FieldChecker.docRefChecker(NewStation.collectionId),
    };

    return DocChecker(fieldCheckers, (json) => []);
  }

  // ---- Overridden members ---- //

  @override
  String get name => doc.document[_fieldRecord.name]; 

  /// UNIMPLEMENTED
  @override
  set name(String newName) {
    // TODO implement set name
    throw UnimplementedError();
  }
  
  @override
  /// UNIMPLEMENTED
  StationInterface get station {
    // TODO implement get station
    throw UnimplementedError();
  }

  @override
  /// UNIMPLEMENTED
  set station(StationInterface newStation) {
    // implement set station
    throw UnimplementedError();
  }

}
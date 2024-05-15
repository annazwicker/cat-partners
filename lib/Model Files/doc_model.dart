import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/types_and_funcs.dart';
import 'doc_checker.dart';

/// Represents a document in Firestore.
class DocModel {
  
  /// This [DocModel]'s snapshot.
  DocumentSnapshot<Json> snapshot;

  /// This [DocModel]'s JSON document.
  Json get document => snapshot.data()!;
  
  DocModel(this.snapshot, DocChecker checker){
    checkSnapshot(snapshot, checker);
  }

}

/// Checks the given [DocumentSnapshot]'s data against the given [DocChecker].
/// Throws an exception if the snapshot has no data, or if the snapshot's
/// data fails the [DocChecker]'s verification.
void checkSnapshot(
    DocumentSnapshot<Json> snapshot, 
    DocChecker checker) 
      {
    var errorMessages = checker.verifySnapshot(snapshot);
    if(errorMessages.isNotEmpty) throw InvalidDocumentException(errorMessages);
  }

/// Exception thrown when a JSON document does not pass a DocChecker run upon 
/// it. Contains a list of error messages generated during the verificaiton
/// process.
class InvalidDocumentException implements Exception {
  final List<String> errorMessages;
  InvalidDocumentException(this.errorMessages);
}
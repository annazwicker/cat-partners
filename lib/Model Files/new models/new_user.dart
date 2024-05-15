import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/types_and_funcs.dart';
import '../doc_checker.dart';
import '../doc_model.dart';

abstract class UserInterface {

  /// This user's name.
  String get name;

  /// Sets this user's name.
  set name(String newName);

  /// Retrieves this user's private data, if the current user is authorized
  /// to access it. The current user is authorized if the private data requested
  /// belongs to them, or if the current user is an administrative user.
  PrivateUserDataInterface? getPrivateData();
  
}

class SiteUser implements UserInterface{
  DocModel doc;

  SiteUser._(this.doc);

  factory SiteUser.fromSnapshot(DocumentSnapshot<Json> snapshot) {
    return SiteUser._(DocModel(snapshot, _getChecker()));
  }

  static DocChecker _getChecker() {
    Map<String, FieldChecker> fieldCheckers = {};

    return DocChecker(fieldCheckers, (json) => []);
  }

  static const String collectionId = 'users';
  
  static const ({
    String affilation, 
    String email, 
    String isAdmin, 
    String name, 
    String phoneNumber, 
    String rescueGroups
  }) _fieldRecord = (
    name: 'name',
    email: 'email',
    affilation: 'affiliation',
    isAdmin: 'isAdmin',
    phoneNumber: 'phoneNumber',
    rescueGroups: 'rescueGroupAffiliaton',
  );

  @override
  String get name => doc.document[_fieldRecord.name];
  
  @override
  PrivateUserDataInterface? getPrivateData() {
    // TODO: implement getPrivateData
    throw UnimplementedError();
  }
  
  @override
  set name(String newName) {
    // TODO: implement name
    throw UnimplementedError();
  }

}

abstract class PrivateUserDataInterface {

  // Getters

  /// Whether this user is an admin.
  bool get isAdmin;

  /// This user's affiliation with SU. This could be student, alumni, 
  /// faculty/staff, a parent of a student, or unrelated ("Friend of Cats").
  String get affiliation;

  /// This user's phone number. User may not have provided a phone number.
  String? get phoneNumber;

  /// This user's email address, as given by Google.
  String get email;

  /// The list of rescue groups this user is affiliated with.
  List<String> get rescueGroups;


  // Modifiers
  
  /// Sets this user's affiliation with SU.
  set affiliation(String newAffiliation);

  /// Sets this user's phone number.
  set phoneNumber(String? newNumber);

  /// Sets this user's admin status. This can only be done by another 
  /// administrative user.
  set isAdmin(bool adminPerms);

  /// Sets the Firebase account associated with this user to the given ID.
  void setFirebaseAccount(String firebaseID);

  /// Adds the given rescue group to this user's list.
  /// Returns whether the group was added. A group is not added if the given 
  /// group is already in the user's list.
  bool addRescueGroup(String newGroup);

  /// Whether this user is affiliated with the given group.
  bool hasRescueGroup(String rescueGroup);

  /// Removes this user's affiliation with the rescue group in their list at
  /// the given index.
  void removeRescueGroup(int index);
  
}

class PrivateUserData implements PrivateUserDataInterface{
  DocModel doc;

  PrivateUserData._(this.doc);

  static const ({
    String affilation, 
    String email, 
    String isAdmin, 
    String phoneNumber, 
    String rescueGroups
  }) _fieldRecord = (
    email: 'email',
    affilation: 'affiliation',
    isAdmin: 'isAdmin',
    phoneNumber: 'phoneNumber',
    rescueGroups: 'rescueGroupAffiliaton',
  );

  factory PrivateUserData.fromSnapshot(DocumentSnapshot<Json> snapshot){
    return PrivateUserData._(DocModel(snapshot, _getChecker()));
  }

  static DocChecker _getChecker() {
    Map<String, FieldChecker> fieldCheckers = {};
    return DocChecker(fieldCheckers, (json) => []);
  }
  
  @override
  String get affiliation => doc.document[_fieldRecord.affilation];
  
  @override
  bool get isAdmin => doc.document[_fieldRecord.isAdmin];
  
  @override
  String? get phoneNumber => doc.document[_fieldRecord.phoneNumber];

  @override
  String get email => doc.document[_fieldRecord.email];
  
  @override
  bool addRescueGroup(String newGroup) {
    // TODO: implement addRescueGroup
    throw UnimplementedError();
  }
  
  @override
  bool hasRescueGroup(String rescueGroup) {
    // TODO: implement hasRescueGroup
    throw UnimplementedError();
  }
  
  @override
  void removeRescueGroup(int index) {
    // TODO: implement removeRescueGroup
    throw UnimplementedError();
  }
  
  @override
  // TODO: implement rescueGroups
  List<String> get rescueGroups => throw UnimplementedError();
  
  @override
  void setFirebaseAccount(String firebaseID) {
    // TODO: implement setFirebaseAccount
    throw UnimplementedError();
  }
  
  @override
  set affiliation(String newAffiliation) {
    // TODO: implement affiliation
    throw UnimplementedError();
  }
  
  @override
  set isAdmin(bool adminPerms) {
    // TODO: implement isAdmin
    throw UnimplementedError();
  }
  
  @override
  set phoneNumber(String? newNumber) {
    // TODO: implement phoneNumber
    throw UnimplementedError();
  }

}
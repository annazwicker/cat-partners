import 'package:cloud_firestore/cloud_firestore.dart';

import 'model.dart';

class Station extends Model{

  static const String descString = 'description';
  static const String fullNameString = 'fullName';
  static const String nameString = 'name';
  static const String photoString = 'photo';
  static const String dateCreatedString = 'dateCreated';
  static const String dateDeletedString = 'dateDeleted';

  final String _description;
  final String _fullName;
  final String _name;
  final String _photo;
  final Timestamp _dateCreated;
  final Timestamp? _dateDeleted;

  String get description => _description;
  String get name => _name;
  String get fullName => _fullName;
  String get photo => _photo;
  Timestamp get dateCreated => _dateCreated;
  Timestamp? get dateDeleted => _dateDeleted;

  Station({
    required String description, 
    required String fullName, 
    required String name,
    required String photo, 
    required Timestamp dateCreated,
    Timestamp? dateDeleted}
  ) : 
    _description = description,
    _fullName = fullName,
    _name = name,
    _photo = photo,
    _dateCreated = dateCreated,
    _dateDeleted = dateDeleted
    ;

  factory Station.fromJson(Map<String, dynamic> json) => Station(
    description: json[descString],
    fullName: json[fullNameString],
    name: json[nameString],
    photo: json[photoString],
    dateCreated: json[dateCreatedString],
    dateDeleted: json[dateDeletedString],
  );  
  
  Map<String, dynamic> toJson() => {
    Station.descString: _description,
    Station.fullNameString: _fullName,
    Station.nameString: _name,
    Station.photoString: _photo,
    Station.dateCreatedString: _dateCreated,
    Station.dateDeletedString: _dateDeleted,
  };

}
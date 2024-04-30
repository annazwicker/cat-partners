import 'package:cloud_firestore/cloud_firestore.dart';

import 'model.dart';

class Cat extends Model {
  final String description;
  final String name;
  final String photo;
  final DocumentReference stationID; //reference attribute

  Cat({
    required this.description,
    required this.name,
    required this.photo,
    required this.stationID,
  });


  //static method that converts JSON query document into Cat class object
  factory Cat.fromJson(Map<String, dynamic> json) => Cat(
    description: json['description'],
    name: json['name'],
    photo: json['photo'],
    stationID: json['stationID'],
  );

  Map<String, dynamic> toJson() => {
    'description' : description,
    'name' : name,
    'photo' : photo,
    'stationID' : stationID,
  };



}

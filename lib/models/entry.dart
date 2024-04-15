import 'package:cloud_firestore/cloud_firestore.dart';

class Entry {
  late final DocumentReference? assignedUser;
  final Timestamp date;
  final String note;
  final DocumentReference stationID; //reference attribute

  Entry({
    required this.assignedUser,
    required this.date,
    required this.note,
    required this.stationID,
  });


  //static method that converts JSON query document into Cat class object
  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
    assignedUser: json['assignedUser'],
    date: json['date'],
    note: json['note'],
    stationID: json['stationID'],
  );

  Map<String, dynamic> toJson() => {
    'assignedUser' : assignedUser,
    'date' : date,
    'note' : note,
    'stationID' : stationID,
  };

  Entry copyWith({
    DocumentReference? assignedUser,
    Timestamp? date,
    String? note,
    DocumentReference? stationID,
  }) {
    return Entry (
      assignedUser: assignedUser ?? this.assignedUser, 
      date: date ?? this.date, 
      note: note ?? this.note, 
      stationID: stationID ?? this.stationID);
  }

  DateTime getDate() {
    return date.toDate();
  }
  
  String getNote() {
    return note;
  }

  /// TODO retrieve assigned user's first name OR null
  // String? getUserName(FirebaseHelper _dbHelper) {
  //   return _dbHelper._
  // }

}

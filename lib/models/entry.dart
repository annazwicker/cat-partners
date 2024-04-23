import 'package:cloud_firestore/cloud_firestore.dart';


class Entry {

  static const String userRefString = 'assignedUser';
  static const String dateString = 'date';
  static const String noteString = 'note';
  static const String stationRefString = 'stationID';

  final DocumentReference? _assignedUser;
  final Timestamp _date;
  final String _note;
  final DocumentReference _stationID; //reference attribute

  Entry({
    required DocumentReference? assignedUser,
    required Timestamp date,
    required String note,
    required DocumentReference stationID,
  }) : 
    _assignedUser = assignedUser, 
    _date = date,
    _note = note,
    _stationID = stationID;

  DocumentReference? get assignedUser => _assignedUser; 
  Timestamp get date => _date; 
  String get note => _note; 
  DocumentReference get stationID => _stationID; 


  //static method that converts JSON query document into Cat class object
  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
    assignedUser: json[userRefString],
    date: json[dateString],
    note: json[noteString],
    stationID: json[stationRefString],
  );

  Map<String, dynamic> toJson() => {
    userRefString : _assignedUser,
    dateString : _date,
    noteString : _note,
    stationRefString : _stationID,
  };

  Entry copyWith({
    DocumentReference? assignedUser,
    Timestamp? date,
    String? note,
    DocumentReference? stationID,
  }) {
    return Entry (
      assignedUser: assignedUser ?? this._assignedUser, 
      date: date ?? this.date, 
      note: note ?? this.note, 
      stationID: stationID ?? this.stationID);
  }

  Entry copyWithUser(DocumentReference? assignedUser) => Entry(
    assignedUser: assignedUser,
    date: _date,
    note: _note,
    stationID: _stationID);

  DocumentReference? getUserID() {
    return _assignedUser;
  }

  @override
  String toString() {
    return toJson().toString();
  }

  /// TODO retrieve assigned user's first name OR null
  // String? getUserName(FirebaseHelper _dbHelper) {
  //   return _dbHelper._
  // }

}

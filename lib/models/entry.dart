class Entry {
  final String assignedUser;
  final String assignedUserCollection;
  final String assignedUserPID;
  final String date;
  final String note;
  final String stationID; //reference attribute
  final String stationCollection; //collection of reference attribute
  final String stationPID;  //document ID of the referenced attribute

  Entry({
    required this.assignedUser,
    required this.date,
    required this.note,
    required this.stationID,
  })   : stationCollection = stationID.split('/')[0],
        stationPID = stationID.split('/')[1],
        assignedUserCollection = assignedUser.split('/')[0],
        assignedUserPID = assignedUser.split('/')[1];


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



}

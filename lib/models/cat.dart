class Cat {
  final String description;
  final String name;
  final String photo;
  final String stationID; //reference attribute
  final String stationCollection; //collection of reference attribute
  final String stationPID;  //document ID of the referenced attribute

  Cat({
    required this.description,
    required this.name,
    required this.photo,
    required this.stationID,
  })   : stationCollection = stationID.split('/')[0],
        stationPID = stationID.split('/')[1];


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

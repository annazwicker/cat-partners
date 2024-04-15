class Station {
  final String description;
  final String fullName;
  final String name;
  final String photo;

  Station({
    required this.description, 
    required this.fullName, 
    required this.name,
    required this.photo, });

  factory Station.fromJson(Map<String, dynamic> json) => Station(
    description: json['description'],
    fullName: json['fullName'],
    name: json['name'],
    photo: json['photo'],
  );  
  
  Map<String, dynamic> toJson() => {
    'description': description,
    'fullName': fullName,
    'name': name,
    'photo': photo,
  };

}
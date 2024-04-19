class UserDoc {
  /// Named 'UserDoc' instead of 'User' because 'User is already a class
  /// in Firebase auth.

  /// Field constants
  static const String firstNameString = 'first';
  static const String lastNameString = 'last';
  static const String birthYearString = 'born';

  /// Fields
  final String first;
  final String last;
  final int born;

  UserDoc({
    required this.first,
    required this.last,
    required this.born,
  });

  factory UserDoc.fromJson(Map<String, dynamic> json) => UserDoc(
    first: json[firstNameString],
    last: json[lastNameString],
    born: json[birthYearString],
  );

  Map<String, dynamic> toJson() => {
    firstNameString: first,
    lastNameString: last,
    birthYearString: born,
  };


}
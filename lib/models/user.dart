class User {
  /// Field constants
  static const String firstNameString = 'first';
  static const String lastNameString = 'last';
  static const String birthYearString = 'born';

  /// Fields
  final String first;
  final String last;
  final int born;

  User({
    required this.first,
    required this.last,
    required this.born,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
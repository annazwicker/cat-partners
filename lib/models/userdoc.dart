class UserDoc {
  /// Named 'UserDoc' instead of 'User' because 'User is already a class
  /// in Firebase auth.

  /// Field constants
  static const String firstNameString = 'first';
  static const String lastNameString = 'last';
  static const String birthYearString = 'born';

  /// Fields
  final String _first;
  final String _last;
  final int _born;

  UserDoc({
    required first,
    required last,
    required born,
  }) :
    _first = first,
    _last = last,
    _born = born;

  factory UserDoc.fromJson(Map<String, dynamic> json) => UserDoc(
    first: json[firstNameString],
    last: json[lastNameString],
    born: json[birthYearString],
  );

  Map<String, dynamic> toJson() => {
    firstNameString: _first,
    lastNameString: _last,
    birthYearString: _born,
  };

  String getName() {
    return "$_first $_last";
  }
}
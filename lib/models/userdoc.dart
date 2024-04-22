class UserDoc {
  /// Named 'UserDoc' instead of 'User' because 'User is already a class
  /// in Firebase auth.

  /// Field constants
  static const String firstNameString = 'first';
  static const String lastNameString = 'last';
  static const String birthYearString = 'born';
  static const String isAdminString = 'isAdmin';
  static const String nameString = 'name';
  static const String affiliationString = 'affiliation';
  static const String rescueGroupString = 'rescueGroupAffiliaton';
  static const String phoneNumberString = 'phoneNumber';
  static const String emailString = 'email';

  /// Fields
  final String _first;
  final String _last;
  final int _born;
  final bool _isAdmin;
  final String _name;
  final String _affiliation;
  final String _rescueGroup;
  final String _phoneNumber;
  final String _email;

  UserDoc({
    required first,
    required last,
    required born,
    required isAdmin,
    required name,
    required affiliation,
    required rescueGroup,
    required phoneNumber,
    required email
  }) :
    _first = first,
    _last = last,
    _born = born,
    _isAdmin = isAdmin,
    _name = name,
    _affiliation = affiliation,
    _rescueGroup = rescueGroup,
    _phoneNumber = phoneNumber,
    _email = email;

  factory UserDoc.fromJson(Map<String, dynamic> json) => UserDoc(
    first: json[firstNameString],
    last: json[lastNameString],
    born: json[birthYearString],
    isAdmin: json[isAdminString],
    name: json[nameString],
    affiliation: json[affiliationString],
    rescueGroup: json[rescueGroupString],
    phoneNumber: json[phoneNumberString],
    email: json[emailString],
  );

  Map<String, dynamic> toJson() => {
    firstNameString: _first,
    lastNameString: _last,
    birthYearString: _born,
    isAdminString: _isAdmin,
    nameString: _name,
    affiliationString: _affiliation,
    rescueGroupString: _rescueGroup,
    phoneNumberString: _phoneNumber,
    emailString: _email,
  };

  UserDoc copyWith({
    String? first,
    String? last,
    int? born,
    bool? isAdmin,
    String? name,
    String? affiliation,
    String? rescueGroup,
    String? phoneNumber,
    String? email,
  }) => UserDoc(
      born: born ?? _born,
      first: first ?? _first,
      last: last ?? _last,
      isAdmin: isAdmin ?? _isAdmin,
      name: name ?? _name,
      affiliation: affiliation ?? _affiliation,
      rescueGroup: rescueGroup ?? _rescueGroup,
      phoneNumber: phoneNumber ?? _phoneNumber,
      email:  email ?? _email);

  String getName() {
    return "$_first $_last";
  }

}
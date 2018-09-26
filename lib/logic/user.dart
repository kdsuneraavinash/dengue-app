class User {
  static const String BLANK_PHOTO =
      "https://www.qualiscare.com/wp-content/uploads/2017/08/default-user.png";

  String _fullName;
  String _displayName;
  String _email;
  String _photoUrl;
  String _address;
  String _telephone;
  String _id;
  int _points = 0;

  void setUser(
      {String id,
      String displayName,
      String email,
      String photoUrl,
      String fullName,
      String address,
      String telephone}) {
    _id = id ?? _id;
    _displayName = displayName ?? _displayName;
    _email = email ?? _email;
    _photoUrl = photoUrl ?? _photoUrl;
    _fullName = fullName ?? _fullName;
    _address = address ?? _address;
    _telephone = telephone ?? _telephone;
  }

  set points(p) {
    _points = p;
  }

  String get fullName => _fullName;
  String get displayName => _displayName;
  int get points => _points;
  String get id => _id;
  String get telephone => _telephone;
  String get address => _address;
  String get photoUrl => _photoUrl;
  String get email => _email;

  User();

  factory User.demo() {
    User user = User()
      ..setUser(
        displayName: "Curt",
        email: "curtainCall",
        id: "154154154",
        photoUrl:
            "https://www.gannett-cdn.com/presto/2018/09/06/PDTF/a15ba8e1-519e-4196-9ee2-5dbaec87d9a4-Detroit_rapper_Eminem-15.JPG",
        fullName: "Curt N. Call",
        address: "4554, Doctors Drive, Los Angeles, California.",
        telephone: "098-4546789",
      );
    return user;
  }
}

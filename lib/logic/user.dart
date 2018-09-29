import 'package:firebase_auth/firebase_auth.dart';

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

  User.fromMap(String id, Map<String, dynamic> map) {
    _id = id;
    _displayName = map['displayName'] ?? "[ERR]";
    _email = map['email'] ?? "[ERR]";
    _photoUrl = '${map['photoUrl']}?type=large' ?? "[ERR]";
    _telephone = map['telephone'] ?? "[NOT SET]";
    _fullName = map['fullName'] ?? "[NOT SET]";
    _address = map['address'] ?? "[NOT SET]";
    _points = map['points'] ?? 0;
  }

  User.fromFirebaseUser(FirebaseUser firebaseUser) {
    _id = firebaseUser.uid;
    _displayName = firebaseUser.displayName;
    _email = firebaseUser.email;
    _photoUrl = firebaseUser.photoUrl + "?type=large";
    _telephone = "[NOT SET]";
    _fullName = "[NOT SET]";
    _address = "[NOT SET]";
    _points = 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': _displayName,
      'email': _email,
      'photoUrl': _photoUrl.replaceFirst( "?type=large", ""),
      'fullName': _fullName,
      'address': _address,
      'telephone': _telephone,
      'points': _points,
    };
  }

  @override
  int get hashCode => _id.hashCode;

  @override
  bool operator ==(other) {
    if (other is User) {
      return false;
    } else {
      return _id == other.id;
    }
  }

  bool equals(User otherUser) {
    if (otherUser == null){
      return false;
    }
    return (_points == otherUser.points) &&
        (_displayName == otherUser.displayName) &&
        (_email == otherUser.email) &&
        (_photoUrl == otherUser.photoUrl) &&
        (_fullName == otherUser.fullName) &&
        (_address == otherUser.address) &&
        (_telephone == otherUser.telephone);
  }
}

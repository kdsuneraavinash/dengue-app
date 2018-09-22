class User {
  String _name;
  String _displayName;
  String _address;
  int _points;

  User({String name, String displayName, String address, int points}) {
    this._name = name;
    this._address = address;
    this._displayName = displayName;
    this._points = points;
  }

  String get name => _name;

  String get displayName => _displayName;

  String get address => _address;

  int get points => _points;
}

class Post {
  String _user;
  String _caption;
  String _beforeLink;
  String _afterLink;
  int _likes;
  int _shares;

  Post(
      {String user,
      String caption,
      String beforeLink,
      String afterLink,
      int likes,
      int shares}) {
    this._user = user;
    this._beforeLink = beforeLink;
    this._afterLink = afterLink;
    this._caption = caption;
    this._likes = likes;
    this._shares = shares;
  }

  String get user => _user;

  String get caption => _caption;

  String get beforeLink => _beforeLink;

  String get afterLink => _afterLink;

  int get likes => _likes;

  int get shares => _shares;
}

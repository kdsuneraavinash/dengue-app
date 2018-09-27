class Post {
  String _user;
  String _caption;
  String _mediaLink;
  int _likes;
  int _shares;

  Post(
      {String user,
      String caption,
      String mediaLink,
      int likes,
      int shares}) {
    this._user = user;
    this._mediaLink = mediaLink;
    this._caption = caption;
    this._likes = likes;
    this._shares = shares;
  }

  String get user => _user;

  String get caption => _caption;

  String get mediaLink => _mediaLink;

  int get likes => _likes;

  int get shares => _shares;
}

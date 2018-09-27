class Post {
  String _user;
  String _caption;
  String _mediaLink;
  bool _approved;
  int _rating;
  String _sharableLink;
  DateTime _datePosted;

  Post({
    String user,
    String caption,
    String mediaLink,
    bool approved = false,
    int rating = 0,
    String sharableLink = "",
  }) {
    this._user = user;
    this._mediaLink = mediaLink;
    this._caption = caption;
    this._approved = approved;
    this._rating = rating;
    this._sharableLink = sharableLink;
    this._datePosted = DateTime.now();
  }

  factory Post.fromMap(Map<String, dynamic> data) {
    return Post(
      user: data["user"],
      mediaLink: data["mediaLink"],
      caption: data["caption"],
      approved: data["approved"],
      rating: data["rating"],
      sharableLink: data["sharableLink"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "user": this.user,
      "mediaLink": this.mediaLink,
      "caption": this.caption,
      "approved": this.approved,
      "rating": this.rating,
      "sharableLink": this.sharableLink,
      "datePosted": this.datePosted,
    };
  }

  String get user => _user;

  String get caption => _caption;

  String get mediaLink => _mediaLink;

  String get sharableLink => _sharableLink;

  int get rating => _rating;

  bool get approved => _approved;

  DateTime get datePosted => _datePosted;
}

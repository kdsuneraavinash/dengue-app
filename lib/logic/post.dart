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
    bool addDate = true,
    DateTime datePosted,
  }) {
    this._user = user;
    this._mediaLink = mediaLink;
    this._caption = caption;
    this._approved = approved;
    this._rating = rating;
    this._sharableLink = sharableLink;
    if (addDate) {
      this._datePosted = DateTime.now();
    } else {
      this._datePosted = datePosted;
    }
  }

  factory Post.fromMap(Map<String, dynamic> data) {
    return Post(
        user: data["user"],
        mediaLink: data["mediaLink"],
        caption: data["caption"],
        approved: data["approved"],
        rating: data["rating"],
        sharableLink: data["sharableLink"],
        addDate: false,
        datePosted: data["datePosted"]);
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

  // Format Date to string
  String get formattedDatePosted {
    String str = "";
    List<String> months = [
      'Jan',
      'Feb',
      'March',
      'April',
      'May',
      'June',
      'July',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    str += '${datePosted.year} ${months[datePosted.month - 1]} ${datePosted.day} ' +
        'at ${(datePosted.hour % 12 == 0) ? 12 : (datePosted.hour % 12)}:${datePosted.minute.toString().padRight(2, '0')} ${datePosted.hour / 12 == 0 ? "AM" : "PM"}';
    return str;
  }
}

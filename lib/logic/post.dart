enum PostType { WeeklyPost, Image, Text }

class Post {
  PostType _type;
  String _userId;
  String _userName;
  String _userPhoto;
  String _caption;
  String _mediaLink;
  bool _approved;
  int _rating;
  String _sharableLink;
  DateTime _datePosted;
  String _videoLink;

  Post({
    PostType type,
    String userId,
    String userName,
    String userPhoto,
    String caption,
    String mediaLink,
    bool approved = false,
    int rating = 0,
    String sharableLink = "",
    bool addDate = true,
    DateTime datePosted,
    String videoLink,
  }) {
    this._type = type ?? PostType.Image;
    this._userId = userId;
    this._userName = userName;
    this._userPhoto = userPhoto;
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
    this._videoLink = videoLink ?? "";
  }

  factory Post.fromMap(Map<String, dynamic> data) {
    PostType postType;
    switch (data["type"]) {
      //WeeklyPost, Gallery, Camera, Text
      case "WeeklyPost":
        postType = PostType.WeeklyPost;
        break;
      case "Image":
        postType = PostType.Image;
        break;
      case "Text":
        postType = PostType.Text;
        break;
      default:
        postType = PostType.Image;
    }

    return Post(
      type: postType,
      userId: data["userId"] ?? "",
      userName: data["userName"],
      userPhoto: data["userPhoto"],
      mediaLink: data["mediaLink"],
      caption: data["caption"],
      approved: data["approved"],
      rating: data["rating"],
      sharableLink: data["sharableLink"],
      addDate: false,
      datePosted: data["datePosted"],
      videoLink: data["videoLink"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    String postType;
    switch (this.type) {
      case PostType.Image:
        postType = "Image";
        break;
      case PostType.Text:
        postType = "Text";
        break;
      case PostType.WeeklyPost:
        postType = "WeeklyPost";
        break;
    }

    return {
      "type": postType,
      "userId": userId,
      "userName": this.userName,
      "userPhoto": this.userPhoto,
      "mediaLink": this.mediaLink,
      "caption": this.caption,
      "approved": this.approved,
      "rating": this.rating,
      "sharableLink": this.sharableLink,
      "datePosted": this.datePosted,
      "videoLink": this.videoLink,
    };
  }

  String get userId => _userId;

  String get userName => _userName;

  String get userPhoto => _userPhoto;

  String get caption => _caption;

  String get mediaLink => _mediaLink;

  String get videoLink => _videoLink;

  String get sharableLink => _sharableLink;

  int get rating => _rating;

  bool get approved => _approved;

  DateTime get datePosted => _datePosted;

  PostType get type => _type;

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
        'at ${(datePosted.hour % 12 == 0) ? 12 : (datePosted.hour % 12)}:${datePosted.minute.toString().padLeft(2, '0')} ${datePosted.hour / 12 == 0 ? "AM" : "PM"}';
    return str;
  }
}

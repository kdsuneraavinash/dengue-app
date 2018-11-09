enum StatisticAction {
  SharedPost,
  ReadArticle,
  SharedArticle,
  WeeklyPost,
  WatchedAd
}

class Statistics {
  int _postsShared = 0;
  int _readArticles = 0;
  int _sharedArticles = 0;
  int _weeklyPost = 0;
  int _adsWatched = 0;

  Statistics(
      {int postsShared,
      int readArticles,
      int sharedArticles,
      int weeklyPost,
      int adsWatched}) {
    _postsShared = postsShared ?? _postsShared;
    _readArticles = readArticles ?? _readArticles;
    _sharedArticles = sharedArticles ?? _sharedArticles;
    _weeklyPost = weeklyPost ?? _weeklyPost;
    _adsWatched = adsWatched ?? _adsWatched;
  }

  int get postsShared => _postsShared;

  int get readArticles => _readArticles;

  int get sharedArticles => _sharedArticles;

  int get weeklyPost => _weeklyPost;

  int get adsWatched => _adsWatched;

  Statistics.fromMap(Map<String, dynamic> map) {
    _postsShared = map['postsShared'] ?? 0;
    _readArticles = map['readArticles'] ?? 0;
    _sharedArticles = map["sharedArticles"] ?? 0;
    _weeklyPost = map['weeklyPost'] ?? 0;
    _adsWatched = map['adsWatched'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'postsShared': _postsShared,
      'readArticles': _readArticles,
      'sharedArticles': _sharedArticles,
      'weeklyPost': _weeklyPost,
      'adsWatched': _adsWatched,
    };
  }

  void doAction(StatisticAction action) {
    switch (action) {
      case StatisticAction.ReadArticle:
        _readArticles += 1;
        break;
      case StatisticAction.SharedArticle:
        _sharedArticles += 1;
        break;
      case StatisticAction.SharedPost:
        _postsShared += 1;
        break;
      case StatisticAction.WatchedAd:
        _adsWatched += 1;
        break;
      case StatisticAction.WeeklyPost:
        _weeklyPost += 1;
        break;
    }
  }

  int calculatePoints() {
    return postsShared * 5 +
        readArticles * 30 +
        sharedArticles * 150 +
        weeklyPost * 250 +
        adsWatched * 15;
  }
}

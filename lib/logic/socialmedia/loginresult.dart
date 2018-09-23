
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

enum LogInResultStatus { loggedIn, error, cancelledByUser }

class Session {
  String _token;
  String _userId;

  Session(this._token, this._userId);

  String get userId => _userId;
  String get token => _token;
}

class LogInResult {
  final LogInResultStatus _status;
  final String _errorMessage;
  final Session _session;

  LogInResult(this._status, this._errorMessage, this._session);

  factory LogInResult.fromFacebook(FacebookLoginResult result) {
    LogInResultStatus tmpStatus;
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        tmpStatus = LogInResultStatus.loggedIn;
        break;
      case FacebookLoginStatus.cancelledByUser:
        tmpStatus = LogInResultStatus.cancelledByUser;
        break;
      case FacebookLoginStatus.error:
        tmpStatus = LogInResultStatus.error;
        break;
    }
    return LogInResult(tmpStatus, result?.errorMessage,
        Session(result?.accessToken?.token, result?.accessToken?.userId));
  }

//  factory LogInResult.fromTwitter(TwitterLoginResult result) {
//    LogInResultStatus tmpStatus;
//    switch (result.status) {
//      case TwitterLoginStatus.loggedIn:
//        tmpStatus = LogInResultStatus.loggedIn;
//        break;
//      case TwitterLoginStatus.cancelledByUser:
//        tmpStatus = LogInResultStatus.cancelledByUser;
//        break;
//      case TwitterLoginStatus.error:
//        tmpStatus = LogInResultStatus.error;
//        break;
//    }
//    return LogInResult(tmpStatus, result?.errorMessage,
//        Session(result?.session?.token, result?.session?.userId));
//  }

  LogInResultStatus get status => _status;
  String get errorMessage => _errorMessage;
  Session get session => _session;
}

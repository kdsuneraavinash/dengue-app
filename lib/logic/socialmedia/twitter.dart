import 'dart:async';

import 'package:dengue_app/logic/socialmedia/controller.dart';
import 'package:dengue_app/logic/socialmedia/loginresult.dart';

class TwitterController extends SocialMediaController {
//  TwitterLoginResult _loginResult;
//  TwitterLogin _twitterLogin;

  TwitterController() {
//    _twitterLogin = TwitterLogin(
//      consumerKey: '<consumer_key>',
//      consumerSecret: '<consumer_secret>',
//    );
  }

  @override
  Future<LogInResult> login() async {
    return LogInResult(LogInResultStatus.error, "Not Implemented Yet.", null);
//     _loginResult = await _twitterLogin.authorize();
//     return LogInResult.fromTwitter(_loginResult);
  }

  @override
  void logOut() async {
//    await _twitterLogin.logOut();
  }
}

import 'dart:async';

import 'package:dengue_app/logic/socialmedia/controller.dart';
import 'package:dengue_app/logic/socialmedia/loginresult.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FacebookController extends SocialMediaController {
  FacebookLoginResult _loginResult;
  FacebookLogin _facebookLogin;

  FacebookController() {
    _facebookLogin = FacebookLogin();
  }

  @override
  Future<LogInResult> login() async {
    _loginResult = await _facebookLogin.logInWithReadPermissions(['email']);
    return LogInResult.fromFacebook(_loginResult);
  }

  @override
  void logOut() async {
    await _facebookLogin.logOut();
  }
}

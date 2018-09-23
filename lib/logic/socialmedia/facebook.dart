import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

    var graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${_loginResult.accessToken.token}');
    var profile = json.decode(graphResponse.body);
    print(profile.toString());

    user.setBasicDetails(
      displayName: profile["name"],
      email: profile["email"],
      id: profile["id"],
      photoUrl:
          "https://graph.facebook.com/${profile["id"]}/picture?type=large",
    );
    return LogInResult.fromFacebook(_loginResult);
  }

  @override
  void logOut() async {
    await _facebookLogin.logOut();
  }
}

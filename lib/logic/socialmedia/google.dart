import 'dart:async';

import 'package:dengue_app/logic/socialmedia/controller.dart';
import 'package:dengue_app/logic/socialmedia/loginresult.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleController extends SocialMediaController {
//  TwitterLoginResult _loginResult;
  GoogleSignIn _googleSignIn;

  GoogleController() {
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
  }

  @override
  Future<LogInResult> login() async {
    try {
      GoogleSignInAccount googleSignIn = await _googleSignIn.signIn();
      return LogInResult(LogInResultStatus.loggedIn, null,
          Session(googleSignIn?.id, googleSignIn?.email));
    } catch (error) {
      return LogInResult(LogInResultStatus.error, error.toString(), null);
    }
//     _loginResult = await _twitterLogin.authorize();
//     return LogInResult.fromTwitter(_loginResult);
  }

  @override
  void logOut() async {
    await _googleSignIn.signOut();
  }
}

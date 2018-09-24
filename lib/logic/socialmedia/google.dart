import 'dart:async';

import 'package:dengue_app/logic/socialmedia/controller.dart';
import 'package:dengue_app/logic/socialmedia/loginresult.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleController extends SocialMediaController {
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
      GoogleSignInAccount googleAccount = await _googleSignIn.signIn();

      user = User()
        ..setBasicDetails(
          displayName: googleAccount.displayName,
          email: googleAccount.email,
          id: googleAccount.id,
          photoUrl: googleAccount.photoUrl,
        );
      return LogInResult(LogInResultStatus.loggedIn, null,
          Session(googleAccount?.id, googleAccount?.email));
    } catch (error) {
      return LogInResult(LogInResultStatus.error, error.toString(), null);
    }
//     _loginResult = await _twitterLogin.authorize();
//     return LogInResult.fromTwitter(_loginResult);
  }

  @override
  void logOut() async {
    await _googleSignIn.signOut();
    user = null;
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _googleSignIn.isSignedIn();
  }
}

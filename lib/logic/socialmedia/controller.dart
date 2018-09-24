import 'dart:async';

import 'package:dengue_app/logic/socialmedia/loginresult.dart';
import 'package:dengue_app/logic/user.dart';

abstract class SocialMediaController {
  User user = User();

  Future<LogInResult> login();

  void logOut();

  Future<bool>  isLoggedIn();
}
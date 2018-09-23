import 'dart:async';

import 'package:dengue_app/logic/socialmedia/loginresult.dart';
import 'package:dengue_app/logic/user.dart';

abstract class SocialMediaController {
  User _user = User();

  Future<LogInResult> login();

  void logOut();

  User get user => _user;
}
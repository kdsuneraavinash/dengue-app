import 'dart:async';

import 'package:dengue_app/bloc/bloc.dart';
import 'package:dengue_app/logic/socialmedia/controller.dart';
import 'package:dengue_app/logic/socialmedia/facebook.dart';
import 'package:dengue_app/logic/socialmedia/google.dart';
import 'package:dengue_app/logic/socialmedia/loginresult.dart';
import 'package:dengue_app/logic/socialmedia/twitter.dart';
import 'package:dengue_app/logic/user.dart';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

enum LogInProgress { NOT_LOGGED, WAITING, LOGGED, LOGIN_ERROR }
enum LogInCommand { FACEBOOK_LOGIN, TWITTER_LOGIN, GOOGLE_LOGIN, LOGOUT }

class LoginBLoC extends BLoC {
  // Streams and Sinks
  final BehaviorSubject<LogInResult> _loginResultStream =
      BehaviorSubject(seedValue: null);
  final BehaviorSubject<User> _userStream = BehaviorSubject(seedValue: null);
  final BehaviorSubject<PageController> _pageControllerData = BehaviorSubject();
  final BehaviorSubject<LogInProgress> _logInState =
      BehaviorSubject(seedValue: LogInProgress.NOT_LOGGED);
  final StreamController<LogInCommand> _issueSocialMediaCommand =
      StreamController();

  Stream<LogInResult> get loginResult => _loginResultStream.stream;
  Stream<User> get userStream => _userStream.stream;
  Stream<LogInProgress> get logInState => _logInState.stream;
  Stream<PageController> get pageControllerData => _pageControllerData.stream;
  Sink<LogInCommand> get issueSocialMediaCommand =>
      _issueSocialMediaCommand.sink;

  // Instance Variables
  PageController _pageController = PageController(initialPage: 0);
  LogInResult _loginResult;
  SocialMediaController _socialMediaLogin;

  LoginBLoC() {
    _pageControllerData.add(_pageController);
    _issueSocialMediaCommand.stream.listen(_handleFacebookCommand);
  }

  @override
  void dispose() {
    _loginResultStream.close();
    _userStream.close();
    _logInState.close();
    _pageControllerData.close();
    _issueSocialMediaCommand.close();
  }

  void _handleFacebookCommand(LogInCommand command) {
    _logInState.add(LogInProgress.WAITING);
    switch (command) {
      case LogInCommand.FACEBOOK_LOGIN:
        if (!(_socialMediaLogin is FacebookController)) {
          _socialMediaLogin = FacebookController();
        }
        _signInSocialMedia();
        break;
      case LogInCommand.TWITTER_LOGIN:
        if (!(_socialMediaLogin is TwitterController)) {
          _socialMediaLogin = TwitterController();
        }
        _signInSocialMedia();
        break;
      case LogInCommand.GOOGLE_LOGIN:
        if (!(_socialMediaLogin is GoogleController)) {
          _socialMediaLogin = GoogleController();
        }
        _signInSocialMedia();
        break;
      case LogInCommand.LOGOUT:
        _logOut();
        break;
    }
  }

  void _signInSocialMedia() async {
    _loginResult = await _socialMediaLogin.login();

    switch (_loginResult.status) {
      case LogInResultStatus.loggedIn:
        _userStream.add(_socialMediaLogin.user);
        _pageController.animateToPage(1,
            duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        _logInState.add(LogInProgress.LOGGED);
        break;
      case LogInResultStatus.cancelledByUser:
        _logInState.add(LogInProgress.LOGIN_ERROR);
        break;
      case LogInResultStatus.error:
        print("Login Error: ${_loginResult.errorMessage}");
        _logInState.add(LogInProgress.LOGIN_ERROR);
        break;
    }


  }

//  void _processLogInData() async {
//        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${_loginResult.session.token}');
//    var profile = json.decode(graphResponse.body);
//    print(profile.toString());
//    _logInState.add(LogInProgress.LOGGED);
//    _logInState.add(LogInProgress.WAITING);
//    var graphResponse = await http.get(
//  }

  void _logOut() {
    _socialMediaLogin?.logOut();
    _userStream.add(null);
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    _logInState.add(LogInProgress.NOT_LOGGED);
  }
}

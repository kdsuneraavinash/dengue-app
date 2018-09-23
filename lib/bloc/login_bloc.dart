import 'dart:async';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dengue_app/bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:rxdart/subjects.dart';

class LoginBLoC extends BLoC {
  // Streams and Sinks
  final BehaviorSubject<FacebookLoginResult> _loginResultStream =
      BehaviorSubject(seedValue: null);
  final BehaviorSubject<bool> _isLoggingIn = BehaviorSubject(seedValue: false);
  final BehaviorSubject<PageController> _pageControllerData = BehaviorSubject();
  final StreamController<bool> _logInToFacebook = StreamController();
  Stream<FacebookLoginResult> get loginResult => _loginResultStream.stream;
  Stream<bool> get isLoggingIn => _isLoggingIn.stream;
  Stream<PageController> get pageControllerData => _pageControllerData.stream;
  Sink<bool> get logInToFacebook => _logInToFacebook.sink;

  // Instance Variables
  PageController _pageController = PageController(initialPage: 0);
  FacebookLoginResult _loginResult;

  LoginBLoC() {
    _pageControllerData.add(_pageController);
    _logInToFacebook.stream.listen(_signInFacebook);
  }

  @override
  void dispose() {
    _loginResultStream.close();
    _isLoggingIn.close();
    _pageControllerData.close();
    _logInToFacebook.close();
  }

  void _signInFacebook(bool _) async {
    FacebookLogin facebookLogin = FacebookLogin();
    _isLoggingIn.add(true);
    _loginResult = await facebookLogin.logInWithReadPermissions(['email']);
    _isLoggingIn.add(false);

    switch (_loginResult.status) {
      case FacebookLoginStatus.loggedIn:
        _processLogInData();
        _pageController.animateToPage(1,
            duration: Duration(milliseconds: 200), curve: Curves.easeIn);

        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("Error: ${_loginResult.errorMessage}");
        break;
    }
  }

  void _processLogInData() async {
    _isLoggingIn.add(true);
    var graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${_loginResult.accessToken.token}');
    var profile = json.decode(graphResponse.body);
    print(profile.toString());
    _isLoggingIn.add(false);
  }
}

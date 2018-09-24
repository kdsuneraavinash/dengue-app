import 'dart:async';

import 'package:dengue_app/bloc/bloc.dart';
import 'package:dengue_app/logic/socialmedia/controller.dart';
import 'package:dengue_app/logic/socialmedia/google.dart';
import 'package:dengue_app/logic/socialmedia/loginresult.dart';
import 'package:dengue_app/logic/user.dart';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

enum LogInProgress { NOT_LOGGED, WAITING, LOGGED, LOGIN_ERROR }
enum LogInCommand { GOOGLE_LOGIN, LOGOUT }

class LoginBLoC extends BLoC {
  /// Stream which sends the last logged in [User].
  /// null if no one is logged in.
  final BehaviorSubject<User> _userStream = BehaviorSubject();

  /// [LogInProgress] updater.
  /// Changes when login state changes.
  final BehaviorSubject<LogInProgress> _logInState = BehaviorSubject();

  /// Issues the command to change Tab Page.
  final BehaviorSubject<int> _changeTabPage = BehaviorSubject();

  /// Issues the command to navigate to home page.
  /// Sends boolean to be used by [HomePage].
  /// null if no need to change page.
  /// *Remember to set to false after logging out.*
  final BehaviorSubject<bool> _navigateToHomePage =
      BehaviorSubject(seedValue: false);

  /// Listens for commands to Social Media Controller such as Login, Logout.
  final StreamController<LogInCommand> _issueSocialMediaCommand =
      StreamController();

  /// Further details Text Change Methods
  final StreamController<String> _changeFullName = StreamController();
  final StreamController<String> _changeAddress = StreamController();
  final StreamController<String> _changeTelephone = StreamController();

  /// Further details Text Submit Methods
  final StreamController<BuildContext> _submit = StreamController();

  /// Defining Outputs from stream
  /// Stream ------------> Widgets
  Stream<User> get userStream => _userStream.stream;
  Stream<LogInProgress> get logInState => _logInState.stream;
  Stream<int> get goToTabPage => _changeTabPage.stream;
  Stream<bool> get navigateToHomePage =>
      _navigateToHomePage.stream;

  /// Defining Outputs to stream
  /// Stream <------------ Widgets
  Sink<LogInCommand> get issueSocialMediaCommand =>
      _issueSocialMediaCommand.sink;
  Sink<String> get changeFullName => _changeFullName.sink;
  Sink<String> get changeAddress => _changeAddress.sink;
  Sink<String> get changeTelephone => _changeTelephone.sink;
  Sink<BuildContext> get submit => _submit.sink;

  /// Social Media Controller
  final SocialMediaController _socialMediaLogin = GoogleController();

  /// Further Detail Strings
  String _fullName;
  String _address;
  String _telephone;

  LoginBLoC() {
    streamConnect(); // Connect all Streams
    _emptyTexts(); // Empty all Texts
  }

  @override
  void streamConnect() async {
    /// Associates handlers to inputs to stream
    _issueSocialMediaCommand.stream.listen(_handleSocialMediaCommand);
    _changeFullName.stream.listen(_handleFullNameChanged);
    _changeAddress.stream.listen(_handleAddressChanged);
    _changeTelephone.stream.listen(_handleTelephoneChanged);
    _submit.stream.listen(_handleSubmitPressed);

    /// Try to login if already logged in
    _initLogin();
  }

  @override
  void dispose() {
    _userStream.close();
    _logInState.close();
    _issueSocialMediaCommand.close();
    _changeFullName.close();
    _changeAddress.close();
    _changeTelephone.close();
    _submit.close();
    _changeTabPage.close();
    _navigateToHomePage.close();
  }

  /// Check for command and logs in or logs out
  void _handleSocialMediaCommand(LogInCommand command) {
    _logInState.add(LogInProgress.WAITING);
    switch (command) {
      case LogInCommand.GOOGLE_LOGIN:
        _signInSocialMedia();
        break;
      case LogInCommand.LOGOUT:
        _logOut();
        break;
    }
  }

  /// Sign in command
  void _signInSocialMedia() async {
    LogInResult _loginResult = await _socialMediaLogin.login();

    switch (_loginResult.status) {
      case LogInResultStatus.loggedIn:
        _userStream.add(_socialMediaLogin.user);
        _changeTabPage.add(1);
        _changeTabPage.add(null);
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

  /// Logout command
  void _logOut() {
    _socialMediaLogin.logOut();

    // defaults to output values
    _userStream.add(null);
    _changeTabPage.add(0);
    _navigateToHomePage.add(false);
    _logInState.add(LogInProgress.NOT_LOGGED);

    // defaults rto instance variables
    _emptyTexts();
  }

  /// Texts Submitted Handler
  void _handleSubmitPressed(BuildContext context) {
    _fullName = _fullName.trim();
    _address = _address.trim();
    _telephone = _telephone.trim();
//    bool fullNameValid = _fullName.length != 0;
//    bool addressValid = _address.length != 0;
//    bool telephoneValid = _telephone.length != 0;
//    print("Submit: $_fullName $_address $_telephone");

//    if (fullNameValid && addressValid && telephoneValid) {
    _socialMediaLogin.user.setFurtherDetails(
      address: _address,
      telephone: _telephone,
      fullName: _fullName,
    );
    _navigateToHomePage.add(true);
    _navigateToHomePage.add(false);
//    }
  }

  /// Text Changed Handlers
  void _handleFullNameChanged(s) => _fullName = s;
  void _handleAddressChanged(s) => _address = s;
  void _handleTelephoneChanged(s) => _telephone = s;

  /// Empty texts
  void _emptyTexts() {
    _fullName = "";
    _address = "";
    _telephone = "";
  }

  /// Login if already logged in
  void _initLogin() async {
    if (await _socialMediaLogin.isLoggedIn()) {
      await _socialMediaLogin.login().then((b) {
        if (b.status == LogInResultStatus.loggedIn) {
          _userStream.add(_socialMediaLogin.user);
          _logInState.add(LogInProgress.LOGGED);
          _navigateToHomePage.add(true);
          _navigateToHomePage.add(false);
        }
      });
    }
  }
}

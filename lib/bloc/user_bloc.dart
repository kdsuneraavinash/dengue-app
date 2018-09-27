import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dengue_app/bloc/bloc.dart';
import 'package:dengue_app/bloc/login_bloc.dart';
import 'package:dengue_app/logic/firebase/auth.dart';
import 'package:dengue_app/logic/firebase/loginresult.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:rxdart/rxdart.dart';

enum LogInCommand { LOGIN, LOGOUT }

class UserBLoC extends BLoC {
  /// Stream which sends the last logged in [User].
  /// null if no one is logged in.
  final BehaviorSubject<User> _userStream = BehaviorSubject();

  /// [LogInState] updater.
  /// Changes when login state changes.
  final BehaviorSubject<LogInState> _logInState = BehaviorSubject();

  /// Listens for commands to Social Media Controller such as Login, Logout.
  final StreamController<LogInCommand> _firestoreAuthCommand =
      StreamController();

  final StreamController<Map<String, dynamic>> _signUpFinished = StreamController();

  /// Defining Outputs from stream
  /// Stream ------------> Widgets
  Stream<LogInState> get logInState => _logInState.stream;
  Stream<User> get userStream => _userStream.stream;
  Stream<QuerySnapshot> get leaderBoard => firestoreAuthController.leaderBoard;

  /// Defining Outputs to stream
  /// Stream <------------ Widgets
  Sink<LogInCommand> get firestoreAuthCommand => _firestoreAuthCommand.sink;
  Sink<Map<String, dynamic>> get signUpFinished => _signUpFinished.sink;

  /// Firestore Controller
  final FirebaseAuthController firestoreAuthController = FirebaseAuthController();

  @override
  void dispose() {
    _signUpFinished.close();
    _userStream.close();
    _firestoreAuthCommand.close();
  }

  @override
  void streamConnect() {
    _firestoreAuthCommand.stream.listen(_handleSocialMediaCommand);
    _signUpFinished.stream.listen(_handleSignUpFinished);
    firestoreAuthController.userChanges.listen(_usersChanged);
    loginIfAlreadyLoggedIn();
  }

  void _usersChanged(QuerySnapshot query) {
    if (query?.documentChanges != null) {
      for (DocumentChange change in query.documentChanges) {
        if (change.document.documentID == firestoreAuthController.user.id) {
          firestoreAuthController.user.setUser(
              address: change.document.data['address'],
              fullName: change.document.data['fullName'],
              telephone: change.document.data['telephone']);
          firestoreAuthController.user.points = change.document.data['points'];
          _userStream.add(firestoreAuthController.user);
        }
      }
    }
  }

  /// Check for command and logs in or logs out
  void _handleSocialMediaCommand(LogInCommand command) {
    _logInState.add(LogInState.WAITING);
    switch (command) {
      case LogInCommand.LOGIN:
        login();
        break;
      case LogInCommand.LOGOUT:
        logout();
        break;
    }
  }

  void _handleSignUpFinished(Map<String, dynamic> data) {
    print(data);
    if (data != null) {
      firestoreAuthController.setFurtherData(data);
      _logInState.add(LogInState.LOGGED);
    }
  }

  void login() async {
    LogInResult _loginResult = await firestoreAuthController.login();

    switch (_loginResult.status) {
      case LogInResultStatus.loggedIn:
        _userStream.add(firestoreAuthController.user);
        _logInState.add(LogInState.LOGGED);
        break;
      case LogInResultStatus.signedUp:
        _userStream.add(firestoreAuthController.user);
        _logInState.add(LogInState.SIGNED_UP);
        break;
      case LogInResultStatus.cancelledByUser:
      case LogInResultStatus.error:
        _logInState.add(LogInState.NOT_LOGGED);
        break;
    }
  }

  void logout() {
    firestoreAuthController.logOut();
    // defaults to output values
    _userStream.add(null);
    _logInState.add(LogInState.NOT_LOGGED);
  }

  /// Login if already logged in
  void loginIfAlreadyLoggedIn() async {
    if (await firestoreAuthController.isLoggedIn()) {
      _logInState.add(LogInState.WAITING);
      await firestoreAuthController.login().then((b) {
        if (b.status == LogInResultStatus.loggedIn) {
          _userStream.add(firestoreAuthController.user);
          _logInState.add(LogInState.LOGGED);
        } else {
          _logInState.add(LogInState.NOT_LOGGED);
        }
      });
    }
  }

  UserBLoC() : super();
}

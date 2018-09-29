import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dengue_app/bloc/bloc.dart';
import 'package:dengue_app/bloc/login_bloc.dart';
import 'package:dengue_app/logic/firebase/auth.dart';
import 'package:dengue_app/logic/firebase/firestore.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

enum LogInCommand { GOOGLE_LOGIN, FACEBOOK_LOGIN, LOGOUT }

class UserBLoC extends BLoC {
  /// Stream which sends the last logged in [User].
  /// null if no one is logged in.
  final BehaviorSubject<User> _userStream = BehaviorSubject();

  /// [LogInState] updater.
  /// Changes when login state changes.
  final BehaviorSubject<LogInState> _logInStateStream = BehaviorSubject();

  /// Listens for commands to Social Media Controller such as Login, Logout.
  final StreamController<LogInCommand> _firestoreAuthCommandStreamController =
      StreamController();

  final StreamController<Map<String, dynamic>> _signUpFinishedStreamController =
      StreamController();

  /// Defining Outputs from stream
  /// Stream ------------> Widgets
  Stream<LogInState> get logInStateStream => _logInStateStream.stream;
  Stream<User> get userStream => _userStream.stream;
  Stream<QuerySnapshot> get leaderBoardStream =>
      _firestoreAuthController.leaderBoard;

  /// Defining Outputs to stream
  /// Stream <------------ Widgets
  Sink<LogInCommand> get firestoreAuthCommandSink =>
      _firestoreAuthCommandStreamController.sink;
  Sink<Map<String, dynamic>> get signUpFinishedSink =>
      _signUpFinishedStreamController.sink;

  /// Firestore Controller
  final FirebaseAuthController _firestoreAuthController =
      FirebaseAuthController();
  User _loggedInUser;

  @override
  void dispose() {
    _signUpFinishedStreamController.close();
    _userStream.close();
    _firestoreAuthCommandStreamController.close();
  }

  @override
  void streamConnect() {
    _firestoreAuthCommandStreamController.stream
        .listen(_handleSocialMediaCommand);
    _signUpFinishedStreamController.stream.listen(_handleSignUpFinished);
    _userStream.stream.listen(_handleUserAddedToStream);
    loginIfAlreadyLoggedIn();
  }

  void _usersChanged(DocumentSnapshot doc) {
    if (doc.data != null) {
      User user = User.fromMap(_loggedInUser.id, doc.data);
      _userStream.add(user);
    }
  }

  /// Check for command and logs in or logs out
  void _handleSocialMediaCommand(LogInCommand command) {
    _logInStateStream.add(LogInState.WAITING);
    switch (command) {
      case LogInCommand.GOOGLE_LOGIN:
        login(LoginMethod.GOOGLE);
        break;
      case LogInCommand.FACEBOOK_LOGIN:
        login(LoginMethod.FACEBOOK);
        break;
      case LogInCommand.LOGOUT:
        logout();
        break;
    }
  }

  void _handleSignUpFinished(Map<String, dynamic> data) {
    if (data != null) {
      _firestoreAuthController.setFurtherData(_loggedInUser, data);
    }
  }

  void login(LoginMethod method) async {
    FirebaseUser firebaseUser =
        await _firestoreAuthController.signInFromSocialMedia(method);
    if (firebaseUser == null) {
      // Login skipped
      _logInStateStream.add(LogInState.NOT_LOGGED);
    } else {
      User userAsInDatabase =
          await _firestoreAuthController.getUserDataFromFirestore(firebaseUser);
      if (userAsInDatabase == null) {
        // First Login
        User newUser = User.fromFirebaseUser(firebaseUser);
        _userStream.add(newUser);
        _logInStateStream.add(LogInState.SIGNED_UP);
      } else {
        // Re login
        _userStream.add(userAsInDatabase);
        _logInStateStream.add(LogInState.LOGGED);
      }
    }
  }

  void logout() {
    _firestoreAuthController.logOut();
    // defaults to output values
    _userStream.add(null);
    _logInStateStream.add(LogInState.NOT_LOGGED);
  }

  /// Login if already logged in
  void loginIfAlreadyLoggedIn() async {
    FirebaseUser currentUser =
        await _firestoreAuthController.currentFirebaseUser;
    if (currentUser != null) {
      _logInStateStream.add(LogInState.WAITING);
      User user =
          await _firestoreAuthController.getUserDataFromFirestore(currentUser);
      if (user != null) {
        _userStream.add(user);
        _logInStateStream.add(LogInState.LOGGED);
        return;
      }
    }
    _logInStateStream.add(LogInState.NOT_LOGGED);
  }

  void _handleUserAddedToStream(User user) {
    if (user != null) {
      if (_loggedInUser == null && !user.equals(_loggedInUser)) {
        FireStoreController.userDocuments
            .document(user.id)
            .snapshots()
            .listen(_usersChanged);
      }
    }
    _loggedInUser = user;
  }

  UserBLoC() : super();
}

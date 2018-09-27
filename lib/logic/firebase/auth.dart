import 'dart:async';

import 'package:dengue_app/logic/firebase/firestore.dart';
import 'package:dengue_app/logic/firebase/loginresult.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseUser;
import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, QuerySnapshot;

class FirebaseAuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User _user = User();

  Stream<QuerySnapshot> get userChanges =>
      FireStoreController.userDocuments.snapshots();

  Stream<QuerySnapshot> get leaderBoard => FireStoreController.userDocuments
      .orderBy("points", descending: true)
      .limit(100)
      .snapshots();

  Future<FirebaseUser> _googleLogIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return user;
  }

  Future<LogInResult> login() async {
    try {
      FirebaseUser _fbUser = await _googleLogIn();

      if (_fbUser != null) {
        _user = User()
          ..setUser(
              displayName: _fbUser.displayName,
              email: _fbUser.email,
              id: _fbUser.uid,
              photoUrl: _fbUser.photoUrl,
              telephone: _fbUser.phoneNumber ?? "",
              fullName: _fbUser.displayName,
              address: "");
        bool isAlreadyPresent = await getFurtherData();
        if (!isAlreadyPresent) {
          // Fresh Sign Up
          setFurtherData({});
          return LogInResult(LogInResultStatus.signedUp, null,
              Session(_fbUser?.uid, _fbUser?.email));
        } else {
          return LogInResult(LogInResultStatus.loggedIn, null,
              Session(_fbUser?.uid, _fbUser?.email));
        }
      } else {
        return LogInResult(LogInResultStatus.error, null, null);
      }
    } catch (error) {
      return LogInResult(LogInResultStatus.error, error.toString(), null);
    }
  }

  void logOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _user = null;
  }

  Future<bool> isLoggedIn() async {
    return (await _googleSignIn.isSignedIn()) &&
        (await _auth.currentUser() != null);
  }

  void setFurtherData(Map<String, dynamic> data) async {
    Map<String, dynamic> userData = {
      'displayName': _user.displayName,
      'email': _user.email,
      'photoUrl': _user.photoUrl,
      'fullName': _user.fullName,
      'address': _user.address,
      'telephone': _user.telephone,
      'points': _user.points,
    };
    userData.addAll(data);

    if (user != null) {
      await FireStoreController.changeUserDocument(
          userId: user.id, data: userData);
    }
  }

  Future<bool> getFurtherData() async {
    DocumentSnapshot snapshot =
        await FireStoreController.getUserDocumentOf(user.id);
    if (snapshot?.data == null) {
      return false;
    } else {
      Map<String, dynamic> map = snapshot?.data;
      user.setUser(
        displayName: map['displayName'] ?? _user.displayName,
        email: map['email'] ?? _user.email,
        photoUrl: map['photoUrl'] ?? _user.photoUrl,
        telephone: map['telephone'] ?? _user.telephone,
        fullName: map['fullName'] ?? _user.fullName,
        address: map['address'] ?? _user.address,
      );
      user.points = map['points'];
      return true;
    }
  }

  User get user => _user;
}

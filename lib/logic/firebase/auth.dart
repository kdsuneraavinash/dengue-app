import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dengue_app/logic/firebase/firestore.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum LoginMethod { GOOGLE, FACEBOOK }

class FirebaseAuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _nativeGoogleSignIn = GoogleSignIn();
  final FacebookLogin _nativeFacebookSignIn = FacebookLogin();

  Stream<QuerySnapshot> get leaderBoard => FireStoreController.userDocuments
      .orderBy("points", descending: true)
      .limit(100)
      .snapshots();

  Future<FirebaseUser> _googleLogIn() async {
    GoogleSignInAccount googleUser;
    googleUser = await _nativeGoogleSignIn.signIn();

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return user;
  }

  Future<FirebaseUser> _facebookLogIn() async {
    FacebookLoginResult facebookUser = await _nativeFacebookSignIn
        .logInWithReadPermissions(['email', 'public_profile']);

    if (facebookUser.status == FacebookLoginStatus.loggedIn) {
      FirebaseUser user = await _auth.signInWithFacebook(
        accessToken: facebookUser.accessToken.token,
      );
      return user;
    } else if (facebookUser.status == FacebookLoginStatus.cancelledByUser) {
      return null;
    } else {
      throw Exception(facebookUser.errorMessage);
    }
  }

  /// Sign in using the social media specified
  Future<FirebaseUser> signInFromSocialMedia(LoginMethod method) async {
    FirebaseUser firebaseUser;
    switch (method) {
      case LoginMethod.GOOGLE:
        firebaseUser = await _googleLogIn();
        break;
      case LoginMethod.FACEBOOK:
        firebaseUser = await _facebookLogIn();
        break;
    }
    return firebaseUser;
  }

  /// Gets user data from firestore database.
  /// Requires a [FirebaseUser].
  Future<User> getUserDataFromFirestore(FirebaseUser firebaseUser) async {
    DocumentSnapshot snapshot;
    snapshot = await FireStoreController.getUserDocumentOf(firebaseUser.uid);
    if (snapshot?.data != null) {
      User user = User.fromMap(firebaseUser.uid, snapshot.data);
      return user;
    } else {
      return null;
    }
  }

  void logOut() async {
    await _auth.signOut();
    try {
      await _nativeGoogleSignIn.signOut();
      await _nativeFacebookSignIn.logOut();
    } catch (ignored) {}
  }

  Future<FirebaseUser> get currentFirebaseUser async =>
      await _auth.currentUser();

  void setFurtherData(User user, Map<String, dynamic> data) async {
    if (user != null) {
      Map<String, dynamic> userData = user.toMap();
      userData.addAll(data);
      await FireStoreController.changeUserDocument(
          userId: user.id, data: userData);
    }
  }
}

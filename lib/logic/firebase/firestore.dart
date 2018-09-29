import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreController {
  static CollectionReference userDocuments =
      Firestore.instance.collection('users');
  static CollectionReference postDocuments =
      Firestore.instance.collection('posts');
  static CollectionReference prizesDocuments =
  Firestore.instance.collection('prizes');

  static Future<void> changeUserDocument(
      {String userId, Map<String, dynamic> data}) async {
    if (userId == null || data == null) {
      return;
    }
    userDocuments.document(userId).setData(data);
  }

  static Future<DocumentSnapshot> getUserDocumentOf(String userId) async {
    return userDocuments.document(userId).get();
  }

  static Future<void> addPostDocument({Map<String, dynamic> data}) async {
    if (data != null) {
      postDocuments.add(data);
    }
  }
}

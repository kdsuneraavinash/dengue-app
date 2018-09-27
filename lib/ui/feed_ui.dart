import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dengue_app/logic/firebase/firestore.dart';
import 'package:dengue_app/logic/post.dart';
import 'package:dengue_app/ui/postcard.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FireStoreController.postDocuments
          .orderBy("datePosted", descending: true)
          .limit(100)
          .snapshots(),
      builder: (_, snapshot) => snapshot.hasData
          ? ListView(
              children: snapshot.data.documents.map(_buildPostView).toList(),
            )
          : CircularProgressIndicator(),
    );
  }
}

Widget _buildPostView(DocumentSnapshot doc) {
  return PostCard(
    post: Post.fromMap(doc.data),
  );
}

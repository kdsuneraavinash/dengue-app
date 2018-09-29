import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dengue_app/bloc/bloc.dart';
import 'package:dengue_app/logic/firebase/firestore.dart';
import 'package:dengue_app/logic/post.dart';
import 'package:rxdart/rxdart.dart';

class FeedBLoC extends BLoC {
  BehaviorSubject<List<ProcessedPost>> _postsFeed = BehaviorSubject();
  PublishSubject<bool> _refreshAvailable = PublishSubject();
  PublishSubject<bool> _refreshFinished = PublishSubject();

  StreamController<Null> _refreshCommandIssued = StreamController();

  Stream<List<ProcessedPost>> get postsFeed => _postsFeed.stream;

  Stream<bool> get refreshAvailable => _refreshAvailable.stream;

  Stream<bool> get refreshFinished => _refreshFinished.stream;

  Sink<Null> get refreshCommandIssued => _refreshCommandIssued;

  Stream<QuerySnapshot> feedQuery = FireStoreController.postDocuments
      .orderBy("datePosted", descending: true)
      .limit(100)
      .snapshots();
  QuerySnapshot lastQuerySnapshot;

  @override
  void dispose() {
    _postsFeed.close();
    _refreshAvailable.close();
    _refreshCommandIssued.close();
    _refreshFinished.close();
  }

  @override
  void streamConnect() {
    _refreshCommandIssued.stream.listen((_) => _handleRefreshed());
    feedQuery.listen(_handleUpdateBecameAvailable);
  }

  void _handleUpdateBecameAvailable(QuerySnapshot data) {
    if (lastQuerySnapshot == null) {
      _refreshCommandIssued.add(null);
      lastQuerySnapshot = data;
    } else {
      lastQuerySnapshot = data;
      _refreshAvailable.add(true);
    }
  }

  void _handleRefreshed() async {
    List<ProcessedPost> result = List();
    for (DocumentSnapshot doc in lastQuerySnapshot.documents) {
      result.add(await ProcessedPost.processedPostFromDoc(doc));
      _postsFeed.add(result);
    }
    _refreshFinished.add(true);
  }
}

class ProcessedPost {
  final Post post;
  final String username;
  final String displayImage;

  ProcessedPost(this.post, this.username, this.displayImage);

  static Future<ProcessedPost> processedPostFromDoc(
      DocumentSnapshot doc) async {
    Post post = Post.fromMap(doc.data);
    DocumentSnapshot userDocSnap =
        await FireStoreController.getUserDocumentOf(post.user);
    String username = userDocSnap.data["displayName"];
    String displayImage = userDocSnap.data["photoUrl"];
    return ProcessedPost(post, username, displayImage);
  }
}

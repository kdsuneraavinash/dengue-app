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

  void _handleUpdateBecameAvailable(QuerySnapshot data) async {
    if (lastQuerySnapshot == null) {
      lastQuerySnapshot = data;
      _handleFirstRefreshed();
    } else {
      lastQuerySnapshot = data;
      _refreshAvailable.add(true);
    }
  }

  void _handleRefreshed() async {
    List<DocumentSnapshot> docs = lastQuerySnapshot.documents;
    List<ProcessedPost> result = List();
    for (DocumentSnapshot doc in docs) {
      result.add(await ProcessedPost.processedPostFromDoc(doc.data));
    }
    _postsFeed.add(result);
    _refreshFinished.add(true);
  }

  void _handleFirstRefreshed() async {
    List<Map<String, dynamic>> allData =
        lastQuerySnapshot.documents.map((c) => c.data).toList();
    List<ProcessedPost> result = List();
    _refreshFinished.add(true);
    for (Map<String, dynamic> data in allData) {
      result.add(await ProcessedPost.processedPostFromDoc(data));
      _postsFeed.add(result);
    }
  }
}

class ProcessedPost {
  final Post post;
  final String username;
  final String displayImage;

  ProcessedPost(this.post, this.username, this.displayImage);

  static Future<ProcessedPost> processedPostFromDoc(
      Map<String, dynamic> data) async {
    Post post = Post.fromMap(data);
    DocumentSnapshot userDocSnap =
        await FireStoreController.getUserDocumentOf(post.user);
    String username = userDocSnap?.data["displayName"];
    String displayImage = userDocSnap?.data["photoUrl"];
    return ProcessedPost(post, username, displayImage);
  }
}

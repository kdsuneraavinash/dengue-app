import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dengue_app/bloc/user_bloc.dart';
import 'package:dengue_app/logic/firebase/firestore.dart';
import 'package:dengue_app/logic/post.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/providers/user_provider.dart';
import 'package:dengue_app/ui/postcard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyPostsPage extends StatefulWidget {
  @override
  MyPostsPageState createState() {
    return new MyPostsPageState();
  }
}

class MyPostsPageState extends State<MyPostsPage> {
  UserBLoC userBLoC;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userBLoC = UserBLoCProvider.of(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Posts"),
      ),
      body: StreamBuilder<User>(
        stream: userBLoC.userStream,
        builder: (_, snapshotUser) => StreamBuilder<QuerySnapshot>(
              stream: FireStoreController.postDocuments
                  .where("user", isEqualTo: snapshotUser.data?.id ?? "")
                  .snapshots(),
              builder: (_, snapshot) => snapshot.hasData
                  ? ListView(
                      children:
                          snapshot.data.documents.map(_buildPostView).toList(),
                    )
                  : CircularProgressIndicator(),
            ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FlatButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
              label: Text("Back"),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(FontAwesomeIcons.backward),
      ),
    );
  }
}

Widget _buildPostView(DocumentSnapshot doc) {
  return PostCard(
    post: Post.fromMap(doc.data),
  );
}

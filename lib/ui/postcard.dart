import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:dengue_app/logic/firebase/firestore.dart';
import 'package:dengue_app/logic/post.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';

class PostCard extends StatelessWidget {
  PostCard({@required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular((8.0)))),
      child: Column(
        children: <Widget>[
          _buildTitleStrip(context),
          _buildCaptionText(),
          GestureDetector(
            child: _buildImageBanner(context),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  /// Builds CachedNetworkImage as Banner.
  Widget _buildImageBanner(BuildContext context) {
    return DefParameterNetworkImage(
      imageUrl: post.mediaLink ??
          "https://www.almanac.com/sites/default/files/styles/primary_image_in_article/public/image_nodes/dandelion-greens-weeds.jpg?itok=J1YWOB1u",
      isCover: true,
    );
  }

  /// Build Title and flagging controller
  Widget _buildTitleStrip(BuildContext context) {
    // Image.network("https://api.adorable.io/avatars/15/abott@adorable${post.user}.png")
    return StreamBuilder<DocumentSnapshot>(
      stream: FireStoreController.getUserDocumentOf(post.user).asStream(),
      builder: (_, snapshot) => snapshot.hasData
          ? ListTile(
              leading: DefParameterNetworkImage(
                isCover: false,
                imageUrl: snapshot.data?.data["photoUrl"],
                width: 40.0,
                height: 40.0,
              ),
              title: Text(snapshot.data?.data["displayName"]),
              subtitle: post.approved
                  ? Text("Rating : ${post.rating}")
                  : Text("Not approved yet."),
              trailing: post.approved
                  ? IconButton(
                      icon: Icon(FontAwesomeIcons.share),
                      onPressed: () {},
                    )
                  : null,
            )
          : ListTile(
              leading: GlowingProgressIndicator(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.userAlt,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.black,
                  height: 40.0,
                  width: 40.0,
                ),
                duration: Duration(milliseconds: 500),
              ),
              title: Container(),
              subtitle: Container(),
              trailing: null,
            ),
    );
  }

  final Post post;

  Widget _buildCaptionText() {
    return post.caption.length != 0? Container(
      alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 8.0),
        child:   Text(post.caption) ,
    ): Container();
  }
}

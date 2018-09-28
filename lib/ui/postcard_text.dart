
import 'package:dengue_app/custom_widgets/icontext.dart';
import 'package:dengue_app/ui/postcard_abstract.dart';
import 'package:flutter/material.dart';

class PostTextCard extends PostCardAbstract {
  PostTextCard({@required processedPost}) : super(processedPost: processedPost);

  final List colors = [
    Colors.blueGrey[800],
    Colors.deepPurple[800],
    Colors.pink[800],
    Colors.teal[800],
    Colors.black,
    Colors.green[800],
    Colors.red[800],
  ];

  /// Builds CachedNetworkImage as Banner.
  @override
  Widget buildImageBanner(BuildContext context) {
    Color color = colors[
        processedPost.post.datePosted.millisecondsSinceEpoch % colors.length];
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Text(
        processedPost.post.caption,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 32.0,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.0),
      ),
      color: color,
      width: width,
      padding: EdgeInsets.all(16.0),
    );
  }

  @override
  Widget buildCaptionText() {
    return Container();
  }

  @override
  Widget buildRatingStrip(BuildContext context, String text) {
    return IconText(
      icon: Icons.textsms,
      text: "Text Post",
      mainAxisAlignment: MainAxisAlignment.center,
      color: Colors.blueGrey,
    );
  }

  @override
  void handlePostTapped(BuildContext context) {}
}

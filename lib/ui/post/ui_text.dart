import 'package:dengue_app/custom_widgets/icontext.dart';
import 'package:dengue_app/ui/post/abs_post.dart';
import 'package:flutter/material.dart';

class TextPost extends AbstractPost {
  TextPost({Key key, @required processedPost})
      : super(key: key, processedPost: processedPost);

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
  Widget buildPostMedia(BuildContext context) {
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
  Widget buildBottomStrip() {
    return IconText(
      icon: Icons.sms,
      text: "Text Post",
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  @override
  void handlePostTapped(BuildContext context) {}
}

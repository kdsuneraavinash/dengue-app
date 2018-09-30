import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:dengue_app/ui/post/abs_post.dart';
import 'package:flutter/material.dart';

abstract class MediaPost extends AbstractPost {
  MediaPost({Key key, @required processedPost})
      : super(key: key, processedPost: processedPost);

  @override
  Widget buildCaptionText() {
    if (processedPost.post.caption.length == 0) {
      return Container();
    } else {
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(processedPost.post.caption),
      );
    }
  }

  @override
  Widget buildPostMedia(BuildContext context) {
    return DefParameterNetworkImage(
      imageUrl: processedPost.post.mediaLink,
      isCover: true,
      needProgress: false,
    );
  }
}

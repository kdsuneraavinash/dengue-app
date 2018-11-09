import 'package:dengue_app/custom_widgets/transition_maker.dart';
import 'package:dengue_app/ui/image_view_ui.dart';
import 'package:dengue_app/ui/post/abs_media.dart';
import 'package:flutter/material.dart';

class ImagePost extends MediaPost {
  ImagePost({Key key, @required processedPost})
      : super(key: key, processedPost: processedPost);

  @override
  Widget buildBottomStrip() {
    return Container();
  }

  @override
  void handlePostTapped(BuildContext context) {
    TransitionMaker.fadeTransition(
      destinationPageCall: () => ImageView(
        processedPost.post.mediaLink,
        MediaType.Image,
      ),
    )..start(context);
  }
}

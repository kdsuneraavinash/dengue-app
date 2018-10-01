import 'package:dengue_app/custom_widgets/icontext.dart';
import 'package:dengue_app/custom_widgets/transition_maker.dart';
import 'package:dengue_app/ui/image_view_ui.dart';
import 'package:dengue_app/ui/post/abs_media.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideoPost extends MediaPost {
  VideoPost({Key key, @required processedPost})
      : super(key: key, processedPost: processedPost);

  Widget buildPostMedia(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        super.buildPostMedia(context),
        Center(
          child: Icon(
            Icons.play_circle_filled,
            color: Color(0x99ffffff),
            size: width / 4,
          ),
        ),
      ],
    );
  }

  @override
  Widget buildBottomStrip() {
    return processedPost.post.approved
        ? IconText(
            icon: Icons.verified_user,
            text: "Rating : ${'★' * processedPost.post.rating}",
            mainAxisAlignment: MainAxisAlignment.center,
          )
        : IconText(
            icon: FontAwesomeIcons.clock,
            text: "Approval Pending",
            mainAxisAlignment: MainAxisAlignment.center,
            color: Colors.red[900],
          );
  }

  @override
  void handlePostTapped(BuildContext context) {
    TransitionMaker.fadeTransition(
      destinationPageCall: () => ImageView(
            processedPost.post.videoLink,
            MediaType.Video,
          ),
    )..start(context);
  }
}

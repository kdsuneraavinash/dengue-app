import 'package:dengue_app/bloc/feed_bloc.dart';
import 'package:dengue_app/custom_widgets/icontext.dart';
import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:dengue_app/custom_widgets/transition_maker.dart';
import 'package:dengue_app/ui/image_view_ui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';

abstract class PostCardAbstract extends StatelessWidget {
  final ProcessedPost processedPost;

  PostCardAbstract({Key key, @required this.processedPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key(processedPost.post.datePosted.toIso8601String() +
          processedPost.post.user),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular((8.0)))),
      child: Column(
        children: <Widget>[
          _buildTitleStrip(context),
          buildCaptionText(),
          GestureDetector(
            child: buildImageBanner(context),
            onTap: () => handlePostTapped(context),
          ),
          buildRatingStrip(context, ""),
        ],
      ),
    );
  }

  /// Builds CachedNetworkImage as Banner.
  Widget buildImageBanner(BuildContext context) {
    return DefParameterNetworkImage(
      imageUrl: processedPost.post.mediaLink ??
          "https://www.almanac.com/sites/default/files/styles/primary_image_in_article/public/image_nodes/dandelion-greens-weeds.jpg?itok=J1YWOB1u",
      isCover: true,
      needProgress: false,
    );
  }

  /// Build Title and flagging controller
  Widget _buildTitleStrip(BuildContext context) {
    // Image.network("https://api.adorable.io/avatars/15/abott@adorable${post.user}.png")
    return processedPost != null
        ? ListTile(
            leading: DefParameterNetworkImage(
              needProgress: false,
              isCover: false,
              imageUrl: processedPost.displayImage,
              width: 40.0,
              height: 40.0,
            ),
            title: Text(processedPost.username),
            subtitle: Text(processedPost.post.formattedDatePosted),
            trailing: processedPost.post.approved
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
          );
  }

  Widget buildCaptionText() {
    return processedPost.post.caption.length != 0
        ? Container(
            alignment: Alignment.centerLeft,
            padding:
                EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 8.0),
            child: Text(processedPost.post.caption),
          )
        : Container();
  }

  /// Build Time Date Data
  Widget buildRatingStrip(BuildContext context, String text) {
    return processedPost.post.approved
        ? IconText(
            icon: Icons.verified_user,
            text: "Rating : ${'★' * processedPost.post.rating}",
            mainAxisAlignment: MainAxisAlignment.center,
            color: Colors.blue[900],
          )
        : IconText(
            icon: FontAwesomeIcons.clock,
            text: "Approval Pending",
            mainAxisAlignment: MainAxisAlignment.center,
            color: Colors.blue[500],
          );
  }

  void handlePostTapped(BuildContext context) {
    TransitionMaker.fadeTransition(
      destinationPageCall: () => ImageView(
            processedPost.post.videoLink,
            MediaType.Video,
            "",
          ),
    )..start(context);
  }
}

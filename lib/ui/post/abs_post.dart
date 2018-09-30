import 'package:dengue_app/bloc/feed_bloc.dart';
import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

abstract class AbstractPost extends StatelessWidget {
  final ProcessedPost processedPost;

  AbstractPost({Key key, @required this.processedPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: buildPostMedia(context),
            onTap: () => handlePostTapped(context),
          ),
          buildCaptionText(),
          _buildUserInfoStrip(context),
          buildBottomStrip(),
        ],
      ),
    );
  }

  /// Build Title and flagging controller
  Widget _buildUserInfoStrip(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: ClipOval(
          child: DefParameterNetworkImage(
            needProgress: false,
            isCover: true,
            imageUrl: processedPost.displayImage,
            width: 40.0,
            height: 40.0,
          ),
        ),
      ),
      title: Text(processedPost.username),
      subtitle: Text(processedPost.post.formattedDatePosted),
      trailing: processedPost.post.approved
          ? IconButton(
              icon: Icon(FontAwesomeIcons.share),
              onPressed: () {
                // TODO: Add Share button functionality
              },
            )
          : null,
    );
  }

  Widget buildPostMedia(BuildContext context);

  Widget buildCaptionText();

  Widget buildBottomStrip();

  void handlePostTapped(BuildContext context);
}

import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:dengue_app/logic/post.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostCard extends StatelessWidget {
  PostCard({@required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular((8.0)))),
      child: Column(
        children: <Widget>[
          _buildTitleStrip(),
          GestureDetector(
            child: _buildImageBanner(context),
            onTap: () => null,
          ),
          _buildCaptionText(),
        ],
      ),
    );
  }

  /// Builds CachedNetworkImage as Banner.
  Widget _buildImageBanner(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: DefParameterNetworkImage(
            imageUrl: post.beforeLink ?? "https://www.almanac.com/sites/default/files/styles/primary_image_in_article/public/image_nodes/dandelion-greens-weeds.jpg?itok=J1YWOB1u",
            isCover: true,
          ),
        ),
        Expanded(
          child: DefParameterNetworkImage(
            imageUrl: post.afterLink ?? "https://www.almanac.com/sites/default/files/styles/primary_image_in_article/public/image_nodes/dandelion-greens-weeds.jpg?itok=J1YWOB1u",
            isCover: true,
          ),
        ),
      ],
    );
  }

  /// Build Title and flagging controller
  Widget _buildTitleStrip() {
    // Image.network("https://api.adorable.io/avatars/15/abott@adorable${post.user}.png")
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(post.user),
      subtitle: Text("${post.likes} Likes | ${post.shares} shares"),
      trailing: IconButton(
        icon: Icon(FontAwesomeIcons.share),
        onPressed: () => null,
      ),
    );
  }

  final Post post;

  Widget _buildCaptionText() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(post.caption),
    );
  }
}

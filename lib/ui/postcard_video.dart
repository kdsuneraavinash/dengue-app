import 'package:dengue_app/ui/postcard_abstract.dart';
import 'package:flutter/material.dart';

class PostWeeklyCard extends PostCardAbstract {
  PostWeeklyCard({Key key, @required processedPost})
      : super(key: key, processedPost: processedPost);

  Widget buildImageBanner(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        super.buildImageBanner(context),
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
}


import 'package:dengue_app/custom_widgets/icontext.dart';
import 'package:dengue_app/ui/postcard_abstract.dart';
import 'package:flutter/material.dart';

class PostImageCard extends PostCardAbstract {
  PostImageCard({@required processedPost})
      : super(processedPost: processedPost);

  @override
  Widget buildRatingStrip(BuildContext context, String text) {
    return IconText(
      icon: Icons.image,
      text: "Image Post",
      mainAxisAlignment: MainAxisAlignment.center,
      color: Colors.black54,
    );
  }
}

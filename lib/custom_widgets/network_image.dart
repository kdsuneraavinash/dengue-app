import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Creates an Cached Network Image with default placeholder
/// Will have a fixed aspect ratio
class DefParameterNetworkImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: this.imageUrl,
      fit: isCover ? BoxFit.cover : BoxFit.contain,
      width: width ?? MediaQuery.of(context).size.width,
      height:
          isCover ? MediaQuery.of(context).size.width / aspectRatio : height,
      placeholder: SizedBox(
        width: width ?? MediaQuery.of(context).size.width,
        height:
        isCover ? MediaQuery.of(context).size.width / aspectRatio : height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  DefParameterNetworkImage(
      {this.imageUrl, this.isCover = false, this.width, this.height});

  final String imageUrl;
  final bool isCover;
  final double width;
  final double height;
  final aspectRatio = 16 / 9;
}

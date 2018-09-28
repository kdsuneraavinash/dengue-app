import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

import 'package:dengue_app/custom_widgets/zoomable_image.dart';
import 'package:video_player/video_player.dart';

enum MediaType { Video, Image }

/// Hosts PageView and buttons.
class ImageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(caption),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          (type == MediaType.Image) ? _buildImageBox() : _buildVideoBox(),
        ],
      ),
    );
  }

  /// Build Page View with Image
  Widget _buildImageBox() {
    return Center(
      child: ZoomableImage(this.media),
    );
  }

  /// Build Page View with Video
  Widget _buildVideoBox() {
    return Center(
      child: Chewie(
        VideoPlayerController.network(media),
        autoPlay: false,
        placeholder: Icon(Icons.play_circle_filled),
        autoInitialize: true,
      ),
    );
  }

  ImageView(this.media, this.type, this.caption);

  final String caption;
  final String media;
  final MediaType type;
}

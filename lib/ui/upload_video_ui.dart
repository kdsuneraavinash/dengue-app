import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:dengue_app/logic/firebase/firestore.dart';
import 'package:dengue_app/logic/post.dart';
import 'package:dengue_app/main.dart';
import 'package:dengue_app/ui/upload_abstract_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class UploadWeekly extends UploadAbstract {
  @override
  UploadAbstractState createState() {
    return UploadCameraState();
  }
}

class UploadCameraState extends UploadAbstractState {
  static const platform =
      const MethodChannel('com.kdsuneraavinash.dengueapp/thumbnail');
  Chewie chewiePlayer;

  @override
  void handleBrowseImage(String userId) async {
    setState(() {
      mediaFile = null;
    });
    File pickedFile = await ImagePicker.pickVideo(source: ImageSource.gallery);
    chewiePlayer = Chewie(
      VideoPlayerController.file(pickedFile),
      autoPlay: false,
      placeholder: Icon(Icons.play_circle_filled),
      autoInitialize: true,
    );
    setState(() {
      mediaFile = pickedFile;
    });
  }

  @override
  void handleSend(String userId) async {
    setState(() {
      isUploading = true;
    });
    String thumbnail =
        "THUMB-$userId-${DateTime.now().millisecondsSinceEpoch}.png";
    String thumbnailFile =
        "${(await getApplicationDocumentsDirectory()).path}/$thumbnail";

    await _retrieveVideoFrameFromVideo(mediaFile.path, thumbnailFile);

    File thumbnailFileUpload = File(thumbnailFile);

    Uri resImage = await cloudStorage.uploadFile(
        thumbnailFileUpload, thumbnail, "thumbnails");
    Uri resVideo = await cloudStorage.uploadFile(mediaFile,
        "$userId-${DateTime.now().millisecondsSinceEpoch}.mp4", "videos");

    Post post = Post(
      videoLink: resVideo.toString(),
      type: PostType.WeeklyPost,
      user: userId,
      caption: titleText ?? "",
      approved: false,
      mediaLink: resImage.toString(),
    );
    FireStoreController.addPostDocument(data: post.toMap());
    setState(() {
      isUploading = false;
    });
    Navigator.pop(context, true);
  }

  Future<String> _retrieveVideoFrameFromVideo(
      String videoLink, String thumbnail) async {
    String thumbnailFile;
    try {
      final String result = await platform
          .invokeMethod('retrieveVideoFrameFromVideo', <String, dynamic>{
        'video': videoLink,
        'thumbnail': thumbnail,
      });
      thumbnailFile = result;
    } on PlatformException catch (_) {
      thumbnailFile = "";
    }
    return thumbnailFile;
  }

  @override
  Widget buildImageButton(String userId) {
    if (mediaFile == null) {
      return SizedBox(
        child: RaisedButton(
          onPressed: () => handleBrowseImage(userId),
          child: Icon(
            backgroundIcon,
            color: Colors.white,
            size: MediaQuery.of(context).size.width / 3,
          ),
          color: Color(0xff263238),
        ),
        height: MediaQuery.of(context).size.height,
      );
    } else {
      return Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: chewiePlayer,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: FlatButton.icon(
                  onPressed: () => handleBrowseImage(userId),
                  icon: Icon(Icons.image, color: Colors.white),
                  label: Text("Change", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          )
        ],
      );
    }
  }

  IconData backgroundIcon = Icons.video_library;
}

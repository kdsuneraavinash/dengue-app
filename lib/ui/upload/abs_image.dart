import 'package:dengue_app/logic/firebase/firestore.dart';
import 'package:dengue_app/logic/post.dart';
import 'package:dengue_app/ui/upload/abs_media.dart';
import 'package:flutter/material.dart';

abstract class UploadImageAbstractState extends UploadMediaAbstractState {
  @override
  void handleSend(String userId) async {
    setState(() {
      isUploading = true;
    });
    Uri res = await cloudMedia.uploadFile(mediaFile,
        "$userId-${DateTime.now().millisecondsSinceEpoch}.png", "images");
    Post post = Post(
      type: PostType.Image,
      user: userId,
      caption: titleText ?? "",
      approved: false,
      mediaLink: res.toString(),
    );
    FireStoreController.addPostDocument(data: post.toMap());
    setState(() {
      isUploading = false;
    });
    Navigator.pop(context, true);
  }

  @override
  Widget buildMainControl(String userId) {
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
            child: Image.file(
              mediaFile,
              fit: BoxFit.cover,
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
}

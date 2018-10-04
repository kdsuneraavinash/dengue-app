import 'package:dengue_app/logic/firebase/firestore.dart';
import 'package:dengue_app/logic/firebase/storage.dart';
import 'package:dengue_app/logic/post.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/ui/upload/abs_media.dart';
import 'package:flutter/material.dart';

abstract class UploadImageAbstractState extends UploadMediaAbstractState {
  @override
  void handleSend(User user) async {
    setState(() {
      isUploading = true;
    });
    Uri res = await CloudStorage.uploadFile(mediaFile,
        "${user.id}-${DateTime.now().millisecondsSinceEpoch}.png", "images");
    Post post = Post(
      type: PostType.Image,
      userName: user.displayName,
      userPhoto: user.photoUrl,
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
  Widget buildMainControl(User user) {
    if (mediaFile == null) {
      return SizedBox(
        child: RaisedButton(
          onPressed: () => handleBrowseImage(user),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(
                backgroundIcon,
                color: Colors.white,
                size: MediaQuery.of(context).size.width / 3,
              ),
              Text("Tap to Select File", style: TextStyle(color: Colors.white),)
            ],
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
                  onPressed: () => handleBrowseImage(user),
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

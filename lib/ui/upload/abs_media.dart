import 'dart:io';

import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/ui/upload/abs_upload.dart';
import 'package:flutter/material.dart';

abstract class UploadMediaAbstractState extends UploadAbstractState {
  @override
  bool shouldEnableSendButton() {
    return mediaFile != null && !isUploading;
  }

  @override
  Widget buildBottomTextArea(User user) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.text_fields, color: Colors.yellow),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 3,
              controller: TextEditingController.fromValue(TextEditingValue(
                  text: titleText,
                  selection:
                      TextSelection.collapsed(offset: titleText.length))),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: "Type your thoughts here",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  )),
              onChanged: (text) {
                setState(() {
                  titleText = text;
                });
              },
              onSubmitted: (_) => handleSend(user),
            ),
          ),
        )
      ],
    );
  }

  void handleBrowseImage(User user);

  String titleText = "";
  File mediaFile;
  IconData backgroundIcon;
}

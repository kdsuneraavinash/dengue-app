import 'dart:io';

import 'package:dengue_app/logic/firebase/firestore.dart';
import 'package:dengue_app/logic/post.dart';
import 'package:dengue_app/ui/upload_abstract_ui.dart';

import 'package:flutter/material.dart';

class UploadText extends UploadAbstract {
  @override
  UploadAbstractState createState() {
    return UploadTextState();
  }
}

class UploadTextState extends UploadAbstractState {
  @override
  Widget buildImageButton(String userId) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          maxLines: null,
          controller: TextEditingController.fromValue(
            TextEditingValue(
              text: titleText,
              selection: TextSelection.collapsed(offset: titleText.length),
            ),
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32.0,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
              hintText: "Write Your Post Here",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              )),
          onChanged: (text) {
            if (text.length <= 500){
              setState(() {
                titleText = text;
              });
            }
          },
          onSubmitted: (_) => handleSend(userId),
        ),
      ),
      height: MediaQuery.of(context).size.height,
    );
  }

  @override
  bool shouldEnableSendButton() {
    return (titleText ?? "") != "" && !isUploading;
  }

  @override
  Widget buildTextArea(String userId) {
    return Container();
  }

  @override
  void handleSend(String userId) async {
    setState(() {
      isUploading = true;
    });
    Post post = Post(
      type: PostType.Text,
      user: userId,
      caption: titleText ?? "",
      approved: false,
      mediaLink: "",
    );
    FireStoreController.addPostDocument(data: post.toMap());
    setState(() {
      isUploading = false;
    });
    Navigator.pop(context, true);
  }

}

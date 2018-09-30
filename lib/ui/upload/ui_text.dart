import 'package:dengue_app/logic/firebase/firestore.dart';
import 'package:dengue_app/logic/post.dart';
import 'package:dengue_app/ui/upload/abs_upload.dart';
import 'package:flutter/material.dart';

class UploadText extends UploadAbstract {
  @override
  UploadAbstractState createState() {
    return UploadTextState();
  }
}

class UploadTextState extends UploadAbstractState {
  @override
  Widget buildMainControl(String userId) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: TextField(
          maxLines: null,
          controller: textEditingController,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32.0,
            fontWeight: FontWeight.w400,
            letterSpacing: 2.0
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Write Your Post Here",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
          onSubmitted: (_) => handleSend(userId),
        ),
      ),
      height: MediaQuery.of(context).size.height,
    );
  }

  @override
  bool shouldEnableSendButton() {
    return (textEditingController.text ?? "") != "" && !isUploading;
  }

  @override
  Widget buildBottomTextArea(String userId) {
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
      caption: textEditingController.text ?? "",
      approved: false,
      mediaLink: "",
    );
    FireStoreController.addPostDocument(data: post.toMap());
    setState(() {
      isUploading = false;
    });
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  final TextEditingController textEditingController = TextEditingController();
}

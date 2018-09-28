import 'dart:io';

import 'package:dengue_app/bloc/user_bloc.dart';
import 'package:dengue_app/custom_widgets/errorwidget.dart';
import 'package:dengue_app/logic/firebase/firestore.dart';
import 'package:dengue_app/logic/post.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/providers/user_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

abstract class UploadAbstract extends StatefulWidget {
  @override
  UploadAbstractState createState();
}

abstract class UploadAbstractState extends State<UploadAbstract> {
  UserBLoC userBLoC;
  bool isUploading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userBLoC = UserBLoCProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: userBLoC.userStream,
      builder: (_, snapshot) => snapshot.data != null
          ? Scaffold(
              appBar: AppBar(
                title: Text("Upload"),
              ),
              body: Stack(
                children: isUploading
                    ? [_buildUploadView(snapshot.data), _buildOpacityOverlay()]
                    : [_buildUploadView(snapshot.data)],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: shouldEnableSendButton()
                  ? FloatingActionButton(
                      key: Key("FAB"),
                      onPressed: () => handleSend(snapshot.data?.id),
                      child: Icon(Icons.send),
                    )
                  : null,
            )
          : ErrorViewWidget(),
    );
  }

  bool shouldEnableSendButton() {
    return mediaFile != null && !isUploading;
  }

  Widget _buildUploadView(User user) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Center(
              child: _buildImageBanner(user?.id),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
        ),
        Container(
          child: buildTextArea(user?.id),
          color: Colors.black,
        )
      ],
    );
  }

  Widget _buildOpacityOverlay() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.9,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Center(
          child: HeartbeatProgressIndicator(
            child: Icon(
              FontAwesomeIcons.upload,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  /// Builds CachedNetworkImage as Banner.
  Widget _buildImageBanner(String userName) {
    return Row(
      children: <Widget>[
        Expanded(
          child: buildImageButton(userName),
        ),
      ],
    );
  }

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

  Widget buildTextArea(String userId) {
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
              onSubmitted: (_) => handleSend(userId),
            ),
          ),
        )
      ],
    );
  }

  void handleBrowseImage(String userId) async {
    List command = await showDialog(
        context: context,
        builder: (dialogContext) => SimpleDialog(
              title: Center(
                child: Text("Select Media"),
              ),
              contentPadding: EdgeInsets.all(8.0),
              children: <Widget>[
                Divider(),
                OutlineButton.icon(
                    onPressed: () {
                      Navigator.pop(dialogContext, [ImageSource.camera]);
                    },
                    icon: Icon(FontAwesomeIcons.camera),
                    label: Text("Camera (Image)")),
                OutlineButton.icon(
                    onPressed: () {
                      Navigator.pop(dialogContext, [ImageSource.gallery]);
                    },
                    icon: Icon(FontAwesomeIcons.solidImages),
                    label: Text("Gallery (Image)")),
                OutlineButton.icon(
                    onPressed: null,
                    icon: Icon(FontAwesomeIcons.video),
                    label: Text("Camera (Video)")),
                OutlineButton.icon(
                    onPressed: null,
                    icon: Icon(FontAwesomeIcons.solidFileVideo),
                    label: Text("Gallery (Video)")),
              ],
            ));
    if (command == null) {
      return;
    }
    File browsedImage = await ImagePicker.pickImage(source: command[0]);
    setState(() {
      mediaFile = browsedImage;
    });
  }

  void handleSend(String userId) async {
    setState(() {
      isUploading = true;
    });
    Uri res = await cloudStorage.uploadFile(
        mediaFile, "$userId-${DateTime.now().millisecondsSinceEpoch}.png", "images");
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

  final TextEditingController textEditingController = TextEditingController();
  String titleText = "";
  File mediaFile;
  IconData backgroundIcon = Icons.camera_alt;
}

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

class UploadImage extends StatefulWidget {
  @override
  UploadImageState createState() {
    return UploadImageState();
  }
}

class UploadImageState extends State<UploadImage> {
  UserBLoC userBLoC;
  bool _isUploading = false;

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
                children: _isUploading
                    ? [_buildUploadView(snapshot.data), _buildOpacityOverlay()]
                    : [_buildUploadView(snapshot.data)],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: FloatingActionButton(
                onPressed: _mediaFile != null && !_isUploading
                    ? () => _handleSend(snapshot.data?.id)
                    : null,
                child: Icon(Icons.send),
              ),
            )
          : ErrorViewWidget(),
    );
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
          child: _buildTextArea(user?.id),
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
          child: _buildImageButton(userName),
        ),
      ],
    );
  }

  Widget _buildImageButton(String userId) {
    if (_mediaFile == null) {
      return SizedBox(
        child: RaisedButton(
          onPressed: () => _handleBrowseImage(userId),
          child: Icon(
            FontAwesomeIcons.camera,
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
              _mediaFile,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: FlatButton.icon(
                  onPressed: () => _handleBrowseImage(userId),
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

  Widget _buildTextArea(String userId) {
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
                  text: _titleText,
                  selection:
                      TextSelection.collapsed(offset: _titleText.length))),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: "Type your thoughts here",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  )),
              onChanged: (text) {
                setState(() {
                  _titleText = text;
                });
              },
              onSubmitted: (_) => _handleSend(userId),
            ),
          ),
        )
      ],
    );
  }

  void _handleBrowseImage(String userId) async {
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
    browsedImage = await browsedImage.rename(
        "${browsedImage.parent.path}/$userId-${DateTime.now().millisecondsSinceEpoch}");
    setState(() {
      _mediaFile = browsedImage;
    });
  }

  void _handleSend(String userId) async {
    setState(() {
      _isUploading = true;
    });
    Uri res = await cloudStorage.uploadFile(_mediaFile);
    Post post = Post(
      user: userId,
      caption: _titleText ?? "",
      approved: false,
      mediaLink: res.toString(),
    );
    FireStoreController.addPostDocument(data: post.toMap());
    setState(() {
      _isUploading = false;
    });
    Navigator.pop(context, true);
  }

  final TextEditingController textEditingController = TextEditingController();
  String _titleText = "";
  File _mediaFile;
}

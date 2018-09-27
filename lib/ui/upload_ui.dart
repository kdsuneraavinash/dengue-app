import 'dart:io';

import '../main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  @override
  UploadImageState createState() {
    return  UploadImageState();
  }
}

class UploadImageState extends State<UploadImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Center(
                child: _buildImageBanner(context),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
          Container(
            child: _buildTextArea(),
            color: Colors.black,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _mediaFile != null ? _handleSend : null,
        child: Icon(Icons.send),
      ),
    );
  }

  /// Builds CachedNetworkImage as Banner.
  Widget _buildImageBanner(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildImageButton(),
        ),
      ],
    );
  }

  Widget _buildImageButton() {
    if (_mediaFile == null) {
      return SizedBox(
        child: RaisedButton(
          onPressed: () => _handleBrowseImage(),
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
                  onPressed: _handleBrowseImage,
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

  Widget _buildTextArea() {
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
              onSubmitted: (_) => _handleSend(),
            ),
          ),
        )
      ],
    );
  }

  void _handleBrowseImage() async {
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
      _mediaFile = browsedImage;
    });
  }

  void _handleSend() async {
    Uri res = await cloudStorage.uploadFile(_mediaFile);
    print(_titleText);
    print(res);
    Navigator.pop(context, true);
  }

  final TextEditingController textEditingController = TextEditingController();
  String _titleText = "";
  File _mediaFile;
}

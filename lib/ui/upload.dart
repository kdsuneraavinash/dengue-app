import 'dart:io';

import 'package:flutter/material.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key key, this.imagePath}) : super(key: key);

  @override
  UploadImageState createState() {
    return new UploadImageState();
  }

  final String imagePath;
}

class UploadImageState extends State<UploadImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Center(
                child: Image.file(File(widget.imagePath)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleSend(_titleText),
        child: Icon(Icons.send),
      ),
    );
  }

  Widget _buildTextArea() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.yellow,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 2,
              controller: TextEditingController.fromValue(TextEditingValue(
                  text: _titleText,
                  selection:
                      TextSelection.collapsed(offset: _titleText.length))),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: "Type your thought here",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  )),
              onChanged: (text) {
                setState(() {
                  _titleText = text;
                });
              },
              onSubmitted: _handleSend,
            ),
          ),
        )
      ],
    );
  }

  void _handleSend(String text) {
    print(text);
    print(widget.imagePath);
    Navigator.pop(context, true);
  }

  final TextEditingController textEditingController = TextEditingController();
  String _titleText = "";
}

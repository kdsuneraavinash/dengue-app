import 'dart:io';

import 'package:dengue_app/ui/upload_abstract_ui.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadCamera extends UploadAbstract {
  @override
  UploadAbstractState createState() {
    return UploadCameraState();
  }
}

class UploadCameraState extends UploadAbstractState {
  @override
  void handleBrowseImage(String userId) async {
    File browsedImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      mediaFile = browsedImage;
    });
  }

  IconData backgroundIcon = Icons.camera_alt;
}

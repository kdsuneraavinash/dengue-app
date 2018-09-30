import 'dart:io';

import 'package:dengue_app/ui/upload/abs_upload.dart';
import 'package:dengue_app/ui/upload/abs_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadCamera extends UploadAbstract {
  @override
  UploadAbstractState createState() {
    return UploadCameraState();
  }
}

class UploadCameraState extends UploadImageAbstractState {
  @override
  void handleBrowseImage(String userId) async {
    File pickedFile = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      mediaFile = pickedFile;
    });
  }

  IconData backgroundIcon = Icons.camera_alt;
}

import 'dart:io';

import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/ui/upload/abs_image.dart';
import 'package:dengue_app/ui/upload/abs_upload.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadGallery extends UploadAbstract {
  @override
  UploadAbstractState createState() {
    return UploadGalleryState();
  }
}

class UploadGalleryState extends UploadImageAbstractState {
  @override
  void handleBrowseImage(User user) async {
    File pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      mediaFile = pickedFile;
    });
  }

  IconData backgroundIcon = Icons.image;
}

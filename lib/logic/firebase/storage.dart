import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  static String storageBucket = 'gs://dengue-app-pulse.appspot.com';

  static Future<Uri> uploadFile(
      File file, String fileName, String folderName) async {
    final FirebaseStorage storage =
        FirebaseStorage(storageBucket: storageBucket);
    final StorageReference ref =
        storage.ref().child(folderName).child('$fileName');
    final StorageUploadTask uploadTask = ref.putFile(
      file,
      StorageMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'uploadedBy': 'Dengue Free Zone'},
      ),
    );
    UploadTaskSnapshot snapshot = await uploadTask.future;
    return snapshot.downloadUrl;
  }
}

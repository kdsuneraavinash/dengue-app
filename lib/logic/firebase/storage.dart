import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  static const String kTestString = "Hello world!";
  final FirebaseStorage storage =
      FirebaseStorage(storageBucket: 'gs://dengue-app-pulse.appspot.com');
  final Directory systemTempDir = Directory.systemTemp;

  Future<Uri> uploadFile(File file, String fileName, String folderName) async {
    final StorageReference ref = storage.ref().child(folderName).child('$fileName');
    final StorageUploadTask uploadTask = ref.putFile(
      file,
      new StorageMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'uploadedBy': 'Dengue Free Zone'},
      ),
    );
    UploadTaskSnapshot snapshot =  await uploadTask.future;
    return snapshot.downloadUrl;
  }

  Future<void> downloadFile(String fileName) async {
    final File tempFile = new File('${systemTempDir.path}/$fileName.txt');
    final StorageReference ref = storage.ref().child('text').child(fileName);
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    await task.future;

    final String tempFileContents = await tempFile.readAsString();
    print(""""
      _name = $fileName;
      _tempFileContents = $tempFileContents;
    """);
  }
}

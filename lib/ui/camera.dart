import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dengue_app/custom_widgets/transition_maker.dart';
import 'package:dengue_app/ui/upload.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() {
    return _CameraViewState();
  }

  /// Returns a suitable camera icon for [direction].
  IconData getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
    }
    throw ArgumentError('Unknown lens direction');
  }
}

class _CameraViewState extends State<CameraView> {
  CameraController controller;
  List<CameraDescription> cameras;

  bool _ready = false;
  int _selectedCameraIndex = -1;

  @override
  void initState() {
    super.initState();
    _setupCameras();
  }

  Future<void> _setupCameras() async {
    try {
      // initialize cameras.
      cameras = await availableCameras();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
      setState(() {
        _ready = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return Container();
    return Scaffold(
      body: Container(
        child: Center(
          child: _buildCameraPreview(),
        ),
        decoration: BoxDecoration(
          color: Colors.black,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: _buildAvailableCameras(),
        color: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: controller != null && controller.value.isInitialized
            ? _handleTakePicturePressed
            : null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _buildCameraPreview() {
    if (controller == null || !controller.value.isInitialized) {
      return Text(
        'Cameras Unavailable',
        style: TextStyle(color: Colors.white),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _buildAvailableCameras() {
    final List<Widget> toggles = <Widget>[];

    if (cameras.isEmpty) {
      return Text(
        'No camera found',
        style: TextStyle(color: Colors.white),
      );
    } else {
      if (_selectedCameraIndex == -1) {
        _handleNewCameraSelected(0);
        _selectedCameraIndex = 0;
      }
      for (int i = 0; i < cameras.length; i++) {
        CameraDescription cameraDescription = cameras[i];
        toggles.add(
          IconButton(
            icon:
                Icon(widget.getCameraLensIcon(cameraDescription.lensDirection)),
            color: _selectedCameraIndex == i ? Colors.green : Colors.white,
            onPressed: () => _handleNewCameraSelected(i),
          ),
        );
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.yellow,
        ),
        Row(children: toggles),
      ],
    );
  }

  void _handleNewCameraSelected(int index) async {
    if (cameras.length <= index) return;
    CameraDescription cameraDescription = cameras[index];

    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);
    controller.addListener((_handleCameraUpdated));

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted)
      setState(() {
        _selectedCameraIndex = index;
      });
  }

  /// If the controller is updated then update the UI.
  void _handleCameraUpdated() {
    if (mounted) setState(() {});
    if (controller.value.hasError) {
      print('Camera error ${controller.value.errorDescription}');
    }
  }

  Future<void> _handleTakePicturePressed() async {
    if (!controller.value.isInitialized) {
      print('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/Upload';
    await Directory(dirPath).create(recursive: true);
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$dirPath/$timestamp.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (filePath != null || filePath.length != 0) {
      TransitionMaker transition = TransitionMaker.zoomTransition(
        destinationPageCall: () => UploadImage(
              imagePath: filePath,
            ),
      );
      var result = await transition.startAndWait(context);
      if (result != null) {
        Navigator.pop(context);
      }
    }
  }

  void _showCameraException(CameraException e) {
    print('Error: ${e.code}\n${e.description}');
  }
}

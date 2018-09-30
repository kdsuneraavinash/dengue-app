import 'package:dengue_app/bloc/user_bloc.dart';
import 'package:dengue_app/custom_widgets/errorwidget.dart';
import 'package:dengue_app/logic/firebase/storage.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../../main.dart';

abstract class UploadAbstract extends StatefulWidget {
  @override
  UploadAbstractState createState();
}

abstract class UploadAbstractState extends State<UploadAbstract> {
  UserBLoC userBLoC;
  bool isUploading = false;
  CloudStorage cloudMedia = cloudStorage;

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
                    ? [_buildPage(snapshot.data), _buildLoadingOverlay()]
                    : [_buildPage(snapshot.data)],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: shouldEnableSendButton()
                  ? FloatingActionButton(
                      onPressed: () => handleSend(snapshot.data?.id),
                      child: Icon(Icons.send),
                    )
                  : null,
            )
          : ErrorViewWidget(),
    );
  }

  Widget _buildPage(User user) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Center(
              child: _buildCenterPage(user?.id),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
        ),
        Container(
          child: buildBottomTextArea(user?.id),
          color: Colors.black,
        )
      ],
    );
  }

  Widget _buildLoadingOverlay() {
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
  Widget _buildCenterPage(String userName) {
    return Row(
      children: <Widget>[
        Expanded(
          child: buildMainControl(userName),
        ),
      ],
    );
  }

  bool shouldEnableSendButton();

  Widget buildMainControl(String userId);

  Widget buildBottomTextArea(String userId);

  void handleSend(String userId);
}

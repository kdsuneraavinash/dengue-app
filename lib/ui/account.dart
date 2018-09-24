import 'package:dengue_app/bloc/login_bloc.dart';
import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:dengue_app/custom_widgets/transition_maker.dart';
import 'package:dengue_app/logic/socialmedia/controller.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/providers/login.dart';
import 'package:dengue_app/ui/credits.dart';
import 'package:dengue_app/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({@required this.socialMediaController});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: SizedBox(
              width: screenWidth / 2,
              height: screenWidth / 2,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ClipOval(
                  child: DefParameterNetworkImage(
                    imageUrl: socialMediaController?.user?.photoUrl ??
                        User.BLANK_PHOTO,
                    isCover: true,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(socialMediaController?.user?.displayName ?? "{Empty}"),
            subtitle: Text("Display Name"),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text(
                "Points : ${socialMediaController?.user?.points ?? "{Empty}"}"),
            subtitle: Text("Points"),
            leading: Icon(FontAwesomeIcons.fire),
          ),
          ListTile(
            title: Text(socialMediaController?.user?.fullName ?? "{Empty}"),
            subtitle: Text("Name"),
            leading: Icon(Icons.title),
          ),
          ListTile(
            title: Text(socialMediaController?.user?.address ?? "{Empty}"),
            subtitle: Text("Address"),
            leading: Icon(Icons.location_city),
          ),
          ListTile(
            title: Text(socialMediaController?.user?.telephone ?? "{Empty}"),
            subtitle: Text("Phone Number"),
            leading: Icon(Icons.phone),
          ),
          ListTile(
            title: Text(socialMediaController?.user?.email ?? "{Empty}"),
            subtitle: Text("E Mail"),
            leading: Icon(Icons.email),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton.icon(
                onPressed: () {
                  TransitionMaker.fadeTransition(
                      destinationPageCall: () => CreditsPage())
                    ..start(context);
                },
                icon: Icon(Icons.developer_board),
                label: Text("About")),
            FlatButton.icon(
                onPressed: () {
                  if (socialMediaController != null) {
                    LoginBLoCProvider.of(context)
                        .issueSocialMediaCommand
                        .add(LogInCommand.LOGOUT);
                    TransitionMaker.fadeTransition(
                        destinationPageCall: () => SignUpPage())
                      ..startPopAllAndPush(context);
                  }
                },
                icon: Icon(Icons.exit_to_app),
                label: Text("Log Out")),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        child: Icon(FontAwesomeIcons.edit),
      ),
    );
  }

  final SocialMediaController socialMediaController;
}

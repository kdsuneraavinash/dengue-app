import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:dengue_app/custom_widgets/transition_maker.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/ui/credits.dart';
import 'package:dengue_app/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({@required this.user});

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
                    imageUrl: user?.photoUrl ?? User.BLANK_PHOTO,
                    isCover: true,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(this.user.displayName),
            subtitle: Text("Display Name"),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text("Points : ${this.user.points}"),
            subtitle: Text("Points"),
            leading: Icon(FontAwesomeIcons.fire),
          ),
          ListTile(
            title: Text(this.user.fullName),
            subtitle: Text("Name"),
            leading: Icon(Icons.title),
          ),
          ListTile(
            title: Text(this.user.address),
            subtitle: Text("Address"),
            leading: Icon(Icons.location_city),
          ),
          ListTile(
            title: Text(this.user.telephone),
            subtitle: Text("Phone Number"),
            leading: Icon(Icons.phone),
          ),
          ListTile(
            title: Text(this.user.email),
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
                  TransitionMaker.fadeTransition(
                      destinationPageCall: () => SignUpPage())
                    ..start(context);
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

  final User user;
}

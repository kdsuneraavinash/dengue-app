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
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: ListView(
        children: <Widget>[
          DefParameterNetworkImage(
            imageUrl:
                "https://c2.staticflickr.com/6/5535/11292933694_706f6c01b6_b.jpg",
            isCover: true,
          ),
          ListTile(
            title: Text(this.user.displayName),
            subtitle: Text("Display Name"),
            leading: Icon(Icons.title),
          ),
          ListTile(
            title: Text("Points : ${this.user.points}"),
            subtitle: Text("Points"),
            leading: Icon(FontAwesomeIcons.fire),
          ),
          ListTile(
            title: Text(this.user.name),
            subtitle: Text("Name"),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text(this.user.address),
            subtitle: Text("Address"),
            leading: Icon(Icons.location_city),
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

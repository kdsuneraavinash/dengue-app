import 'package:dengue_app/logic/user.dart';
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
          Container(
            color: Colors.black12,
            height: 200.0,
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
    );
  }

  final User user;
}

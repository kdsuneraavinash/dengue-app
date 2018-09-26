import 'package:dengue_app/bloc/user_bloc.dart';
import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:dengue_app/custom_widgets/transition_maker.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/providers/login.dart';
import 'package:dengue_app/providers/user.dart';
import 'package:dengue_app/ui/credits.dart';
import 'package:dengue_app/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage();

  @override
  UserInfoPageState createState() {
    return new UserInfoPageState();
  }
}

class UserInfoPageState extends State<UserInfoPage> {
  UserBLoC userBLoC;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userBLoC = UserBLoCProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: StreamBuilder<User>(
        stream: userBLoC.userStream,
        builder: (_, snapshot) => ListView(
              children: <Widget>[
                Center(
                  child: SizedBox(
                    width: screenWidth / 2,
                    height: screenWidth / 2,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: ClipOval(
                        child: DefParameterNetworkImage(
                          imageUrl: snapshot.data?.photoUrl ?? User.BLANK_PHOTO,
                          isCover: true,
                        ),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(snapshot.data?.displayName ?? "{Empty}"),
                  subtitle: Text("Display Name"),
                  leading: Icon(Icons.person),
                ),
                ListTile(
                  title: Text("Points : ${snapshot.data?.points ?? "{Empty}"}"),
                  subtitle: Text("Points"),
                  leading: Icon(FontAwesomeIcons.fire),
                ),
                ListTile(
                  title: Text(snapshot.data?.fullName ?? "{Empty}"),
                  subtitle: Text("Name"),
                  leading: Icon(Icons.title),
                ),
                ListTile(
                  title: Text(snapshot.data?.address ?? "{Empty}"),
                  subtitle: Text("Address"),
                  leading: Icon(Icons.location_city),
                ),
                ListTile(
                  title: Text(snapshot.data?.telephone ?? "{Empty}"),
                  subtitle: Text("Phone Number"),
                  leading: Icon(Icons.phone),
                ),
                ListTile(
                  title: Text(snapshot.data?.email ?? "{Empty}"),
                  subtitle: Text("E Mail"),
                  leading: Icon(Icons.email),
                ),
              ],
            ),
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
            StreamBuilder<User>(
              stream: userBLoC.userStream,
              builder: (_, snapshot) =>  FlatButton.icon(
                  onPressed: () {
                    if (snapshot.data != null) {
                      userBLoC.firestoreAuthCommand.add(LogInCommand.LOGOUT);
                      TransitionMaker.fadeTransition(
                          destinationPageCall: () => LoginBLoCProvider(child: SignUpPage()))
                        ..startPopAllAndPush(context);
                    }
                  },
                  icon: Icon(Icons.exit_to_app),
                  label: Text("Log Out")),
            ),
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
}

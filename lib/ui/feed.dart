import 'dart:async';

import 'package:dengue_app/logic/post.dart';
import 'package:dengue_app/ui/postcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FeedPage extends StatelessWidget {
  static const platform = const MethodChannel('com.kdsuneraavinash.dengueapp/facebookposts');

  Future<Null> _getBatteryLevel() async {

    var facebookLogin = new FacebookLogin();
    var result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print(result.accessToken.token);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("Error: ${result.errorMessage}");
        break;
    }

//    try {
//      final int result = await platform.invokeMethod('getBatteryLevel');
//      print('Battery level at $result % .');
//    } on PlatformException catch (e) {
//      print("Failed to get battery level: '${e.message}'.");
//    } on MissingPluginException catch (e) {
//      print("Plugin Not found: '${e.message}'");
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: RaisedButton(
          child: Text('Get Battery Level'),
          onPressed: _getBatteryLevel,
        ),
      ),
    );
  }

  Widget _build(BuildContext context) {
    return ListView(children: <Widget>[
      PostCard(
        post: Post(
          user: "Jim Nasium",
          caption:
              "Limits marked led silent dining her she far. Sir but elegance marriage dwelling likewise position old pleasure men. Dissimilar themselves simplicity no of contrasted as. Delay great day hours men. Stuff front to do allow to asked he. ",
          afterLink:
              "https://www.trulawn.co.uk/wp-content/uploads/spring-garden-resize-1280x720.jpg",
          beforeLink:
          "http://fernandogarciadory.com/wp-content/uploads/170/flores-bonitas-rojas-jardin-banco-columpio-mesa.jpg",
          likes: 3,
          shares: 4,
        ),
      ),
      PostCard(
        post: Post(
          user: "Will Power",
          caption:
              "Affronting everything discretion men now own did. Still round match we to. Frankness pronounce daughters remainder extensive has but. Happiness cordially one determine concluded fat. Plenty season beyond by hardly giving of.",
          afterLink:
              "https://www.wikihow.com/images/5/59/Clean-rusty-garden-tools-Intro.jpg",
          beforeLink:
          "http://www.fredshed.co.uk/photosgardtools/bulldogedgercu.jpg",
          likes: 16,
          shares: 3,
        ),
      ),
      PostCard(
        post: Post(
          user: "Cliff Hanger",
          caption:
              "Consulted or acuteness dejection an smallness if. Outward general passage another as it. Very his are come man walk one next. Delighted prevailed supported too not remainder perpetual who furnished. Nay affronting bed projection compliment instrument. ",
          afterLink:
              "https://www.palmers.co.nz/wp-content/uploads/bfi_thumb/Autumn-garden-niqnooeadwzjf7upqytznjh6lc2lk87zbmuo3xmxtk.jpg",
          beforeLink:
          "https://cdn.eventfinda.co.nz/uploads/events/transformed/1098808-494526-34.jpg",
          likes: 26,
          shares: 3,
        ),
      ),
      PostCard(
        post: Post(
          user: "Bud Jet",
          caption:
              "Do so written as raising parlors spirits mr elderly. Made late in of high left hold. Carried females of up highest calling.",
          afterLink:
              "https://timbercreekfarmer.com/wp-content/uploads/2016/06/weeds1.png",
          beforeLink:
          "https://www.almanac.com/sites/default/files/styles/primary_image_in_article/public/image_nodes/dandelion-greens-weeds.jpg?itok=J1YWOB1u",
          likes: 6,
          shares: 8,
        ),
      ),
      SizedBox(
        height: 75.0,
        child: Center(
          child: Text("No more post to show."),
        ),
      )
    ]);
  }
}

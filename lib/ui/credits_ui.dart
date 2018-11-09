import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/**
 * Dengue App
 * ==============
 *
 * Project MoraEvents
 *
 * Programmed By K. D. Sunera Avinash Chandrasiri
 * kdsuneraavinash@gmail.com
 * (c) 2018
 *
 * University of Moratuwa
 */

/// VCare App
/// --------------
///
/// - Project VCare
/// - Programmed By K. D. Sunera Avinash Chandrasiri
/// - kdsuneraavinash@gmail.com
/// - University of Moratuwa
class CreditsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credits"),
      ),
      body: CreditsBody(),
      bottomNavigationBar: BottomAppBar(
        child: AboutListTile(
          icon: Icon(Icons.developer_board),
          applicationName: "Dengue Free Zone",
          applicationVersion: "v0.1.0-alpha",
          applicationLegalese: "Team Pulse",
        ),
        shape: CircularNotchedRectangle(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(
          FontAwesomeIcons.backward,
        ),
      ),
    );
  }
}

/// Credits Page Content
class CreditsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 32.0, bottom: 8.0),
          child: SizedBox(
            child: ClipOval(
              child: Image.asset(
                 "assets/images/logo.png",
                fit: BoxFit.contain,
              ),
            ),
            width: 100.0,
            height: 100.0,
          ),
        ),
        _buildCreditsTile(
            "100013401603485", "K. D. Sunera Avinash Chandrasiri"),
        _buildCreditsTile("100004130706471", "Anju Chamantha"),
        _buildCreditsTile("100005312113806", "Deepana Ishtaweera"),
        _buildCreditsTile("100002491783271", "Ruchin Amarathunga"),
        _buildCreditsTile("100013403053394", "Uvindu Avishka"),
      ],
    );
  }

  /// Build each credits tile.
  /// Get Images from facebook.
  Widget _buildCreditsTile(String facebookID, String title) {
    return ListTile(
      leading: CircleAvatar(
        child: ClipOval(
          child: DefParameterNetworkImage(
            imageUrl:
                "https://graph.facebook.com/$facebookID/picture?type=large",
            isCover: true,
          ),
        ),
      ),
      title: Text(title),
    );
  }
}

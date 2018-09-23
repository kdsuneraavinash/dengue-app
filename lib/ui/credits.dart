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
          applicationName: "VCare",
          applicationVersion: "v0.1.0-alpha",
          applicationLegalese: "Team Axys",
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
              child: DefParameterNetworkImage(
                imageUrl: "http://www.logodust.com/img/free/logo26.png",
                isCover: false,
              ),
            ),
            width: 100.0,
            height: 100.0,
          ),
        ),
        _buildCreditsTile("100013401603485", "K. D. Sunera Avinash Chandrasiri",
            "Lead Programmer"),
        _buildCreditsTile("100002491783271", "Ruchin Amarathunga",
            "Programmer | Coordinator"),
        _buildCreditsTile("100004130706471", "Anju Chamantha",
            "Programmer | Product Manager"),
        // _buildCreditsTile("100005312113806", "Deepana Ishtaweera", "[Role]"),
        _buildCreditsTile(
            "100013403053394", "Uvindu Avishka", "Head of Marketing"),
      ],
    );
  }

  /// Build each credits tile.
  /// Get Images from facebook.
  Widget _buildCreditsTile(String facebookID, String title, String subtitle) {
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
      subtitle: Text(subtitle),
    );
  }
}

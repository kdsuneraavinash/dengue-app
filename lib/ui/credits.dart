import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/**
 * MoraEvents App
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
          child: Image.network(
            "http://www.logodust.com/img/free/logo26.png",
            height: 100.0,
          ),
        ),
        _buildCreditsTile("100013401603485", "K. D. Sunera Avinash Chandrasiri",
            "Lead Programmer | CTO"),
        _buildCreditsTile("100002491783271", "Ruchin Amarathunga", "COO"),
        _buildCreditsTile("100004130706471", "Anju Chamantha", "COO"),
        _buildCreditsTile("100005312113806", "Deepana Ishtaweera", "CEO"),
        _buildCreditsTile(
            "100013403053394", "Uvindu Avishka", "Head of Marketing"),
      ],
    );
  }

  /// Build each credits tile.
  /// Get Images from facebook.
  Widget _buildCreditsTile(String facebookID, String title, String subtitle) {
    return ListTile(
      leading: ClipOval(
        child: CachedNetworkImage(
          imageUrl: "https://graph.facebook.com/$facebookID/picture?type=large",
          fit: BoxFit.cover,
          width: 50.0,
          height: 50.0,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

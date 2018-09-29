import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dengue_app/logic/firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';

class GiftsPage extends StatefulWidget {
  @override
  GiftsPageState createState() {
    return new GiftsPageState();
  }
}

class GiftsPageState extends State<GiftsPage> {
  @override
  void initState() {
    super.initState();
    _loadGiftData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: (docs != null)
          ? _buildPages()
          : Center(
              child: HeartbeatProgressIndicator(
                child: Icon(
                  loadingIcon,
                  color: Colors.black,
                ),
              ),
            ),
    );
  }

  Future<void> _loadGiftData() async {
    Completer completer = Completer();
    FireStoreController.prizesDocuments.snapshots().listen((snapshot) async {
      docs = snapshot.documents
          .where((b) => b.documentID.endsWith(validator))
          .toList();
      if (snapshot != null && mounted) {
        page1 = await generatePageModal(0, Color(0xffD4AF37));
        page2 = await generatePageModal(1, Color(0xffC0C0C0));
        page3 = await generatePageModal(2, Color(0xffCD7F32));
        setState(() {});
      } else {}
    });
    return completer.future;
  }

  Widget _buildPages() {
    return IntroViewsFlutter(
      [page1, page2, page3],
      onTapDoneButton: () {
        Navigator.pop(context);
      },
      doneText: Text("Back"),
      showSkipButton: false,
      pageButtonTextStyles: TextStyle(
        color: Colors.black,
        fontSize: 18.0,
      ),
    );
  }

  Future<PageViewModel> generatePageModal(int index, Color color) async {
    double width = MediaQuery.of(context).size.width;

    return PageViewModel(
      pageColor: color,
      //iconImageAssetPath: 'assets/taxi-driver.png',
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      body: Text(
        docs[index].data["description"],
        style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w400),
      ),
      title: Text(
        "(#${index + 1}) ${docs[index].data["title"]}",
        style: TextStyle(
            color: Colors.black,
            fontSize: 32.0,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w800),
        textAlign: TextAlign.center,
      ),
      mainImage: Image(
        image: CachedNetworkImageProvider(docs[index].data["image"]),
        width: width,
        alignment: Alignment.center,
        fit: BoxFit.contain,
      ),
    );
  }

  List<DocumentSnapshot> docs;
  String validator = "Prize";
  String title = "Next Week Gifts";
  IconData loadingIcon = FontAwesomeIcons.gift;
  PageViewModel page1;
  PageViewModel page2;
  PageViewModel page3;
}

class WinnersPage extends GiftsPage {
  @override
  GiftsPageState createState() {
    return new WinnersPageState();
  }
}

class WinnersPageState extends GiftsPageState {
  @override
  String validator = "Winner";
  @override
  String title = "Last Week Winners";
  @override
  IconData loadingIcon = FontAwesomeIcons.medal;

  Future<PageViewModel> generatePageModal(int index, Color color) async {
    double width = MediaQuery.of(context).size.width;

    DocumentSnapshot userDoc =
        await FireStoreController.getUserDocumentOf(docs[index].data["user"]);

    return PageViewModel(
      pageColor: color,
      //iconImageAssetPath: 'assets/taxi-driver.png',
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      body: Text(
        "Won: ${docs[index].data['prize']}",
        style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w400),
      ),
      title: Text(
        "(#${index + 1}) ${userDoc.data["displayName"]}",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black,
            fontSize: 28.0,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w800),
      ),
      mainImage: Image(
        image: CachedNetworkImageProvider(userDoc.data["photoUrl"]),
        width: width / 3,
        fit: BoxFit.fitWidth,
        alignment: Alignment.center,
      ),
    );
  }
}

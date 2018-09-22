import 'package:dengue_app/custom_widgets/transition_maker.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/ui/account.dart';
import 'package:dengue_app/ui/upload.dart';
import 'package:dengue_app/ui/feed.dart';
import 'package:dengue_app/ui/leaderboard.dart';
import 'package:dengue_app/ui/taskfeed.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  final PageController pageController = new PageController(initialPage: 1);
  final User user = User(
    name: "Curt N. Call",
    address: "4554, Doctors Drive, Los Angeles, California.",
    displayName: "Curt",
    points: 0,
  );

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: PageView(
        controller: widget.pageController,
        onPageChanged: _handlePageChanged,
        children: <Widget>[
          TaskFeedPage(),
          FeedPage(),
          LeaderBoard(
            user: widget.user,
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          TransitionMaker.slideTransition(
              destinationPageCall: () => UploadImage())
            ..start(context);
        },
        isExtended: true,
        label: Text("Post"),
        icon: Icon(Icons.camera_alt),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("VCare"),
      actions: <Widget>[
        IconButton(
          onPressed: () => null,
          icon: Icon(FontAwesomeIcons.gift),
        ),
        FlatButton.icon(
          onPressed: () => null,
          icon: Icon(FontAwesomeIcons.fire, color: Colors.white),
          label: Text(
            "${widget.user.points}",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
      leading: IconButton(
        icon: CircleAvatar(
          child: Icon(
            Icons.person_outline,
          ),
          backgroundColor: Colors.white,
        ),
        onPressed: () {
          TransitionMaker.fadeTransition(
              destinationPageCall: () => UserInfoPage(user: widget.user))
            ..start(context);
        },
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      onTap: _handleBottomNavigationBarTap,
      currentIndex: this.currentIndex,
      items: <BottomNavigationBarItem>[
        _buildBottomNavigationBarItem(
          icon: FontAwesomeIcons.tasks,
          title: "Tasks",
        ),
        _buildBottomNavigationBarItem(
          icon: FontAwesomeIcons.home,
          title: "Feed",
        ),
        _buildBottomNavigationBarItem(
          icon: FontAwesomeIcons.certificate,
          title: "Leader Board",
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    @required IconData icon,
    @required String title,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      title: Text(title),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  /// Animate PageView when BottomNavigationBar is tapped.
  /// If far away, jump to it.
  void _handleBottomNavigationBarTap(int index) {
    if ((currentIndex - index).abs() > 1) {
      // Jump to page if page is far away
      widget.pageController.jumpToPage(
        index,
      );
    } else {
      widget.pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
    _handlePageChanged(index);
  }

  /// Change index of BottomNavigationBar if PageView is turned
  void _handlePageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  int currentIndex = 1;
}

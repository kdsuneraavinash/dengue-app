import 'package:cached_network_image/cached_network_image.dart';
import 'package:dengue_app/bloc/home_bloc.dart';
import 'package:dengue_app/bloc/user_bloc.dart';
import 'package:dengue_app/custom_widgets/errorwidget.dart';
import 'package:dengue_app/custom_widgets/transition_maker.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/providers/home_provider.dart';
import 'package:dengue_app/providers/user_provider.dart';
import 'package:dengue_app/ui/account_ui.dart';
import 'package:dengue_app/ui/achievements_ui.dart';
import 'package:dengue_app/ui/credits_ui.dart';
import 'package:dengue_app/ui/feed_ui.dart';
import 'package:dengue_app/ui/gifts_ui.dart';
import 'package:dengue_app/ui/leaderboard_ui.dart';
import 'package:dengue_app/ui/taskfeed_ui.dart';
import 'package:dengue_app/ui/upload_camera_ui.dart';
import 'package:dengue_app/ui/upload_gallery_ui.dart';
import 'package:dengue_app/ui/upload_text_ui.dart';
import 'package:dengue_app/ui/upload_video_ui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:url_launcher/url_launcher.dart';

enum UploadType { Text, Camera, Gallery, WeeklyPost }

class HomePage extends StatefulWidget {
  final PageController _pageController = PageController(initialPage: 1);
  static const routeName = "/home";

  HomePage();

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  HomePageBLoC homeBLoC;
  UserBLoC userBLoC;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    homeBLoC = HomePageBLoCProvider.of(context);
    userBLoC = UserBLoCProvider.of(context);
    homeBLoC.goToTabPageAnimate.listen(_handleAnimateToPage);
    homeBLoC.goToTabPageJump.listen(_handleJumpToPage);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: userBLoC.userStream,
      builder: (_, snapshotUser) => Scaffold(
            drawer: _buildDrawer(snapshotUser.data),
            appBar: _buildAppBar(snapshotUser.data),
            body: PageView(
              controller: widget._pageController,
              onPageChanged: homeBLoC.changeCurrentPage.add,
              children: <Widget>[
                TaskFeedPage(),
                FeedPage(),
                (snapshotUser.data == null) ? ErrorViewWidget() : LeaderBoard(),
              ],
            ),
            bottomNavigationBar: _buildBottomNavigationBar(),
            floatingActionButton: _buildFloatingActionButton(),
          ),
    );
  }

  List<UnicornButton> childButtons;

  Widget _buildFloatingActionButton() {
    return UnicornDialer(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.6),
      parentButtonBackground: Theme.of(context).accentColor,
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(FontAwesomeIcons.pen),
      childButtons: childButtons,
    );
  }

  Widget _buildAppBar(User user) {
    return AppBar(
      title: Text("Dengue Free Zone"),
      actions: <Widget>[
        FlatButton.icon(
          onPressed: null,
          icon: Icon(FontAwesomeIcons.fire, color: Colors.white),
          label: Text(
            "${(user == null) ? '--' : user.points}",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(User user) {
    if (user == null) {
      return Container();
    }
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user.displayName),
            accountEmail: Text(user.email),
            currentAccountPicture: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _handleNavigateToAccountPage();
              },
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
            ),
          ),
          MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _handleNavigateToAchievementsPage();
                    },
                    leading: Icon(FontAwesomeIcons.medal),
                    title: Text("Achievements"),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _handleNavigateToGiftPage();
                    },
                    leading: Icon(FontAwesomeIcons.gift),
                    title: Text("Next Gifts"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _handleNavigateToWinnersPage();
                    },
                    leading: Icon(FontAwesomeIcons.tags),
                    title: Text("View Winners"),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _launchUrl("https://www.youtube.com/watch?v=-fQevMEQDJQ");
                    },
                    leading: Icon(FontAwesomeIcons.playCircle),
                    title: Text("View Tutorials"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _launchUrl("https://www.facebook.com/denguefreezone/");
                    },
                    leading: Icon(FontAwesomeIcons.facebookSquare),
                    title: Text("Facebook Page"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      String toMailId = "denguefreezone@gmail.com";
                      String subject = "Feedback on Dengue Freezone App";
                      String body = "";
                      _launchUrl(
                          'mailto:$toMailId?subject=$subject&body=$body');
                    },
                    leading: Icon(FontAwesomeIcons.envelope),
                    title: Text("Send Feedback"),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _launchUrl(
                          "https://github.com/kdsuneraavinash/dengue_app");
                    },
                    leading: Icon(FontAwesomeIcons.listAlt),
                    title: Text("What's New"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _handleNavigateToAboutPage();
                    },
                    leading: Icon(FontAwesomeIcons.questionCircle),
                    title: Text("About"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return StreamBuilder<int>(
      initialData: 1,
      stream: homeBLoC.currentPageIndex,
      builder: (_, snapshot) => BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            onTap: homeBLoC.changeCurrentPageByNavigationBar.add,
            currentIndex: snapshot.data ?? 1,
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
          ),
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

  void _handleAnimateToPage(int page) {
    if (page != null && widget._pageController.hasClients) {
      widget._pageController.animateToPage(page,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    }
  }

  void _handleJumpToPage(int page) {
    if (page != null && widget._pageController.hasClients) {
      widget._pageController.jumpToPage(page);
    }
  }

  void _handleNavigateToUploadPage(UploadType navigate) {
    if (mounted) {
      switch (navigate) {
        case UploadType.Text:
          TransitionMaker.fadeTransition(
              destinationPageCall: () => UploadText())
            ..start(context);
          break;
        case UploadType.WeeklyPost:
          TransitionMaker.fadeTransition(
              destinationPageCall: () => UploadWeekly())
            ..start(context);
          break;
        case UploadType.Camera:
          TransitionMaker.fadeTransition(
              destinationPageCall: () => UploadCamera())
            ..start(context);
          break;
        case UploadType.Gallery:
          TransitionMaker.fadeTransition(
              destinationPageCall: () => UploadGallery())
            ..start(context);
      }
    }
  }

  void _handleNavigateToAccountPage() {
    if (mounted) {
      TransitionMaker.slideTransition(destinationPageCall: () => UserInfoPage())
        ..start(context);
    }
  }

  void _handleNavigateToAboutPage() {
    if (mounted) {
      TransitionMaker.slideTransition(destinationPageCall: () => CreditsPage())
        ..start(context);
    }
  }

  void _handleNavigateToAchievementsPage() {
    if (mounted) {
      TransitionMaker.slideTransition(
          destinationPageCall: () => AchievementsPage())
        ..start(context);
    }
  }

  void _handleNavigateToGiftPage() {
    if (mounted) {
      TransitionMaker.slideTransition(destinationPageCall: () => GiftsPage())
        ..start(context);
    }
  }

  void _handleNavigateToWinnersPage() {
    if (mounted) {
      TransitionMaker.slideTransition(destinationPageCall: () => WinnersPage())
        ..start(context);
    }
  }

  @override
  void initState() {
    childButtons = List<UnicornButton>();

    childButtons.add(
      UnicornButton(
          hasLabel: true,
          labelText: "Weekly Post",
          labelColor: Colors.black,
          currentButton: FloatingActionButton(
            heroTag: "weeklyPost",
            backgroundColor: Colors.red,
            mini: true,
            child: Icon(Icons.play_arrow),
            onPressed: () => _handleNavigateToUploadPage(UploadType.WeeklyPost),
          )),
    );

    childButtons.add(
      UnicornButton(
          hasLabel: true,
          labelText: "Gallery",
          labelColor: Colors.black,
          currentButton: FloatingActionButton(
            heroTag: "gallery",
            backgroundColor: Colors.green,
            mini: true,
            child: Icon(Icons.image),
            onPressed: () => _handleNavigateToUploadPage(UploadType.Gallery),
          )),
    );

    childButtons.add(
      UnicornButton(
          hasLabel: true,
          labelText: "Camera",
          labelColor: Colors.black,
          currentButton: FloatingActionButton(
            heroTag: "camera",
            backgroundColor: Colors.blue,
            mini: true,
            child: Icon(Icons.camera_alt),
            onPressed: () => _handleNavigateToUploadPage(UploadType.Camera),
          )),
    );

    childButtons.add(
      UnicornButton(
          hasLabel: true,
          labelText: "Text",
          labelColor: Colors.black,
          currentButton: FloatingActionButton(
            heroTag: "text",
            backgroundColor: Colors.deepPurple,
            mini: true,
            child: Icon(Icons.title),
            onPressed: () => _handleNavigateToUploadPage(UploadType.Text),
          )),
    );

    super.initState();
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      print(url);
    } else {
      return;
    }
  }
}

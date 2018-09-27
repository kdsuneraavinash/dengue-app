import 'package:dengue_app/bloc/home_bloc.dart';
import 'package:dengue_app/bloc/user_bloc.dart';
import 'package:dengue_app/custom_widgets/errorwidget.dart';
import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:dengue_app/custom_widgets/transition_maker.dart';
import 'package:dengue_app/logic/user.dart';
import '../main.dart';
import 'package:dengue_app/providers/home_provider.dart';
import 'package:dengue_app/providers/user_provider.dart';
import 'package:dengue_app/ui/account_ui.dart';
import 'package:dengue_app/ui/feed_ui.dart';
import 'package:dengue_app/ui/leaderboard_ui.dart';
import 'package:dengue_app/ui/taskfeed_ui.dart';
import 'package:dengue_app/ui/upload_ui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  final PageController _pageController = PageController(initialPage: 1);

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
            appBar: _buildAppBar(snapshotUser.data),
            body: PageView(
              controller: widget._pageController,
              onPageChanged: homeBLoC.changeCurrentPage.add,
              children: <Widget>[
                TaskFeedPage(),
                FeedPage(),
                snapshotUser.data == null ? ErrorViewWidget() : LeaderBoard(),
              ],
            ),
            bottomNavigationBar: _buildBottomNavigationBar(),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _handleNavigateToUploadPage(true),
              isExtended: true,
              label: Text("Post"),
              icon: Icon(Icons.camera_alt),
            ),
          ),
    );
  }

  Widget _buildAppBar(User user) {
    return AppBar(
      title: Text("Dengue Free Zone"),
      actions: <Widget>[
        IconButton(
          onPressed: () => _handleNavigateToGiftPage(true),
          icon: Icon(FontAwesomeIcons.gift),
        ),
        FlatButton.icon(
          onPressed: null,
          icon: Icon(FontAwesomeIcons.fire, color: Colors.white),
          label: Text(
            "${user == null ? '--' : user.points}",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
      leading: StreamBuilder<User>(
        stream: userBLoC.userStream,
        builder: (_, snapshot) => IconButton(
              icon: CircleAvatar(
                child: ClipOval(
                  child: DefParameterNetworkImage(
                    imageUrl: user?.photoUrl == null
                        ? User.BLANK_PHOTO
                        : user?.photoUrl,
                    isCover: true,
                  ),
                ),
                backgroundColor: Colors.white,
              ),
              onPressed: () => _handleNavigateToAccountPage(),
            ),
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

  void _handleNavigateToUploadPage(navigate) {
    if (navigate && context != null) {
      TransitionMaker.fadeTransition(destinationPageCall: () => UploadImage())
        ..start(context);
    }
  }

  void _handleNavigateToAccountPage() {
    if (context != null) {
      TransitionMaker.fadeTransition(destinationPageCall: () => UserInfoPage())
        ..start(context);
    }
  }

  void _handleNavigateToGiftPage(navigate) {
    // Go To Last Week Winners
    print("Go to gifts page");
  }
}

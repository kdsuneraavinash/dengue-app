import 'package:dengue_app/bloc/home_bloc.dart';
import 'package:dengue_app/custom_widgets/errorwidget.dart';
import 'package:dengue_app/custom_widgets/network_image.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/ui/feed.dart';
import 'package:dengue_app/ui/leaderboard.dart';
import 'package:dengue_app/ui/taskfeed.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  final HomePageBLoC uibLoC = HomePageBLoC();

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: widget.uibLoC.userData,
      builder: (_, snapshotUser) => Scaffold(
            appBar: _buildAppBar(snapshotUser.data),
            body: StreamBuilder<PageController>(
              initialData: PageController(initialPage: 1),
              stream: widget.uibLoC.pageControllerData,
              builder: (_, snapshotPageController) => PageView(
                    controller: snapshotPageController.data,
                    onPageChanged: widget.uibLoC.changeCurrentPage.add,
                    children: <Widget>[
                      TaskFeedPage(),
                      FeedPage(),
                      snapshotUser.data == null
                          ? ErrorViewWidget()
                          : LeaderBoard(user: snapshotUser.data),
                    ],
                  ),
            ),
            bottomNavigationBar: _buildBottomNavigationBar(),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => widget.uibLoC.tappedGoToUploadPage.add(context),
              isExtended: true,
              label: Text("Post"),
              icon: Icon(Icons.camera_alt),
            ),
          ),
    );
  }

  Widget _buildAppBar(User user) {
    return AppBar(
      title: Text("VCare"),
      actions: <Widget>[
        IconButton(
          onPressed: () => widget.uibLoC.tappedGoTGiftPage.add(context),
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
      leading: IconButton(
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
        onPressed: () => widget.uibLoC.tappedGoTAccountPage.add(context),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return StreamBuilder<int>(
      initialData: 1,
      stream: widget.uibLoC.currentPageIndex,
      builder: (_, snapshot) => BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            onTap: widget.uibLoC.changeCurrentPageByNavigationBar.add,
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

  @override
  void dispose() {
    super.dispose();
    widget.uibLoC.dispose();
  }
}

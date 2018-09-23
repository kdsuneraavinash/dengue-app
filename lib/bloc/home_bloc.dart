import 'dart:async';

import 'package:dengue_app/custom_widgets/transition_maker.dart';
import 'package:dengue_app/logic/user.dart';
import 'package:dengue_app/ui/account.dart';
import 'package:dengue_app/ui/upload.dart';
import 'package:dengue_app/bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class HomePageBLoC extends BLoC {
  // Streams and Sinks
  final BehaviorSubject<int> _currentPageIndex = BehaviorSubject(seedValue: 1);
  final BehaviorSubject<User> _userData = BehaviorSubject();
  final BehaviorSubject<PageController> _pageControllerData = BehaviorSubject();
  final StreamController<int> _changeCurrentPage = StreamController();
  final StreamController<int> _changeCurrentPageByNavigationBar =
      StreamController();
  final StreamController<BuildContext> _tappedGoToUploadPage =
      StreamController();
  final StreamController<BuildContext> _tappedGoToAccountPage =
      StreamController();
  final StreamController<BuildContext> _tappedGoToGiftPage = StreamController();

  Stream<int> get currentPageIndex => _currentPageIndex.stream;
  Stream<User> get userData => _userData.stream;
  Stream<PageController> get pageControllerData => _pageControllerData.stream;
  Sink<int> get changeCurrentPage => _changeCurrentPage.sink;
  Sink<int> get changeCurrentPageByNavigationBar =>
      _changeCurrentPageByNavigationBar.sink;
  Sink<BuildContext> get tappedGoToUploadPage => _tappedGoToUploadPage.sink;
  Sink<BuildContext> get tappedGoTAccountPage => _tappedGoToAccountPage.sink;
  Sink<BuildContext> get tappedGoTGiftPage => _tappedGoToGiftPage.sink;

  // Instance Variables
  int _currentPage = 1;
  PageController _pageController = PageController(initialPage: 1);
  User _user;

  HomePageBLoC() {
    _changeCurrentPage.stream.listen(_currentPageChanged);
    _changeCurrentPageByNavigationBar.stream
        .listen(_currentPageChangedByNavigationBar);
    _tappedGoToUploadPage.stream.listen(_goToUploadPage);
    _tappedGoToAccountPage.stream.listen(_goToAccountPage);
    _tappedGoToGiftPage.stream.listen(_goToGiftsPage);

    _user = User(
      name: "Curt N. Call",
      address: "4554, Doctors Drive, Los Angeles, California.",
      displayName: "Curt",
      points: 0,
    );
    _userData.add(_user);
    _pageControllerData.add(_pageController);
  }

  @override
  void dispose() {
    _currentPageIndex.close();
    _userData.close();
    _pageControllerData.close();
    _changeCurrentPage.close();
    _changeCurrentPageByNavigationBar.close();
    _tappedGoToUploadPage.close();
    _tappedGoToAccountPage.close();
    _tappedGoToGiftPage.close();
  }

  /// Change index of BottomNavigationBar if PageView is turned
  void _currentPageChanged(int page) {
    _currentPageIndex.add(page);
    _currentPage = page;
  }

  /// Animate PageView when BottomNavigationBar is tapped.
  /// If far away, jump to it.
  void _currentPageChangedByNavigationBar(int page) {
    if (_pageController != null) {
      if ((_currentPage - page).abs() > 1) {
        // Jump to page if page is far away
        _pageController.jumpToPage(page);
      } else {
        _pageController.animateToPage(
          page,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
        );
      }
      changeCurrentPage.add(page);
    }
  }

  void _goToUploadPage(BuildContext context) {
    TransitionMaker.slideTransition(destinationPageCall: () => UploadImage())
      ..start(context);
  }

  void _goToAccountPage(BuildContext context) {
    if (_user != null){
      TransitionMaker.fadeTransition(
          destinationPageCall: () => UserInfoPage(user: _user))
        ..start(context);
    }
  }

  void _goToGiftsPage(BuildContext context) {
    // Go To Last Week Winners
    print("Go to gifts page");
  }
}

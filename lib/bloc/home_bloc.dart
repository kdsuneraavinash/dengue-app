import 'dart:async';
import 'package:dengue_app/bloc/bloc.dart';
import 'package:rxdart/subjects.dart';

class HomePageBLoC extends BLoC {
  // Streams and Sinks

  /// Current Page Index which is needed to
  /// update selected bottom navigation bar item
  final BehaviorSubject<int> _currentPageIndex = BehaviorSubject(seedValue: 1);
  /// Issues the command to change Tab Page.
  final PublishSubject<int> _changeTabPageAnimate = PublishSubject();
  final PublishSubject<int> _changeTabPageJump = PublishSubject();

  /// Change current page: using swiping page view
  final StreamController<int> _changeCurrentPage = StreamController();
  /// Change current page: using tapping bottom navigation bar
  final StreamController<int> _changeCurrentPageByNavigationBar =
      StreamController();

  /// Defining Outputs from stream
  /// Stream ------------> Widgets
  Stream<int> get currentPageIndex => _currentPageIndex.stream;
  Stream<int> get goToTabPageAnimate => _changeTabPageAnimate.stream;
  Stream<int> get goToTabPageJump => _changeTabPageJump.stream;

  /// Defining Outputs to stream
  /// Stream <------------ Widgets
  Sink<int> get changeCurrentPage => _changeCurrentPage.sink;
  Sink<int> get changeCurrentPageByNavigationBar =>
      _changeCurrentPageByNavigationBar.sink;

  // Current page of page controller
  int _currentPage = 1;

  HomePageBLoC() :super();

  @override
  void streamConnect() {
    _changeCurrentPage.stream.listen(_currentPageChanged);
    _changeCurrentPageByNavigationBar.stream
        .listen(_currentPageChangedByNavigationBar);
  }

  @override
  void dispose() {
    _currentPageIndex.close();
    _changeTabPageAnimate.close();
    _changeTabPageJump.close();
    _changeCurrentPage.close();
    _changeCurrentPageByNavigationBar.close();
  }

  /// Change index of BottomNavigationBar if PageView is turned
  void _currentPageChanged(int page) {
    _currentPageIndex.add(page);
    _currentPage = page;
  }

  /// Animate PageView when BottomNavigationBar is tapped.
  /// If far away, jump to it.
  void _currentPageChangedByNavigationBar(int page) {
      if ((_currentPage - page).abs() > 1) {
        // Jump to page if page is far away
        _changeTabPageJump.add(page);
      } else {
        _changeTabPageAnimate.add(page);
      }
      changeCurrentPage.add(page);
  }
}

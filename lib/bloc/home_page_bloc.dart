import 'dart:async';

import 'package:dengue_app/bloc/bloc.dart';
import 'package:rxdart/subjects.dart';

class HomePageUIBLoC extends BLoC {
  final BehaviorSubject<int> _currentPageIndex =
      new BehaviorSubject(seedValue: 0);
  final StreamController<int> _changeCurrentPage = new StreamController();

  HomePageUIBLoC() {
    _changeCurrentPage.stream.listen(currentPageChanged);
  }

  @override
  void dispose() {
    _currentPageIndex.close();
    _changeCurrentPage.close();
  }

  Stream<int> get currentPageIndex => this._currentPageIndex.stream;

  Sink<int> get changeCurrentPage => this._changeCurrentPage.sink;

  void currentPageChanged(int page) {
    _currentPageIndex.add(page);
  }
}

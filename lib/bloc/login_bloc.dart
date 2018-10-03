import 'dart:async';

import 'package:dengue_app/bloc/bloc.dart';
import 'package:rxdart/subjects.dart';

enum LogInState { SIGNED_UP, NOT_LOGGED, WAITING, LOGGED }

class LoginBLoC extends BLoC {
  /// Issues the command to change Tab Page.
  final PublishSubject<int> _currentTabPageStream = PublishSubject();
  Stream<int> get goToTabPageStream => _currentTabPageStream.stream;

  final PublishSubject<Null> _shouldNavigateToHomePageStream = PublishSubject();
  Stream<Null> get navigateToHomePageStream =>
      _shouldNavigateToHomePageStream.stream;

  final PublishSubject<Map<String, dynamic>> _signUpStatusUpdateStream =
      PublishSubject();
  Stream<Map<String, dynamic>> get signUpStatusUpdateStream =>
      _signUpStatusUpdateStream.stream;

  final StreamController<int> _submitStreamController = StreamController();
  Sink<int> get submitSink => _submitStreamController.sink;

  final StreamController<LogInState> _loginStatusChangedStreamController =
      StreamController();
  Sink<LogInState> get loginStatusChangedSink =>
      _loginStatusChangedStreamController.sink;

  @override
  void streamConnect() async {
    /// Associates handlers to inputs to stream
    _submitStreamController.stream.listen(_handleSubmitPressed);
    _loginStatusChangedStreamController.stream
        .listen(_handleLoginStatusChanged);
  }

  @override
  void dispose() {
    _signUpStatusUpdateStream.close();
    _loginStatusChangedStreamController.close();
    _submitStreamController.close();
    _currentTabPageStream.close();
    _shouldNavigateToHomePageStream.close();
  }

  /// Sign in command
  void _handleLoginStatusChanged(LogInState status) async {
    switch (status) {
      case LogInState.LOGGED:
        _shouldNavigateToHomePageStream.add(null);
        break;
      case LogInState.SIGNED_UP:
        _currentTabPageStream.add(1);
        break;
      case LogInState.NOT_LOGGED:
        _logOut();
        break;
      case LogInState.WAITING:
        break;
    }
  }

  /// Logout command
  void _logOut() {
    _currentTabPageStream.add(0);
  }

  /// Texts Submitted Handler
  void _handleSubmitPressed(int stage) {
    if (stage == 0) {
      _currentTabPageStream.add(2);
    } else if (stage == 1) {
      _loginStatusChangedStreamController.add(LogInState.LOGGED);
    }
  }
}

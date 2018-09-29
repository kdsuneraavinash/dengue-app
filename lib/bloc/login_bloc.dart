import 'dart:async';

import 'package:dengue_app/bloc/bloc.dart';

import 'package:rxdart/subjects.dart';

enum LogInState { SIGNED_UP, NOT_LOGGED, WAITING, LOGGED }

class LoginBLoC extends BLoC {
  /// Issues the command to change Tab Page.
  final PublishSubject<int> _currentTabPageStream = PublishSubject();

  /// Issues the command to navigate to home page.
  /// Sends boolean to be used by [HomePage].
  /// null if no need to change page.
  /// *Remember to set to false after logging out.*
  final PublishSubject<Null> _shouldNavigateToHomePageStream = PublishSubject();

  final PublishSubject<Map<String, dynamic>> _signUpStatusUpdateStream =
      PublishSubject();

  /// Further details Text Change Methods
  final StreamController<String> _changeFullNameStreamController = StreamController();
  final StreamController<String> _changeAddressStreamController = StreamController();
  final StreamController<String> _changeTelephoneStreamController = StreamController();

  /// Further details Text Submit Methods
  final StreamController<int> _submitStreamController = StreamController();

  /// Login Status Changed
  final StreamController<LogInState> _loginStatusChangedStreamController = StreamController();

  /// Defining Outputs from stream
  /// Stream ------------> Widgets
  Stream<int> get goToTabPageStream => _currentTabPageStream.stream;
  Stream<Null> get navigateToHomePageStream => _shouldNavigateToHomePageStream.stream;
  Stream<Map<String, dynamic>> get signUpStatusUpdateStream =>
      _signUpStatusUpdateStream.stream;

  /// Defining Outputs to stream
  /// Stream <------------ Widgets
  Sink<String> get changeFullNameSink => _changeFullNameStreamController.sink;
  Sink<String> get changeAddressSink => _changeAddressStreamController.sink;
  Sink<String> get changeTelephoneSink => _changeTelephoneStreamController.sink;
  Sink<int> get submitSink => _submitStreamController.sink;
  Sink<LogInState> get loginStatusChangedSink => _loginStatusChangedStreamController.sink;

  /// Further Detail Strings
  String _fullName;
  String _address;
  String _telephone;

  LoginBLoC() : super() {
    _emptyTexts(); // Empty all Texts
  }

  @override
  void streamConnect() async {
    /// Associates handlers to inputs to stream
    _changeFullNameStreamController.stream.listen(_handleFullNameChanged);
    _changeAddressStreamController.stream.listen(_handleAddressChanged);
    _changeTelephoneStreamController.stream.listen(_handleTelephoneChanged);
    _submitStreamController.stream.listen(_handleSubmitPressed);
    _loginStatusChangedStreamController.stream.listen(_handleLoginStatusChanged);
  }

  @override
  void dispose() {
    _signUpStatusUpdateStream.close();
    _loginStatusChangedStreamController.close();
    _changeFullNameStreamController.close();
    _changeAddressStreamController.close();
    _changeTelephoneStreamController.close();
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
    _emptyTexts();
  }

  /// Texts Submitted Handler
  void _handleSubmitPressed(int stage) {
    print(stage);
    if (stage == 0){
      _fullName = _fullName.trim();
      _address = _address.trim();
      _telephone = _telephone.trim();
      bool fullNameValid = _fullName.length != 0;
      bool addressValid = _address.length != 0;
      bool telephoneValid = _telephone.length != 0;

      if (fullNameValid && addressValid && telephoneValid) {
        _signUpStatusUpdateStream.add(<String, dynamic>{
          'telephone': _telephone,
          'fullName': _fullName,
          'address': _address
        });
        _currentTabPageStream.add(2);
        _emptyTexts();
      }
    }else if (stage == 1){
      _loginStatusChangedStreamController.add(LogInState.LOGGED);
    }

  }

  /// Text Changed Handlers
  void _handleFullNameChanged(s) => _fullName = s;
  void _handleAddressChanged(s) => _address = s;
  void _handleTelephoneChanged(s) => _telephone = s;

  /// Empty texts
  void _emptyTexts() {
    _fullName = "";
    _address = "";
    _telephone = "";
  }
}

import 'dart:async';

import 'package:dengue_app/bloc/bloc.dart';

import 'package:rxdart/subjects.dart';

enum LogInState { SIGNED_UP, NOT_LOGGED, WAITING, LOGGED }

class LoginBLoC extends BLoC {
  /// Issues the command to change Tab Page.
  final PublishSubject<int> _changeTabPage = PublishSubject();

  /// Issues the command to navigate to home page.
  /// Sends boolean to be used by [HomePage].
  /// null if no need to change page.
  /// *Remember to set to false after logging out.*
  final PublishSubject<bool> _navigateToHomePage = PublishSubject();

  final PublishSubject<Map<String, dynamic>> _signUpStatusUpdate =
      PublishSubject();

  /// Further details Text Change Methods
  final StreamController<String> _changeFullName = StreamController();
  final StreamController<String> _changeAddress = StreamController();
  final StreamController<String> _changeTelephone = StreamController();

  /// Further details Text Submit Methods
  final StreamController<Null> _submit = StreamController();

  /// Login Status Changed
  final StreamController<LogInState> _loginStatusChanged = StreamController();

  /// Defining Outputs from stream
  /// Stream ------------> Widgets
  Stream<int> get goToTabPage => _changeTabPage.stream;
  Stream<bool> get navigateToHomePage => _navigateToHomePage.stream;
  Stream<Map<String, dynamic>> get signUpStatusUpdate =>
      _signUpStatusUpdate.stream;

  /// Defining Outputs to stream
  /// Stream <------------ Widgets
  Sink<String> get changeFullName => _changeFullName.sink;
  Sink<String> get changeAddress => _changeAddress.sink;
  Sink<String> get changeTelephone => _changeTelephone.sink;
  Sink<Null> get submit => _submit.sink;
  Sink<LogInState> get loginStatusChanged => _loginStatusChanged.sink;

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
    _changeFullName.stream.listen(_handleFullNameChanged);
    _changeAddress.stream.listen(_handleAddressChanged);
    _changeTelephone.stream.listen(_handleTelephoneChanged);
    _submit.stream.listen((_) => _handleSubmitPressed());
    _loginStatusChanged.stream.listen(_handleLoginStatusChanged);
  }

  @override
  void dispose() {
    _signUpStatusUpdate.close();
    _loginStatusChanged.close();
    _changeFullName.close();
    _changeAddress.close();
    _changeTelephone.close();
    _submit.close();
    _changeTabPage.close();
    _navigateToHomePage.close();
  }

  /// Sign in command
  void _handleLoginStatusChanged(LogInState status) async {
    switch (status) {
      case LogInState.LOGGED:
        _navigateToHomePage.add(true);
        break;
      case LogInState.SIGNED_UP:
        _changeTabPage.add(1);
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
    _changeTabPage.add(0);
    _navigateToHomePage.add(false);
    _emptyTexts();
  }

  /// Texts Submitted Handler
  void _handleSubmitPressed() {
    _fullName = _fullName.trim();
    _address = _address.trim();
    _telephone = _telephone.trim();
    bool fullNameValid = _fullName.length != 0;
    bool addressValid = _address.length != 0;
    bool telephoneValid = _telephone.length != 0;

    if (fullNameValid && addressValid && telephoneValid) {
    _signUpStatusUpdate.add(<String, dynamic>{
      'telephone': _telephone,
      'fullName': _fullName,
      'address': _address
    });
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

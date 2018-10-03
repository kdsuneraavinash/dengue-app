import 'package:dengue_app/bloc/login_bloc.dart';
import 'package:flutter/widgets.dart';

class LoginBLoCProvider extends InheritedWidget {
  final LoginBLoC loginBLoC;

  LoginBLoCProvider({
    Key key,
    LoginBLoC loginBLoC,
    Widget child,
  })  : loginBLoC = loginBLoC ?? LoginBLoC(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBLoC of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(LoginBLoCProvider)
              as LoginBLoCProvider)
          .loginBLoC;
}

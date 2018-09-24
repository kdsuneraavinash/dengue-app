import 'package:dengue_app/bloc/login_bloc.dart';
import 'package:flutter/widgets.dart';

/// This is an InheritedWidget that wraps around [CartBloc]. Think about this
/// as Scoped Model for that specific class.
///
/// This merely solves the "passing reference down the tree" problem for us.
/// You can solve this in other ways, like through dependency injection.
///
/// Also note that this does not call [CartBloc.dispose]. If your app
/// ever doesn't need to access the cart, you should make sure it's
/// disposed of properly.
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

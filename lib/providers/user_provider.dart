import 'package:dengue_app/bloc/home_bloc.dart';
import 'package:dengue_app/bloc/login_bloc.dart';
import 'package:dengue_app/bloc/user_bloc.dart';
import 'package:flutter/widgets.dart';

class UserBLoCProvider extends InheritedWidget {
  final UserBLoC userBLoC;

  UserBLoCProvider({
    Key key,
    UserBLoC userBLoC,
    Widget child,
  })  : userBLoC = userBLoC ?? UserBLoC(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static UserBLoC of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(UserBLoCProvider)
              as UserBLoCProvider)
          .userBLoC;
}

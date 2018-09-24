import 'package:dengue_app/bloc/home_bloc.dart';
import 'package:dengue_app/bloc/login_bloc.dart';
import 'package:flutter/widgets.dart';

class HomeBLoCProvider extends InheritedWidget {
  final HomePageBLoC homeBLoC;

  HomeBLoCProvider({
    Key key,
    LoginBLoC loginBLoC,
    Widget child,
  })  : homeBLoC = loginBLoC ?? HomePageBLoC(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static HomePageBLoC of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(HomeBLoCProvider)
              as HomeBLoCProvider)
          .homeBLoC;
}

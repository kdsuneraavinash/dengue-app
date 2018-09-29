import 'package:dengue_app/bloc/home_bloc.dart';
import 'package:flutter/widgets.dart';

class HomePageBLoCProvider extends InheritedWidget {
  final HomePageBLoC homeBLoC;

  HomePageBLoCProvider({
    Key key,
    HomePageBLoC homeBLoC,
    Widget child,
  })  : homeBLoC = homeBLoC ?? HomePageBLoC(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static HomePageBLoC of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(HomePageBLoCProvider)
              as HomePageBLoCProvider)
          .homeBLoC;
}

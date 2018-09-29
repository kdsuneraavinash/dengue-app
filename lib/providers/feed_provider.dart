import 'package:dengue_app/bloc/feed_bloc.dart';
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
class FeedBLoCProvider extends InheritedWidget {
  final FeedBLoC feedBLoC;

  FeedBLoCProvider({
    Key key,
    FeedBLoC feedBLoC,
    Widget child,
  })  : feedBLoC = feedBLoC ?? FeedBLoC(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static FeedBLoC of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(FeedBLoCProvider)
              as FeedBLoCProvider)
          .feedBLoC;
}

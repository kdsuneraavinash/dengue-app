import 'package:dengue_app/bloc/feed_bloc.dart';
import 'package:flutter/widgets.dart';

class FeedPageBLoCProvider extends InheritedWidget {
  final FeedBLoC feedBLoC;

  FeedPageBLoCProvider({
    Key key,
    FeedBLoC feedBLoC,
    Widget child,
  })  : feedBLoC = feedBLoC ?? FeedBLoC(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static FeedBLoC of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(FeedPageBLoCProvider)
              as FeedPageBLoCProvider)
          .feedBLoC;
}

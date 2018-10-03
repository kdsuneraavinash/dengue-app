import 'package:dengue_app/custom_widgets/animations.dart';
import 'package:flutter/widgets.dart';

class FluttieAnimationsProvider extends InheritedWidget {
  final FluttieAnimations fluttieAnimations;

  FluttieAnimationsProvider({
    Key key,
    FluttieAnimations fluttieAnimations,
    Widget child,
  })  : fluttieAnimations = fluttieAnimations ?? FluttieAnimations(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static FluttieAnimations of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(FluttieAnimationsProvider)
              as FluttieAnimationsProvider)
          .fluttieAnimations;
}

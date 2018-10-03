import 'package:dengue_app/bloc/error_bloc.dart';
import 'package:flutter/widgets.dart';

class ErrorHandlerBLoCProvider extends InheritedWidget {
  final ErrorHandlerBLoC errorBLoC;

  ErrorHandlerBLoCProvider({
    Key key,
    ErrorHandlerBLoC errorBLoC,
    Widget child,
  })  : errorBLoC = errorBLoC ?? ErrorHandlerBLoC(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ErrorHandlerBLoC of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ErrorHandlerBLoCProvider)
              as ErrorHandlerBLoCProvider)
          .errorBLoC;
}

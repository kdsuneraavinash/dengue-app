import 'dart:async';

import 'package:dengue_app/bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class ErrorHandlerBLoC extends BLoC {
  final BehaviorSubject<Object> _exceptionStream = BehaviorSubject();
  Stream<Object> get exceptionStream => _exceptionStream.stream;
  Sink<Object> get exceptionSink => _exceptionStream.sink;

  @override
  void dispose() {
    _exceptionStream.close();
  }

  @override
  void streamConnect() {}
}

import 'dart:async';

import 'package:dengue_app/theme.dart' as Theme;
import 'package:dengue_app/ui/home.dart';
import 'package:flutter/material.dart';

Future<Null> main() async {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'We Care',
      theme: Theme.buildTheme(context),
      home: new HomePage(),
    );
  }
}

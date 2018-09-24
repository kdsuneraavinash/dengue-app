import 'dart:async';

import 'package:dengue_app/providers/home.dart';
import 'package:dengue_app/providers/login.dart';
import 'package:dengue_app/theme.dart' as Theme;
import 'package:dengue_app/ui/login.dart';
import 'package:flutter/material.dart';

Future<Null> main() async {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginBLoCProvider(
      child: HomeBLoCProvider(
        child: MaterialApp(
            title: 'We Care',
            theme: Theme.buildTheme(context),
            home: SignUpPage()),
      ),
    );
  }
}

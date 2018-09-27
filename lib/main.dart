import 'dart:async';

import 'package:dengue_app/logic/firebase/storage.dart';
import 'package:dengue_app/providers/home_provider.dart';
import 'package:dengue_app/providers/login_provider.dart';
import 'package:dengue_app/providers/user_provider.dart';
import 'package:dengue_app/theme.dart' as Theme;
import 'package:dengue_app/ui/login_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserBLoCProvider(
      child: MaterialApp(
          title: 'We Care',
          theme: Theme.buildTheme(context),
          home: LoginBLoCProvider(child: SignUpPage())),
    );
  }
}

final CloudStorage cloudStorage = CloudStorage();

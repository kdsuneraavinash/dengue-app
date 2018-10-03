import 'package:dengue_app/providers/fluttie_provider.dart';
import 'package:dengue_app/providers/user_provider.dart';
import 'package:dengue_app/theme.dart' as AppTheme;
import 'package:dengue_app/ui/login_ui.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FluttieAnimationsProvider(
      child: UserBLoCProvider(
        child: MaterialApp(
          title: 'Dengue Free Zone',
          theme: AppTheme.buildTheme(context),
          home: LoginPage(),
        ),
      ),
    );
  }
}

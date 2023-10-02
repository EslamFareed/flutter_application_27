import 'package:flutter/material.dart';
import 'package:flutter_application_27/screens/home_screen.dart';
import 'package:flutter_application_27/screens/login_screen.dart';
import 'package:overlay_support/overlay_support.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
        theme: ThemeData.dark(useMaterial3: true),
      ),
    );
  }
}

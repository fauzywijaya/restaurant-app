import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:submission_restaurant/screen/main_screen.dart';
import 'package:submission_restaurant/shared/theme.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() {
    var _duration = const Duration(seconds: 2);
    return Timer(_duration, navigationRoute);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  void navigationRoute() {
    Navigator.pushReplacementNamed(context, MainScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrad,
      body: Center(
        child: Image.asset('assets/restaurant.png'),
      ),
    );
  }
}

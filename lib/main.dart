import 'dart:async';

import 'package:eralp_software_task/animation.dart';
import 'package:eralp_software_task/login.dart';
import 'package:eralp_software_task/navigationBar/navigationBar.dart';
// ignore: unused_import
import 'package:eralp_software_task/navigationBar/screens/home.dart';
import 'package:eralp_software_task/value.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      1.2,
      Scaffold(
        body: Container(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Eralp",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: const Color(0xfff3963d),
                  ),
                ),
                Text(
                  "Software",
                  style: TextStyle(
                    fontSize: 35,
                    color: const Color(0xfffabd5e),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  startTimer() {
    Timer(Duration(seconds: 2), () {
      navigateUser();
    });
  }

  navigateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool("isLoggedIn") ?? false;

    if (status) {
      userToken = prefs.getString("token");
      uName = prefs.getString("username");
      userId = prefs.getString("userid");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => NavigationBar(0),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
        ),
      );
    }
  }
}

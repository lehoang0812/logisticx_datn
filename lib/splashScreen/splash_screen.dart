import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logisticx_datn/assistants/assistant_methods.dart';
import 'package:logisticx_datn/global/global.dart';
import 'package:logisticx_datn/screens/user_home_screen.dart';

import '../screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    Timer(Duration(seconds: 2), () async {
      if (await firebaseAuth.currentUser != null) {
        firebaseAuth.currentUser != null
            ? AssistantMethods.readCurrentOnlineUserInfo()
            : null;
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => UserHomeScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
        "LogisticX",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
            color: Colors.blue.shade400),
      )),
    );
  }
}

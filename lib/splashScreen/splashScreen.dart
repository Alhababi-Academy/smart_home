import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_extension/authentication/chooicPage.dart';
import 'package:smart_extension/home/homePage.dart';
import '../authentication/loginPage.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  //This is the first function to run
  @override
  void initState() {
    tempScreen();
    super.initState();
  }

  tempScreen() {
    Timer(const Duration(seconds: 3), () async {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const homePage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ChooicePage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0Xff271d3b),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: Image.asset(
                "images/2.png",
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

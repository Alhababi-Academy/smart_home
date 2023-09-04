import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_extension/authentication/loginPage.dart';
import 'package:smart_extension/home/updateProfile.dart';
import 'package:smart_extension/home/mainPage.dart';
import 'package:smart_extension/home/sendingData.dart';
import 'package:smart_extension/widgets/sharedPrefrences.dart';

class homePage extends StatefulWidget {
  const homePage({Key? Key}) : super(key: Key);
  _homePage createState() => _homePage();
}

class _homePage extends State<homePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _pages = [
    MainPage(),
    sendingData(),
    editProfile(),
  ];

  String name = configFile.sharedPreferences!.getString("name").toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF7e65bf),
        automaticallyImplyLeading: false,
        title: name.isNotEmpty ? Text(name.toString()) : null,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((result) {
                  Route route =
                      MaterialPageRoute(builder: (c) => const loginPage());
                  Navigator.pushReplacement(context, route);
                });
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: Material(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        selectedIconTheme: const IconThemeData(
          color: Color(0XFF7e65bf),
        ),
        selectedItemColor: Color(0XFF7e65bf),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'Saved Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

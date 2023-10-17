import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_extension/authentication/loginPage.dart';
import 'package:smart_extension/home/ControllData.dart';
import 'package:smart_extension/home/updateProfile.dart';
import 'package:smart_extension/home/mainPage.dart';
import 'package:smart_extension/widgets/sharedPrefrences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? Key}) : super(key: Key);
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _pages = [
    const MainPage(),
    const ControllData(),
    const editProfile(),
  ];

  String name = configFile.sharedPreferences!.getString("name").toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF7e65bf),
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
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Material(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0XFF7e65bf),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        unselectedItemColor: Colors.white60,
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        selectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
            ),
            label: "Controll Devices",
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

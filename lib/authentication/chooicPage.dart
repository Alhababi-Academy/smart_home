import 'package:flutter/material.dart';
import 'package:smart_extension/authentication/loginPage.dart';
import 'package:smart_extension/authentication/registerPage.dart';

class ChooicePage extends StatefulWidget {
  const ChooicePage({super.key});

  @override
  State<ChooicePage> createState() => _ChooicePageState();
}

class _ChooicePageState extends State<ChooicePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/extension.png"),
            ),
          ),
          child: Container(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  bottom: 50,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Route route = MaterialPageRoute(
                              builder: (_) => const RegisterPage());
                          Navigator.push(context, route);
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            const Color(0XFF7e65bf),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Text(
                            "Create Account",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Route route = MaterialPageRoute(
                              builder: (_) => const loginPage());
                          Navigator.push(context, route);
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            const Color(0XFF7e65bf),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Text(
                            "I have Account",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

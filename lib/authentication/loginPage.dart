import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_extension/DialogBox/errorDialog.dart';
import 'package:smart_extension/DialogBox/loadingDialog.dart';
import 'package:smart_extension/authentication/registerPage.dart';
import 'package:smart_extension/authentication/resetPassword.dart';
import 'package:smart_extension/home/homePage.dart';
import 'package:smart_extension/widgets/customTextFeild.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();

  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/2.png",
                width: 170,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Login Here",
                  style: TextStyle(
                    color: Color(0XFF7e65bf),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              customTextField(
                textEditingController: _emailTextEditingController,
                textInputType: TextInputType.text,
                icon: const Icon(
                  Icons.email,
                  color: Color(0XFF7e65bf),
                ),
                hint: "Email",
                isScure: false,
              ),
              customTextField(
                textEditingController: _passwordTextEditingController,
                textInputType: TextInputType.text,
                icon: const Icon(
                  Icons.lock,
                  color: Color(0XFF7e65bf),
                ),
                hint: "Password",
                isScure: true,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  loginIn();
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0XFF6382b0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Route route = MaterialPageRoute(
                          builder: (_) => const RegisterPage());
                      Navigator.push(context, route);
                    },
                    child: const Text(
                      "No account ? register",
                      style: TextStyle(
                        color: Color(0XFF7e65bf),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Route route =
                          MaterialPageRoute(builder: (_) => resetPassword());
                      Navigator.push(context, route);
                    },
                    child: const Text(
                      "Forget Password?",
                      style: TextStyle(
                        color: Color(0XFF7e65bf),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginIn() async {
    _emailTextEditingController.text.isNotEmpty &&
            _passwordTextEditingController.text.isNotEmpty
        ? uploadToStorage()
        : displayDialog("Plaese Fill up the Information");
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingAlertDialog(
            message: "Authenticating, Please Wait...",
          );
        });
    _login();
  }

  var currentUser;
  void _login() async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((auth) {
      currentUser = auth.user!.uid;
      saveUserInfo(currentUser);
    }).catchError(
      (error) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (c) => ErrorAlertDialog(
            message: error.toString(),
          ),
        );
      },
    );
  }

  saveUserInfo(String userAuth) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userAuth)
        .get()
        .then((result) async {
      // temp saving dat
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      sharedPreferences.setString("name", result.data()!['fullName']);
      Navigator.pop(context);
      Route route = MaterialPageRoute(builder: (context) => const homePage());
      Navigator.pushReplacement(context, route);
    });
  }
}

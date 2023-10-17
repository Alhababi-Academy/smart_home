import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_extension/DialogBox/errorDialog.dart';
import 'package:smart_extension/DialogBox/loadingDialog.dart';
import 'package:smart_extension/authentication/loginPage.dart';
import 'package:smart_extension/home/homePage.dart';
import 'package:smart_extension/widgets/customTextFeild.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();

  final TextEditingController _emailTextEditingController =
      TextEditingController();

  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  final TextEditingController _PhoneNumber = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // color: Colors.white,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                        child: Image.asset(
                          "images/smartHome.png",
                          width: 250,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Register Here",
                          style: TextStyle(
                            color: Color(0XFF4ce0d4),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      customTextField(
                        textEditingController: _nameTextEditingController,
                        textInputType: TextInputType.text,
                        icon: const Icon(
                          Icons.person,
                          color: Color(0XFF7e65bf),
                        ),
                        hint: "Full Name",
                        isScure: false,
                      ),
                      customTextField(
                        textInputType: TextInputType.emailAddress,
                        textEditingController: _emailTextEditingController,
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
                      customTextField(
                        textEditingController: _PhoneNumber,
                        textInputType: TextInputType.text,
                        icon: const Icon(
                          Icons.phone,
                          color: Color(0XFF7e65bf),
                        ),
                        hint: "Phone Number",
                        isScure: false,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          uploadAndSaveImage();
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            const Color(
                              0XFF4ce0d4,
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Text(
                            "Register Here",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Route route = MaterialPageRoute(
                              builder: (_) => const loginPage());
                          Navigator.push(context, route);
                        },
                        child: const Text(
                          "No account ? Login",
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
        ),
      ),
    );
  }

  uploadAndSaveImage() async {
    _emailTextEditingController.text.isNotEmpty &&
            _nameTextEditingController.text.isNotEmpty &&
            _passwordTextEditingController.text.isNotEmpty &&
            _PhoneNumber.text.isNotEmpty
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
            message: "Saving Data, Please Wait...",
          );
        });
    _registring();
  }

  var zzzzz;
  void _registring() async {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((auth) {
      zzzzz = auth.user!.uid;
      saveUserInfo(zzzzz);
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) => ErrorAlertDialog(
          message: "check",
        ),
      );
    });
  }

  Future saveUserInfo(String currentUser) async {
    await FirebaseFirestore.instance.collection("users").doc(currentUser).set({
      "uid": currentUser.toString(),
      "email": _emailTextEditingController.text.trim(),
      "fullName": _nameTextEditingController.text.trim(),
      "phoneNumber": _PhoneNumber.text.trim(),
      "RegistredTime": DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        "name", _nameTextEditingController.text.toString());
    Navigator.pop(context);
    Route route = MaterialPageRoute(builder: (context) => const HomePage());
    Navigator.pushReplacement(context, route);
  }
}

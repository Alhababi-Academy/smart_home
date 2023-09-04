import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_extension/DialogBox/errorDialog.dart';
import 'package:smart_extension/DialogBox/loadingDialog.dart';
import 'package:smart_extension/widgets/customTextFeild.dart';

class resetPassword extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _emailTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xfff6f6f6),
      appBar: AppBar(
        backgroundColor: const Color(0XFF7e65bf),
        title: const Text("Updating Password"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "images/2.png",
                        width: MediaQuery.of(context).size.width * 0.6,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Column(
                    children: [
                      const Text(
                        "Reset Password",
                        style: TextStyle(
                            color: Color(0XFF7e65bf),
                            fontSize: 27,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            customTextField(
                              textEditingController:
                                  _emailTextEditingController,
                              textInputType: TextInputType.text,
                              icon: const Icon(
                                Icons.email,
                                color: Color(0XFF7e65bf),
                              ),
                              hint: "Email",
                              isScure: false,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            checkIfEmailIsEmpty(context);
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Text(
                              "Reset Password",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  checkIfEmailIsEmpty(BuildContext context) {
    _emailTextEditingController.text.isNotEmpty
        ? resetPasswordFun(context)
        : showDialog(
            context: context,
            builder: (_) => const ErrorAlertDialog(message: "Please Put Email"),
          );
  }

  resetPasswordFun(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const LoadingAlertDialog(
        message: "Reseting Password",
      ),
    );
    resetingPassword(context);
  }

  resetingPassword(context) {
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailTextEditingController.text.trim())
        .then(
      (value) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) => const ErrorAlertDialog(message: "Email were sent"),
        );
      },
    ).catchError(
      (error) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) => const ErrorAlertDialog(
              message: "Please make sure the email is corect"),
        );
      },
    );
  }
}

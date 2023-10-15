import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_extension/DialogBox/errorDialog.dart';
import 'package:smart_extension/DialogBox/loadingDialog.dart';
import 'package:smart_extension/widgets/customTextFeild.dart';

class editProfile extends StatefulWidget {
  const editProfile({Key? key}) : super(key: key);

  @override
  _editProfile createState() => _editProfile();
}

class _editProfile extends State<editProfile> {
  User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    gettingData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Getting Data
  Future gettingData() async {
    String uid = user!.uid;

    var result =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (result != null) {
      _nameTextEditingController.text = result.data()?['fullName'];
      // _emailTextEditingController.text = result.data()!['email'];
      _phoneNumber.text = result.data()!['phoneNumber'];
      // _emailTextEditingController.text = result.data()!['email'];
    } else {
      print("Sorry There is no Data");
    }
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SingleChildScrollView(
          child: Material(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Edit Information",
                          style: TextStyle(
                              color: Color(0XFF7e65bf),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontSize: 25),
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
                          textEditingController: _phoneNumber,
                          textInputType: TextInputType.text,
                          icon: const Icon(
                            Icons.phone,
                            color: Color(0XFF7e65bf),
                          ),
                          hint: "Phone Number",
                          isScure: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      uploadToStorage();
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                      child: Text(
                        "Update Profile",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) {
          return const LoadingAlertDialog(
            message: "Updating Data...",
          );
        });
    updatingData();
  }

  Future updatingData() async {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "fullName": _nameTextEditingController.text.trim(),
      "phoneNumber": _phoneNumber.text.trim(),
    }).then((value) {
      Navigator.pop(context);
    }).then((value) {
      showDialog(
          context: context,
          builder: (_) => ErrorAlertDialog(
                message: "Data was updated",
              ));
    });
  }
}

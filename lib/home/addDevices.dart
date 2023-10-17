import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_extension/DialogBox/errorDialog.dart';
import 'package:smart_extension/DialogBox/loadingDialog.dart';
import 'package:smart_extension/widgets/customTextFeild.dart';

class AddingDevice extends StatefulWidget {
  const AddingDevice({Key? key});

  @override
  _AddingDevice createState() => _AddingDevice();
}

class _AddingDevice extends State<AddingDevice> {
  TextEditingController _deviceName = TextEditingController();
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adding Device"),
        centerTitle: true,
        backgroundColor: const Color(
          0XFF7e65bf,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset(
                "images/extension.png",
                width: 500,
              ),
              customTextField(
                textEditingController: _deviceName,
                textInputType: TextInputType.text,
                icon: const Icon(
                  Icons.phone_iphone,
                  color: Color(0XFF7e65bf),
                ),
                hint: "Device Name",
                isScure: false,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0XFF7e65bf),
                  ),
                ),
                onPressed: () {
                  controlExtension();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Text(
                    "Save Device",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void controlExtension() {
    int index = 0;
    DatabaseReference ref =
        databaseReference.child('Devices').child("Devices${index++}");
    showDialog(
      context: context,
      builder: (_) => const LoadingAlertDialog(
        message: "Adding Device",
      ),
    );

    ref.set({
      "Device${index}",
    }).then((value) {
      showDialog(
        context: context,
        builder: (_) => const ErrorAlertDialog(
          message: "Device was Added Successfully",
        ),
      );
    });
  }
}

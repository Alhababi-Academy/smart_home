import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as dateFixing;
import 'package:smart_extension/DialogBox/loadingDialog.dart';
import 'package:smart_extension/home/CircleProgress.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> with SingleTickerProviderStateMixin {
  User? user = FirebaseAuth.instance.currentUser;
  final databaseReference = FirebaseDatabase.instance.ref();

  Timer? timer;
  int? hum;
  int? temp;
  String? extenstion;

  checkForNewSharedLists(int hum, int temp, String extenstion) {
    if (extenstion == "ON") {
      Timer.periodic(
        const Duration(days: 1),
        (timer) async {
          await FirebaseFirestore.instance.collection("data").add({
            "uid": user!.uid,
            "temp": temp,
            "hum": hum,
            "extenstion": extenstion,
            "date": dateFixing.DateFormat("dd-MM-yyyy")
                .format(DateTime.now())
                .toString(),
          });
        },
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Flexible(
            child: Container(
              height: MediaQuery.of(context).size.height,
              // This is to call data
              child: StreamBuilder(
                stream: databaseReference.onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      (snapshot.data!).snapshot.value != null) {
                    final allData = Map<dynamic, dynamic>.from((snapshot.data!)
                        .snapshot
                        .value as Map<dynamic, dynamic>); //typecasting
                    String hum = allData['Devices']['Device1']['status'];

                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: 1,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            // if (gettingTheCuerrentUser != user!.uid) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(),
                                      Text("Device 1"),
                                      Text(
                                        "OFF",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(),
                                      Text("Device 2"),
                                      Text(
                                        "ON",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(),
                                      Text("Device 3"),
                                      Text(
                                        "ON",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'Loading Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  controlExtension(String exten) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    showDialog(
      context: context,
      builder: (_) => const LoadingAlertDialog(
        message: "Updateing",
      ),
    );
    await ref.update({
      "extension": exten == "OFF" ? "ON" : "OFF",
    }).then((value) {
      Navigator.pop(context);
    });
  }
}

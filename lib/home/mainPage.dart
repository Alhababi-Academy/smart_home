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
                    int hum = allData['hum'];
                    int temp = allData['temp'];
                    String extenstion = allData['extension'];

                    if (temp.toString().isNotEmpty) {
                      checkForNewSharedLists(hum, temp, extenstion);
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: ListView.builder(
                            itemCount: 1,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              // if (gettingTheCuerrentUser != user!.uid) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("The Extension is: "),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: extenstion == "OFF"
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                        child: Text(
                                          extenstion.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomPaint(
                                    foregroundPainter:
                                        CircleProgress(temp, true, false),
                                    child: SizedBox(
                                      width: 170,
                                      height: 170,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            const Text('Temperature'),
                                            Text(
                                              '${allData['temp']}',
                                              style: const TextStyle(
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Text(
                                              '°C',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  CustomPaint(
                                    foregroundPainter:
                                        CircleProgress(hum, false, false),
                                    child: SizedBox(
                                      width: 170,
                                      height: 170,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            const Text('Humidity'),
                                            Text(
                                              allData['hum'].toString(),
                                              style: const TextStyle(
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Text(
                                              '%',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  ElevatedButton(
                                    onPressed: () {
                                      controlExtension(extenstion);
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        const Color(0XFF6382b0),
                                      ),
                                    ),
                                    child: extenstion == "OFF"
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 15),
                                            child: const Text(
                                              "Turn ON",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 15),
                                            child: const Text(
                                              "Turn OFF",
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                  ),
                                  // CustomPaint(
                                  //   foregroundPainter:
                                  //       CircleProgress(soil.abs(), false, true),
                                  //   child: SizedBox(
                                  //     width: 200,
                                  //     height: 200,
                                  //     child: Center(
                                  //       child: Column(
                                  //         mainAxisAlignment: MainAxisAlignment.center,
                                  //         children: <Widget>[
                                  //           const Text('Soil Level'),
                                  //           Text(
                                  //             soil.abs().toString(),
                                  //             style: const TextStyle(
                                  //                 fontSize: 50,
                                  //                 fontWeight: FontWeight.bold),
                                  //           ),
                                  //           const Text(
                                  //             '',
                                  //             style: TextStyle(
                                  //                 fontSize: 20,
                                  //                 fontWeight: FontWeight.bold),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              );
                            },
                          ),
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

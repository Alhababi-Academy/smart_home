import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_extension/DialogBox/loadingDialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key});

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        // This is to call data from firebase
        child: StreamBuilder(
          stream: databaseReference.child('Devices').onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.snapshot.value != null) {
              final Map<dynamic, dynamic> deviceData =
                  (snapshot.data!.snapshot.value as Map<dynamic, dynamic>);

              return ListView.builder(
                itemCount: deviceData.length,
                itemBuilder: (context, index) {
                  final deviceName = deviceData.keys.elementAt(index);
                  final status =
                      deviceData[deviceName]['Status'] as String? ?? 'OFF';
                  final isOn = status == "ON";

                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isOn ? Colors.green : Colors.red,
                        child: Text(
                          isOn ? "ON" : "OFF",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(deviceName),
                      trailing: ElevatedButton(
                        onPressed: () {
                          controlExtension(deviceName, isOn);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOn ? Colors.red : Colors.green,
                        ),
                        child: Text(isOn ? "Turn OFF" : "Turn ON"),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child:
                    CircularProgressIndicator(), // Display a loading indicator.
              );
            }
          },
        ),
      ),
    );
  }

  void controlExtension(String deviceName, bool isOn) {
    DatabaseReference ref =
        databaseReference.child('Devices').child(deviceName);
    showDialog(
      context: context,
      builder: (_) => const LoadingAlertDialog(
        message: "Updating",
      ),
    );

    final newStatus = isOn ? "OFF" : "ON";

    ref.update({
      'Status': newStatus,
    }).then((value) {
      Navigator.pop(context);
    });
  }
}

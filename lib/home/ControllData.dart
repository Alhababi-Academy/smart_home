import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_extension/DialogBox/errorDialog.dart';
import 'package:smart_extension/DialogBox/loadingDialog.dart';
import 'package:smart_extension/home/addDevices.dart';

class ControllData extends StatefulWidget {
  const ControllData({Key? key});

  @override
  _ControllData createState() => _ControllData();
}

class _ControllData extends State<ControllData> {
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Route route = MaterialPageRoute(builder: (_) => const AddingDevice());
          Navigator.push(context, route);
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
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
                          controlExtension(deviceName);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOn ? Colors.red : Colors.green,
                        ),
                        child: const Text("Delete Device"),
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

  void controlExtension(String deviceName) {
    DatabaseReference ref =
        databaseReference.child('Devices').child(deviceName);
    showDialog(
      context: context,
      builder: (_) => const LoadingAlertDialog(
        message: "Deleting Device",
      ),
    );
    // ref.remove().then(
    //   (value) {
    //     showDialog(
    //       context: context,
    //       builder: (_) => ErrorAlertDialog(
    //         message: "$deviceName was deleted successfully",
    //       ),
    //     );
    //   },
    // );
  }
}

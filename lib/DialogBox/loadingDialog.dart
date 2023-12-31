import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_extension/widgets/loadingWidget.dart';

class LoadingAlertDialog extends StatelessWidget {
  final String? message;
  const LoadingAlertDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          circularProgress(),
          SizedBox(
            height: 10,
          ),
          Text(message!),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> CustomShowMyDialog(
  BuildContext context,
  String title,
  String message,
  Function()? onPressed,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok',
                style: TextStyle(color: CupertinoColors.activeBlue)),
            onPressed: onPressed,
          ),
        ],
      );
    },
  );
}

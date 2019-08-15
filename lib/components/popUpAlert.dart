import 'package:flutter/material.dart';

class PopUpAlert {
  static showAlert(
      BuildContext context, String title, String body, String buttonText) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(buttonText),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

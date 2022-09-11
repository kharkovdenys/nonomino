import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nonomino/services/constants.dart';

error(String str, context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(tr('error'), style: txtstyle)),
          content: Center(child: Text(str, style: txtstyle)),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(tr('Close')),
            ),
          ],
        );
      });
}

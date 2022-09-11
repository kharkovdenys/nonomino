import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nonomino/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

settingsSudoku(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String locate = (prefs.getString('locate') ?? 'en');
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Center(child: Text(tr('Settings'), style: txtstyle)),
            content: Center(
                child: Row(children: [
              Text(tr('Localization selection')),
              DropdownButton<String>(
                value: locate,
                items: <String>['en', 'uk']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    locate = value!;
                  });
                },
              )
            ])),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(tr('Close')),
              ),
              ElevatedButton(
                onPressed: () async {
                  await prefs.setString('locate', locate);
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => context.setLocale(locate.toLocale()));
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => Navigator.pop(context));
                },
                child: Text(tr('Save')),
              ),
            ],
          );
        });
      });
}

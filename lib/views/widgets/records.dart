import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nonomino/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

getRecords(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int timeEasy = (prefs.getInt('timeEasy') ?? -1);
  String records = '';
  timeEasy != -1
      ? records +=
          '${tr('easy')}\n${tr('time')} ${((timeEasy / 60).truncate()).toString().padLeft(2, '0')}:${(timeEasy % 60).toString().padLeft(2, '0')}\n'
      : records += '${tr('easy')}\n${tr('noRecord')}\n';
  int timeMedium = (prefs.getInt('timeMedium') ?? -1);
  timeMedium != -1
      ? records +=
          '${tr('medium')}\n${tr('time')} ${((timeMedium / 60).truncate()).toString().padLeft(2, '0')}:${(timeMedium % 60).toString().padLeft(2, '0')}\n'
      : records += '${tr('medium')}\n${tr('noRecord')}\n';
  int timeHard = (prefs.getInt('timeHard') ?? -1);
  timeHard != -1
      ? records +=
          '${tr('hard')}\n${tr('time')} ${((timeHard / 60).truncate()).toString().padLeft(2, '0')}:${(timeHard % 60).toString().padLeft(2, '0')}\n'
      : records += '${tr('hard')}\n${tr('noRecord')}\n';
  int timeExpert = (prefs.getInt('timeExpert') ?? -1);
  timeExpert != -1
      ? records +=
          '${tr('expert')}\n${tr('time')} ${((timeExpert / 60).truncate()).toString().padLeft(2, '0')}:${(timeExpert % 60).toString().padLeft(2, '0')}\n'
      : records += '${tr('expert')}\n${tr('noRecord')}\n';
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(tr('Records'), style: txtstyle)),
          content: Center(child: Text(records, style: txtstyle)),
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

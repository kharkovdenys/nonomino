import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nonomino/views/screens/game.dart';
import 'package:shared_preferences/shared_preferences.dart';

void rerecords(int gametime) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (typegame == 0) {
    int timeEasy = (prefs.getInt('timeEasy') ?? -1);
    if (timeEasy == -1) {
      await prefs.setInt('timeEasy', gametime);
    } else {
      if (timeEasy > gametime) {
        await prefs.setInt('timeEasy', gametime);
      }
    }
  } else if (typegame == 1) {
    int timeMedium = (prefs.getInt('timeMedium') ?? -1);
    if (timeMedium == -1) {
      await prefs.setInt('timeMedium', gametime);
    } else {
      if (timeMedium > gametime) {
        await prefs.setInt('timeMedium', gametime);
      }
    }
  } else if (typegame == 2) {
    int timeHard = (prefs.getInt('timeHard') ?? -1);
    if (timeHard == -1) {
      await prefs.setInt('timeHard', gametime);
    } else {
      if (timeHard > gametime) {
        await prefs.setInt('timeHard', gametime);
      }
    }
  } else {
    int timeExpert = (prefs.getInt('timeExpert') ?? -1);
    if (timeExpert == -1) {
      await prefs.setInt('timeExpert', gametime);
    } else {
      if (timeExpert > gametime) {
        await prefs.setInt('timeExpert', gametime);
      }
    }
  }
}

victory(context, stopTimer, gametime) {
  stopTimer();
  rerecords(gametime);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(tr('congratulations')),
        content: Text(
            '${tr('win')}\n${tr('time')} ${((gametime / 60).truncate()).toString().padLeft(2, '0')}:${(gametime % 60).toString().padLeft(2, '0')}'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/game');
            },
            child: Text(tr('restart')),
          ),
        ],
      );
    },
  );
}

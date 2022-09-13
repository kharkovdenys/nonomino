import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nonomino/services/constants.dart';
import 'package:nonomino/views/screens/game.dart';

newGame(context) {
  showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Center(child: Text(tr('choice'))),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                typegame = 0;
                Navigator.pushReplacementNamed(context, '/game');
              },
              child: Center(child: Text(tr('easy'), style: txtstyle)),
            ),
            SimpleDialogOption(
              onPressed: () {
                typegame = 1;
                Navigator.pushReplacementNamed(context, '/game');
              },
              child: Center(child: Text(tr('medium'), style: txtstyle)),
            ),
            SimpleDialogOption(
              onPressed: () {
                typegame = 2;
                Navigator.pushReplacementNamed(context, '/game');
              },
              child: Center(child: Text(tr('hard'), style: txtstyle)),
            ),
            SimpleDialogOption(
              onPressed: () {
                typegame = 3;
                Navigator.pushReplacementNamed(context, '/game');
              },
              child: Center(child: Text(tr('expert'), style: txtstyle)),
            )
          ],
        );
      });
}

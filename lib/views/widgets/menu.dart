import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nonomino/services/constants.dart';
import 'package:nonomino/views/screens/game.dart';
import 'package:nonomino/views/widgets/records.dart';
import 'package:nonomino/views/widgets/setting.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFFFFFFFF),
        child: SimpleDialog(
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
            ),
            SimpleDialogOption(
              onPressed: () {
                getRecords(context);
              },
              child: Center(child: Text(tr('Records'), style: txtstyle)),
            ),
            SimpleDialogOption(
              onPressed: () {
                settingsSudoku(context);
              },
              child: Center(child: Text(tr('Settings'), style: txtstyle)),
            ),
          ],
        ));
  }
}

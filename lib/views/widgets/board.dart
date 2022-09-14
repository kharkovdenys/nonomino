import 'package:flutter/material.dart';
import 'package:nonomino/services/constants.dart';
import 'package:nonomino/services/generation.dart';
import 'package:nonomino/services/size_config.dart';
import 'package:nonomino/views/screens/game.dart';

createBoard(i, changeIndex) {
  return GridView.count(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 9,
      children: valueArg.map((int value) {
        int key = i++;
        String textBox = '';
        Widget it;
        if (valueStatic[key] == 0) {
          if (value != 0) {
            textBox = value.toString();
          }
          it = boardNote[key].isNotEmpty()
              ? GridView.count(crossAxisCount: 3, children: [
                  for (int i = 1; i <= 9; i++)
                    Center(
                        child: Text(
                            boardNote[key].value(i) ? i.toString() : ' ',
                            style: TextStyle(
                                fontSize: 9.0.toFont, color: Colors.black)))
                ])
              : Text(
                  textBox,
                  style: TextStyle(fontSize: 28.toFont, color: Colors.black),
                );
        } else {
          it = Text(valueStatic[key].toString(),
              style: TextStyle(
                  fontSize: 28.0.toFont, color: const Color(0xFF595959)));
        }
        double widthTop = (key / 9).floor() == 0 || board[key] != board[key - 9]
                ? 1.3.toWidth
                : 0.5.toWidth,
            widthBottom = (key / 9).floor() == 8 ? 1.3.toWidth : 0,
            widthLeft = key % 9 == 0 || board[key] != board[key - 1]
                ? 1.3.toWidth
                : 0.5.toWidth,
            widthRight = key % 9 == 8 ? 1.3.toWidth : 0;
        return GestureDetector(
            child: Container(
                decoration: BoxDecoration(
                    color: index == key
                        ? nonominoColors[board[key]].withOpacity(0.7)
                        : nonominoColors[board[key]],
                    border: Border(
                        top: BorderSide(width: widthTop, color: Colors.black),
                        left: BorderSide(width: widthLeft, color: Colors.black),
                        right:
                            BorderSide(width: widthRight, color: Colors.black),
                        bottom: BorderSide(
                            width: widthBottom, color: Colors.black))),
                child: Center(
                  child: it,
                )),
            onTap: () => changeIndex(key));
      }).toList());
}

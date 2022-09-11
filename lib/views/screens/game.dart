import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nonomino/classes/note.dart';
import 'package:nonomino/services/auto_solver.dart';
import 'package:nonomino/services/constants.dart';
import 'package:nonomino/services/generation.dart';
import 'package:nonomino/services/size_config.dart';
import 'package:nonomino/views/widgets/records.dart';
import 'package:nonomino/views/widgets/setting.dart';
import 'package:nonomino/views/widgets/shortcuts.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Note> boardNote = [];
int index = -1;
Color notes = const Color(0xd56aeaee);
bool notesState = false;
int typegame = 0, _gametime = 0;
List<int> valueArg = [], valueStatic = List.filled(81, 0, growable: false);
bool _isStart = false;

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class NumbersButton extends StatelessWidget {
  final Function(int) tapNumber;
  final int number;
  final Size screenSize;
  const NumbersButton({
    Key? key,
    required this.screenSize,
    required this.tapNumber,
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: screenSize.width / 12,
        height: screenSize.height / 7,
        child: GestureDetector(
          child: Center(
              child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xd56aeaee),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: screenSize.width / 12 * 0.8,
                  height: screenSize.height / 7 * 0.8,
                  child: Center(
                      child: Text(
                    number.toString(),
                    style: TextStyle(fontSize: 24.toFont, color: Colors.black),
                  )))),
          onTap: () {
            tapNumber(number);
          },
        ));
  }
}

class _GameScreenState extends State<GameScreen> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    startTimer() {
      timer = Timer.periodic(
          const Duration(seconds: 1), (_) => setState(() => _gametime++));
    }

    stopTimer() {
      setState(() => timer?.cancel());
    }

    win() {
      stopTimer();
      rerecords(_gametime);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(tr('congratulations')),
            content: Text(
                '${tr('win')}\n${tr('time')} ${((_gametime / 60).truncate()).toString().padLeft(2, '0')}:${(_gametime % 60).toString().padLeft(2, '0')}'),
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

    Size screenSize = MediaQuery.of(context).size;
    if (_isStart == false) {
      boardNote.clear();
      for (int i = 0; i < 81; i++) {
        boardNote.add(Note());
      }
      notes = const Color(0xd56aeaee);
      notesState = false;
      _gametime = 0;
      index = -1;
      valueArg = [];
      valueStatic = List.filled(81, 0, growable: false);
      int ready = knownNumbers[typegame];
      bool flag = true;
      while (flag) {
        buildBoard();
        List<int> notUsed = [];
        for (int i = 1; i < 10; i++) {
          notUsed.add(i);
        }
        for (int i = 0; i < 81; i++) {
          if (board[i] == 1) {
            int randIndex = rand.nextInt(notUsed.length);
            valueStatic[i] = notUsed[randIndex];
            notUsed.removeAt(randIndex);
          }
        }
        countIter = 0;
        longSolve = false;
        bool solver = sudokuSolver(valueStatic, 0, 0);
        if (solver) {
          flag = false;
        } else {
          valueStatic = List.filled(81, 0, growable: false);
        }
      }
      List<int> allInd = [];
      for (int i = 0; i < 81; i++) {
        allInd.add(i);
      }
      List<int> randomInd = [];
      for (int i = 0; i < ready; i++) {
        int randIndex = rand.nextInt(allInd.length);
        randomInd.add(allInd[randIndex]);
        allInd.removeAt(randIndex);
      }
      valueArg = List.filled(81, 0, growable: false);
      for (int element in randomInd) {
        valueArg[element] = valueStatic[element];
      }
      for (int i = 0; i < 81; i++) {
        valueStatic[i] = valueArg[i];
      }
      startTimer();
      _isStart = true;
    }

    tapNumber(int number) {
      if (index != -1 && valueStatic[index] == 0) {
        if (!notesState) {
          setState(() {
            boardNote[index].clear();
            valueArg[index] = number;
          });
          if (!isSolver) {
            bool all = true;
            for (int i = 0; i < 81; i++) {
              if (valueArg[i] == 0) {
                all = false;
                break;
              }
            }
            if (all) {
              bool correct = correctBoard();
              if (correct) {
                win();
              }
            }
          }
        } else {
          if (number == 0) {
            setState(() {
              boardNote[index].clear();
              valueArg[index] = number;
            });
          } else {
            if (valueArg[index] == 0) {
              setState(() {
                boardNote[index].add(number);
              });
            }
          }
        }
      }
    }

    newGame() {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Center(child: Text(tr('choice'))),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    typegame = 0;
                    stopTimer();
                    Navigator.pushReplacementNamed(context, '/game');
                  },
                  child: Center(child: Text(tr('easy'), style: txtstyle)),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    typegame = 1;
                    stopTimer();
                    Navigator.pushReplacementNamed(context, '/game');
                  },
                  child: Center(child: Text(tr('medium'), style: txtstyle)),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    typegame = 2;
                    stopTimer();
                    Navigator.pushReplacementNamed(context, '/game');
                  },
                  child: Center(child: Text(tr('hard'), style: txtstyle)),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    typegame = 3;
                    stopTimer();
                    Navigator.pushReplacementNamed(context, '/game');
                  },
                  child: Center(child: Text(tr('expert'), style: txtstyle)),
                )
              ],
            );
          });
    }

    toggleNotes() {
      setState(() {
        if (notesState) {
          notesState = false;
          notes = const Color(0xd56aeaee);
        } else {
          notesState = true;
          notes = const Color(0xff2d6072);
        }
      });
    }

    moveSelect(int i) {
      setState(() {
        if (index == -1) {
          index = 0;
        } else {
          if (i == 0) {
            if ((index / 9).floor() != 0) {
              index -= 9;
            }
          } else if (i == 1) {
            if ((index / 9).floor() != 8) {
              index += 9;
            }
          } else if (i == 2) {
            if (index % 9 != 0) {
              index -= 1;
            }
          } else if (index % 9 != 8) {
            index += 1;
          }
        }
      });
    }

    int i = 0;
    return ShortcutsScaffold(
        getRecords: () {
          getRecords(context);
        },
        moveSelect: (int move) {
          moveSelect(move);
        },
        newGame: () {
          newGame();
        },
        settingsSudoku: () {
          settingsSudoku(context);
        },
        tapNumber: (int number) {
          tapNumber(number);
        },
        toggleNotes: () {
          toggleNotes();
        },
        child: Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            body: Row(children: [
              SizedBox(
                width: screenSize.width / 12,
              ),
              SizedBox(
                  width: screenSize.width / 12 * 6,
                  child: Center(
                      child: SizedBox(
                          width: (min(screenSize.width / 12 * 6,
                                          screenSize.height) /
                                      9)
                                  .truncate() *
                              9,
                          height: (min(screenSize.width / 12 * 6,
                                          screenSize.height) /
                                      9)
                                  .truncate() *
                              9,
                          child: GridView.count(
                            crossAxisCount: 9,
                            children: valueArg.map((int value) {
                              int key = i++;
                              String textBox = '';
                              Widget it;
                              if (valueStatic[key] == 0) {
                                if (value != 0) {
                                  textBox = value.toString();
                                }
                                it = Text(
                                  textBox,
                                  style: TextStyle(
                                      fontSize: 32.toFont, color: Colors.black),
                                );
                                if (boardNote[key].isNotEmpty()) {
                                  it = GridView.count(
                                      crossAxisCount: 3,
                                      children: [
                                        Center(
                                            child: Text(
                                                boardNote[key].one == true
                                                    ? '1'
                                                    : ' ',
                                                style: TextStyle(
                                                    fontSize: 9.0.toFont,
                                                    color: Colors.black))),
                                        Center(
                                            child: Text(
                                                boardNote[key].two == true
                                                    ? '2'
                                                    : ' ',
                                                style: TextStyle(
                                                    fontSize: 9.toFont,
                                                    color: Colors.black))),
                                        Center(
                                            child: Text(
                                                boardNote[key].three == true
                                                    ? '3'
                                                    : ' ',
                                                style: TextStyle(
                                                    fontSize: 9.toFont,
                                                    color: Colors.black))),
                                        Center(
                                            child: Text(
                                                boardNote[key].four == true
                                                    ? '4'
                                                    : ' ',
                                                style: TextStyle(
                                                    fontSize: 9.toFont,
                                                    color: Colors.black))),
                                        Center(
                                            child: Text(
                                                boardNote[key].five == true
                                                    ? '5'
                                                    : ' ',
                                                style: TextStyle(
                                                    fontSize: 9.toFont,
                                                    color: Colors.black))),
                                        Center(
                                            child: Text(
                                                boardNote[key].six == true
                                                    ? '6'
                                                    : ' ',
                                                style: TextStyle(
                                                    fontSize: 9.toFont,
                                                    color: Colors.black))),
                                        Center(
                                            child: Text(
                                                boardNote[key].seven == true
                                                    ? '7'
                                                    : ' ',
                                                style: TextStyle(
                                                    fontSize: 9.toFont,
                                                    color: Colors.black))),
                                        Center(
                                            child: Text(
                                                boardNote[key].eight == true
                                                    ? '8'
                                                    : ' ',
                                                style: TextStyle(
                                                    fontSize: 9.toFont,
                                                    color: Colors.black))),
                                        Center(
                                            child: Text(
                                                boardNote[key].nine == true
                                                    ? '9'
                                                    : ' ',
                                                style: TextStyle(
                                                    fontSize: 9.toFont,
                                                    color: Colors.black)))
                                      ]);
                                }
                              } else {
                                it = Text(valueStatic[key].toString(),
                                    style: TextStyle(
                                        fontSize: 32.0.toFont,
                                        color: const Color(0xFF595959)));
                              }
                              Color tempColor = nonominoColors[board[key]];

                              if (index == key) {
                                tempColor = tempColor.withOpacity(0.7);
                              }
                              double widthTop = screenSize.width / 1000,
                                  widthBottom = screenSize.width / 1000,
                                  widthLeft = screenSize.width / 1000,
                                  widthRight = screenSize.width / 1000;

                              if ((key / 9).floor() == 0) {
                                widthTop = screenSize.width / 250;
                              } else if (board[key] != board[key - 9]) {
                                widthTop = screenSize.width / 500;
                              }
                              if ((key / 9).floor() == 8) {
                                widthBottom = screenSize.width / 250;
                              } else if (board[key] != board[key + 9]) {
                                widthBottom = screenSize.width / 500;
                              }
                              if (key % 9 == 0) {
                                widthLeft = screenSize.width / 250;
                              } else if (board[key] != board[key - 1]) {
                                widthLeft = screenSize.width / 500;
                              }
                              if (key % 9 == 8) {
                                widthRight = screenSize.width / 250;
                              } else if (board[key] != board[key + 1]) {
                                widthRight = screenSize.width / 500;
                              }
                              return GestureDetector(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: tempColor,
                                          border: Border(
                                              top: BorderSide(
                                                  width: widthTop,
                                                  color: Colors.black),
                                              left: BorderSide(
                                                  width: widthLeft,
                                                  color: Colors.black),
                                              right: BorderSide(
                                                  width: widthRight,
                                                  color: Colors.black),
                                              bottom: BorderSide(
                                                  width: widthBottom,
                                                  color: Colors.black))),
                                      child: Center(
                                        child: it,
                                      )),
                                  onTap: () {
                                    setState(() {
                                      index = key;
                                    });
                                  });
                            }).toList(),
                          )))),
              SizedBox(width: screenSize.width / 12),
              Column(children: [
                Row(children: [
                  SizedBox(
                      width: screenSize.width / 12 * 3,
                      height: screenSize.height / 10,
                      child: Center(
                          child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xd56aeaee),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              width: screenSize.width / 12 * 3 * 0.8,
                              height: screenSize.height / 10 * 0.8,
                              child: Center(
                                  child: Text(
                                tr(difficulty[typegame]),
                                style: TextStyle(
                                    fontSize: 10.toFont, color: Colors.black),
                              ))))),
                  SizedBox(
                      width: screenSize.width / 12,
                      height: screenSize.height / 10,
                      child: Center(
                          child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xd56aeaee),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              width: screenSize.width / 12 * 0.8,
                              height: screenSize.height / 10 * 0.8,
                              child: Center(
                                  child: Text(
                                '${((_gametime / 60).truncate()).toString().padLeft(2, '0')}:${(_gametime % 60).toString().padLeft(2, '0')}',
                                style: TextStyle(
                                    fontSize: 10.toFont, color: Colors.black),
                              )))))
                ]),
                SizedBox(height: screenSize.height / 30),
                GestureDetector(
                    onTap: () {
                      solver(context);
                    },
                    child: SizedBox(
                        height: screenSize.height / 30,
                        child: Center(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xef05dffc),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                width: screenSize.width / 3 * 0.8,
                                height: screenSize.height / 7 * 0.8,
                                child: Center(
                                    child: Text(
                                  tr('Solver'),
                                  style: TextStyle(
                                      fontSize: 9.toFont, color: Colors.black),
                                )))))),
                SizedBox(height: screenSize.height / 30),
                GestureDetector(
                    onTap: newGame,
                    child: SizedBox(
                        height: screenSize.height / 7,
                        child: Center(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xef058dfc),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                width: screenSize.width / 3 * 0.8,
                                height: screenSize.height / 7 * 0.8,
                                child: Center(
                                    child: Text(
                                  tr('NewGame'),
                                  style: TextStyle(
                                      fontSize: 13.toFont, color: Colors.black),
                                )))))),
                Row(children: [
                  NumbersButton(
                      screenSize: screenSize, tapNumber: tapNumber, number: 1),
                  NumbersButton(
                      screenSize: screenSize, tapNumber: tapNumber, number: 2),
                  NumbersButton(
                      screenSize: screenSize, tapNumber: tapNumber, number: 3),
                ]),
                Row(children: [
                  NumbersButton(
                      screenSize: screenSize, tapNumber: tapNumber, number: 4),
                  NumbersButton(
                      screenSize: screenSize, tapNumber: tapNumber, number: 5),
                  NumbersButton(
                      screenSize: screenSize, tapNumber: tapNumber, number: 6),
                ]),
                Row(children: [
                  NumbersButton(
                      screenSize: screenSize, tapNumber: tapNumber, number: 7),
                  NumbersButton(
                      screenSize: screenSize, tapNumber: tapNumber, number: 8),
                  NumbersButton(
                      screenSize: screenSize, tapNumber: tapNumber, number: 9),
                ]),
                Row(children: [
                  SizedBox(
                      width: screenSize.width / 12,
                      height: screenSize.height / 7,
                      child: GestureDetector(
                        child: Center(
                            child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xd56aeaee),
                                  shape: BoxShape.circle,
                                ),
                                width: screenSize.width / 12 * 0.8,
                                height: screenSize.height / 7 * 0.8,
                                child: Center(
                                    child: Text("␡",
                                        style:
                                            TextStyle(fontSize: 20.toFont))))),
                        onTap: () {
                          tapNumber(0);
                        },
                      )),
                  SizedBox(
                      width: screenSize.width / 12,
                      height: screenSize.height / 7,
                      child: GestureDetector(
                          onTap: toggleNotes,
                          child: Center(
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: notes,
                                    shape: BoxShape.circle,
                                  ),
                                  width: screenSize.width / 12 * 0.8,
                                  height: screenSize.height / 7 * 0.8,
                                  child: Center(
                                      child: Text("📝",
                                          style: TextStyle(
                                              fontSize: 20.toFont))))))),
                  SizedBox(
                      width: screenSize.width / 12,
                      height: screenSize.height / 7,
                      child: GestureDetector(
                        onTap: () {
                          getRecords(context);
                        },
                        child: Center(
                            child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xd56aeaee),
                                  shape: BoxShape.circle,
                                ),
                                width: screenSize.width / 12 * 0.8,
                                height: screenSize.height / 7 * 0.8,
                                child: Center(
                                    child: Text("🏆",
                                        style:
                                            TextStyle(fontSize: 20.toFont))))),
                      )),
                  SizedBox(
                      width: screenSize.width / 12,
                      height: screenSize.height / 7,
                      child: GestureDetector(
                        onTap: () {
                          settingsSudoku(context);
                        },
                        child: Center(
                            child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xd56aeaee),
                                  shape: BoxShape.circle,
                                ),
                                width: screenSize.width / 12 * 0.8,
                                height: screenSize.height / 7 * 0.8,
                                child: Center(
                                    child: Text("⚙",
                                        style:
                                            TextStyle(fontSize: 20.toFont))))),
                      )),
                ]),
              ]),
            ])));
  }

  @override
  void initState() {
    super.initState();
    _isStart = false;
  }

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
}

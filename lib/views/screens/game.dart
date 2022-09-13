import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nonomino/classes/note.dart';
import 'package:nonomino/common/custombutton.dart';
import 'package:nonomino/services/auto_solver.dart';
import 'package:nonomino/services/constants.dart';
import 'package:nonomino/services/generation.dart';
import 'package:nonomino/services/size_config.dart';
import 'package:nonomino/views/widgets/board.dart';
import 'package:nonomino/views/widgets/new_game.dart';
import 'package:nonomino/views/widgets/records.dart';
import 'package:nonomino/views/widgets/setting.dart';
import 'package:nonomino/views/widgets/shortcuts.dart';
import 'package:nonomino/views/widgets/victory.dart';

List<Note> boardNote = [];
int index = -1;
Color notes = const Color(0xd56aeaee);
bool notesState = false;
int typegame = 0, _gametime = 0;
List<int> valueArg = [], valueStatic = List.filled(81, 0, growable: false);
Timer? _timer;

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

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
                victory(context, startTimer(), _gametime);
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
        getRecords: () => getRecords(context),
        moveSelect: (int move) => moveSelect(move),
        newGame: () => newGame(context),
        settingsSudoku: () => settingsSudoku(context),
        tapNumber: (int number) => tapNumber(number),
        toggleNotes: () => toggleNotes(),
        child: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxHeight < constraints.maxWidth) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 190.toWidth,
                        height: 190.toWidth,
                        child: createBoard(
                            i,
                            (key) => setState(() {
                                  index = key;
                                })),
                      ),
                      SizedBox(width: 30.toWidth),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(children: [
                              CustomButton(
                                  func: () => null,
                                  text: tr(difficulty[typegame]),
                                  width: 80,
                                  height: 60,
                                  fontSize: 7.5),
                              CustomButton(
                                  func: () => null,
                                  text:
                                      '${((_gametime / 60).truncate()).toString().padLeft(2, '0')}:${(_gametime % 60).toString().padLeft(2, '0')}',
                                  width: 40,
                                  height: 60,
                                  fontSize: 10),
                            ]),
                            SizedBox(height: 15.toHeight),
                            CustomButton(
                                func: () => solver(context),
                                text: tr('Solver'),
                                width: 120,
                                fontSize: 13),
                            SizedBox(height: 15.toHeight),
                            CustomButton(
                                func: () => newGame(context),
                                text: tr('NewGame'),
                                width: 120,
                                color: const Color(0xef058dfc),
                                fontSize: 13),
                            SizedBox(height: 20.toHeight),
                            Row(children: [
                              CustomButton(
                                  func: () => tapNumber(1),
                                  text: "1",
                                  width: 40),
                              CustomButton(
                                  func: () => tapNumber(2),
                                  text: "2",
                                  width: 40),
                              CustomButton(
                                  func: () => tapNumber(3),
                                  text: "3",
                                  width: 40),
                            ]),
                            Row(children: [
                              CustomButton(
                                  func: () => tapNumber(4),
                                  text: "4",
                                  width: 40),
                              CustomButton(
                                  func: () => tapNumber(5),
                                  text: "5",
                                  width: 40),
                              CustomButton(
                                  func: () => tapNumber(6),
                                  text: "6",
                                  width: 40),
                            ]),
                            Row(children: [
                              CustomButton(
                                  func: () => tapNumber(7),
                                  text: "7",
                                  width: 40),
                              CustomButton(
                                  func: () => tapNumber(8),
                                  text: "8",
                                  width: 40),
                              CustomButton(
                                  func: () => tapNumber(9),
                                  text: "9",
                                  width: 40),
                            ]),
                            Row(children: [
                              CustomButton(
                                func: () => tapNumber(0),
                                text: "␡",
                                shape: BoxShape.circle,
                              ),
                              CustomButton(
                                func: toggleNotes,
                                text: "📝",
                                shape: BoxShape.circle,
                              ),
                              CustomButton(
                                func: () => getRecords(context),
                                text: "🏆",
                                shape: BoxShape.circle,
                              ),
                              CustomButton(
                                func: () => settingsSudoku(context),
                                text: "⚙",
                                shape: BoxShape.circle,
                              )
                            ]),
                          ]),
                    ]);
              } else {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                                func: () => null,
                                text: tr(difficulty[typegame]),
                                width: 180,
                                height: 30,
                                fontSize: 7.5),
                            CustomButton(
                                func: () => null,
                                text:
                                    '${((_gametime / 60).truncate()).toString().padLeft(2, '0')}:${(_gametime % 60).toString().padLeft(2, '0')}',
                                width: 80,
                                height: 30,
                                fontSize: 10),
                          ]),
                      SizedBox(
                        height: 20.toHeight,
                      ),
                      SizedBox(
                        width: 300.toHeight,
                        height: 300.toHeight,
                        child: createBoard(
                            i,
                            (key) => setState(() {
                                  index = key;
                                })),
                      ),
                      SizedBox(
                        height: 20.toHeight,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                                func: () => solver(context),
                                text: tr('Solver'),
                                width: 120,
                                height: 30,
                                fontSize: 13),
                            CustomButton(
                                func: () => newGame(context),
                                text: tr('NewGame'),
                                width: 120,
                                height: 30,
                                color: const Color(0xef058dfc),
                                fontSize: 13),
                            CustomButton(
                                func: () => settingsSudoku(context),
                                text: "⚙",
                                shape: BoxShape.circle,
                                height: 30,
                                fontSize: 10)
                          ]),
                      SizedBox(
                        height: 20.toHeight,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButton(
                                    func: () => tapNumber(1),
                                    text: "1",
                                    width: 50,
                                    height: 50,
                                  ),
                                  CustomButton(
                                    func: () => tapNumber(2),
                                    text: "2",
                                    width: 50,
                                    height: 50,
                                  ),
                                  CustomButton(
                                    func: () => tapNumber(3),
                                    text: "3",
                                    width: 50,
                                    height: 50,
                                  ),
                                  CustomButton(
                                    func: () => tapNumber(0),
                                    text: "␡",
                                    shape: BoxShape.circle,
                                    width: 50,
                                    height: 50,
                                  )
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButton(
                                    func: () => tapNumber(4),
                                    text: "4",
                                    width: 50,
                                    height: 50,
                                  ),
                                  CustomButton(
                                    func: () => tapNumber(5),
                                    text: "5",
                                    width: 50,
                                    height: 50,
                                  ),
                                  CustomButton(
                                    func: () => tapNumber(6),
                                    text: "6",
                                    width: 50,
                                    height: 50,
                                  ),
                                  CustomButton(
                                    func: toggleNotes,
                                    text: "📝",
                                    shape: BoxShape.circle,
                                    width: 50,
                                    height: 50,
                                  ),
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButton(
                                    func: () => tapNumber(7),
                                    text: "7",
                                    width: 50,
                                    height: 50,
                                  ),
                                  CustomButton(
                                    func: () => tapNumber(8),
                                    text: "8",
                                    width: 50,
                                    height: 50,
                                  ),
                                  CustomButton(
                                    func: () => tapNumber(9),
                                    text: "9",
                                    width: 50,
                                    height: 50,
                                  ),
                                  CustomButton(
                                    func: () => getRecords(context),
                                    text: "🏆",
                                    shape: BoxShape.circle,
                                    width: 50,
                                    height: 50,
                                  ),
                                ]),
                          ]),
                    ]);
              }
            },
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
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
    while (true) {
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
        break;
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
    stopTimer();
    startTimer();
  }

  startTimer() {
    _timer = Timer.periodic(
        const Duration(seconds: 1), (_) => setState(() => _gametime++));
  }

  stopTimer() {
    setState(() => _timer?.cancel());
  }
}

import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nonomino/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class DelIntent extends Intent {
  const DelIntent();
}

class NoteIntent extends Intent {
  const NoteIntent();
}

class NewIntent extends Intent {
  const NewIntent();
}

class SettingIntent extends Intent {
  const SettingIntent();
}

class RecordsIntent extends Intent {
  const RecordsIntent();
}

class OneIntent extends Intent {
  const OneIntent();
}

class TwoIntent extends Intent {
  const TwoIntent();
}

class ThreeIntent extends Intent {
  const ThreeIntent();
}

class FourIntent extends Intent {
  const FourIntent();
}

class FiveIntent extends Intent {
  const FiveIntent();
}

class SixIntent extends Intent {
  const SixIntent();
}

class SevenIntent extends Intent {
  const SevenIntent();
}

class EightIntent extends Intent {
  const EightIntent();
}

class NineIntent extends Intent {
  const NineIntent();
}

class UpIntent extends Intent {
  const UpIntent();
}

class LeftIntent extends Intent {
  const LeftIntent();
}

class RightIntent extends Intent {
  const RightIntent();
}

class DownIntent extends Intent {
  const DownIntent();
}

Random rand = Random();
int countIter = 0;
bool longSolve = false, isSolver = false;

class Note {
  bool one = false,
      two = false,
      three = false,
      four = false,
      five = false,
      six = false,
      seven = false,
      eight = false,
      nine = false;

  bool isNotEmpty() {
    if (one || two || three || four || five || six || seven || eight || nine) {
      return true;
    }
    return false;
  }

  void clear() {
    one = false;
    two = false;
    three = false;
    four = false;
    five = false;
    six = false;
    seven = false;
    eight = false;
    nine = false;
  }

  void add(int num) {
    switch (num) {
      case 1:
        one = !one;
        break;
      case 2:
        two = !two;
        break;
      case 3:
        three = !three;
        break;
      case 4:
        four = !four;
        break;
      case 5:
        five = !five;
        break;
      case 6:
        six = !six;
        break;
      case 7:
        seven = !seven;
        break;
      case 8:
        eight = !eight;
        break;
      case 9:
        nine = !nine;
        break;
    }
  }

  int count() {
    int s = (one ? 1 : 0) +
        (two ? 1 : 0) +
        (three ? 1 : 0) +
        (four ? 1 : 0) +
        (five ? 1 : 0) +
        (six ? 1 : 0) +
        (seven ? 1 : 0) +
        (eight ? 1 : 0) +
        (nine ? 1 : 0);
    return s;
  }
}

List<Note> boardNote = [];
int typegame = 0, _gametime = 0;
TextStyle txtstyle = const TextStyle(fontFamilyFallback: <String>['Segoe UI']);
bool _isStart = false;
String levelGame = '';
Color notes = const Color(0xd56aeaee);
bool notesState = false;
int index = -1;
List<int> board = List.filled(81, 0, growable: false),
    boardTemp = [],
    getMove = [];
int countEmpty = 0, countNumber = 0, thisNum = 1;
List<Color> nonominoColors = [
  Colors.white,
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.lightBlueAccent,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple
];

class Pair {
  Pair(this.first, this.second);

  final dynamic first;
  final dynamic second;
}

void dfs(int x) {
  boardTemp[x] = -1;
  countEmpty++;
  if ((x / 9.0).floor() != 0 && boardTemp[x - 9] == 0) {
    dfs(x - 9);
  }
  if ((x / 9.0).floor() != 8 && boardTemp[x + 9] == 0) {
    dfs(x + 9);
  }
  if (x % 9 != 0 && boardTemp[x - 1] == 0) {
    dfs(x - 1);
  }
  if (x % 9 != 8 && boardTemp[x + 1] == 0) {
    dfs(x + 1);
  }
}

void fillBoard(int number, int x) {
  if (countNumber != 9) {
    countNumber++;
    board[x] = number;
    getMove.clear();
    if ((x / 9.0).floor() != 0) {
      if (board[x - 9] == 0) {
        boardTemp.clear();
        boardTemp.addAll(board.getRange(0, board.length));
        boardTemp[x - 9] = number;
        countEmpty = 0;
        if (((x - 9) / 9.0).floor() != 0 && boardTemp[(x - 9) - 9] == 0) {
          dfs((x - 9) - 9);
        }
        if (countEmpty == 0 ||
            (countEmpty + 1 - (9 - countNumber) >= 0 &&
                (countEmpty - (9 - countNumber) + 1) % 9 == 0)) {
          countEmpty = 0;
          if ((x - 9) % 9 != 0 && boardTemp[(x - 9) - 1] == 0) {
            dfs((x - 9) - 1);
          }
          if (countEmpty == 0 ||
              (countEmpty - (9 - countNumber) + 1 >= 0 &&
                  (countEmpty - (9 - countNumber) + 1) % 9 == 0)) {
            countEmpty = 0;
            if ((x - 9) % 9 != 8 && boardTemp[(x - 9) + 1] == 0) {
              dfs((x - 9) + 1);
            }
            if (countEmpty == 0 ||
                (countEmpty - (9 - countNumber) + 1 >= 0 &&
                    (countEmpty - (9 - countNumber) + 1) % 9 == 0)) {
              getMove.add(0);
            }
          }
        }
      }
    }
    if ((x / 9.0).floor() != 8) {
      if (board[x + 9] == 0) {
        boardTemp.clear();
        boardTemp.addAll(board.getRange(0, board.length));
        boardTemp[x + 9] = number;
        countEmpty = 0;
        if (((x + 9) / 9.0).floor() != 8 && boardTemp[(x + 9) + 9] == 0) {
          dfs((x + 9) + 9);
        }
        if (countEmpty == 0 ||
            (countEmpty + 1 - (9 - countNumber) >= 0 &&
                (countEmpty - (9 - countNumber) + 1) % 9 == 0)) {
          countEmpty = 0;
          if ((x + 9) % 9 != 0 && boardTemp[(x + 9) - 1] == 0) {
            dfs((x + 9) - 1);
          }
          if (countEmpty == 0 ||
              (countEmpty - (9 - countNumber) + 1 >= 0 &&
                  (countEmpty - (9 - countNumber) + 1) % 9 == 0)) {
            countEmpty = 0;
            if ((x + 9) % 9 != 8 && boardTemp[(x + 9) + 1] == 0) {
              dfs((x + 9) + 1);
            }
            if (countEmpty == 0 ||
                (countEmpty - (9 - countNumber) + 1 >= 0 &&
                    (countEmpty - (9 - countNumber) + 1) % 9 == 0)) {
              getMove.add(1);
            }
          }
        }
      }
    }
    if (x % 9 != 0) {
      if (board[x - 1] == 0) {
        boardTemp.clear();
        boardTemp.addAll(board.getRange(0, board.length));
        boardTemp[x - 1] = number;
        countEmpty = 0;
        if (((x - 1) / 9.0).floor() != 8 && boardTemp[(x - 1) + 9] == 0) {
          dfs((x - 1) + 9);
        }
        if (countEmpty == 0 ||
            (countEmpty + 1 - (9 - countNumber) >= 0 &&
                (countEmpty - (9 - countNumber) + 1) % 9 == 0)) {
          countEmpty = 0;
          if ((x - 1) % 9 != 0 && boardTemp[(x - 1) - 1] == 0) {
            dfs((x - 1) - 1);
          }
          if (countEmpty == 0 ||
              (countEmpty - (9 - countNumber) + 1 >= 0 &&
                  (countEmpty - (9 - countNumber) + 1) % 9 == 0)) {
            countEmpty = 0;
            if (((x - 1) / 9.0).floor() != 0 && boardTemp[(x - 1) - 9] == 0) {
              dfs((x - 1) - 9);
            }
            if (countEmpty == 0 ||
                (countEmpty - (9 - countNumber) + 1 >= 0 &&
                    (countEmpty - (9 - countNumber) + 1) % 9 == 0)) {
              getMove.add(2);
            }
          }
        }
      }
    }
    if (x % 9 != 8) {
      if (board[x + 1] == 0) {
        boardTemp.clear();
        boardTemp.addAll(board.getRange(0, board.length));
        boardTemp[x + 1] = number;
        countEmpty = 0;
        if (((x + 1) / 9.0).floor() != 8 && boardTemp[(x + 1) + 9] == 0) {
          dfs((x + 1) + 9);
        }
        if (countEmpty == 0 ||
            (countEmpty + 1 - (9 - countNumber) >= 0 &&
                (countEmpty - (9 - countNumber) + 1) % 9 == 0)) {
          countEmpty = 0;
          if ((x + 1) % 9 != 8 && boardTemp[(x + 1) + 1] == 0) {
            dfs((x + 1) + 1);
          }
          if (countEmpty == 0 ||
              (countEmpty - (9 - countNumber) + 1 >= 0 &&
                  (countEmpty - (9 - countNumber) + 1) % 9 == 0)) {
            countEmpty = 0;
            if (((x + 1) / 9.0).floor() != 0 && boardTemp[(x + 1) - 9] == 0) {
              dfs((x + 1) - 9);
            }
            if (countEmpty == 0 ||
                (countEmpty - (9 - countNumber) + 1 >= 0 &&
                    (countEmpty - (9 - countNumber) + 1) % 9 == 0)) {
              getMove.add(3);
            }
          }
        }
      }
    }
    if (getMove.isNotEmpty) {
      int randMove = getMove[rand.nextInt(getMove.length)];
      switch (randMove) {
        case 0:
          fillBoard(number, x - 9);
          break;
        case 1:
          fillBoard(number, x + 9);
          break;
        case 2:
          fillBoard(number, x - 1);
          break;
        case 3:
          fillBoard(number, x + 1);
          break;
      }
    }
  }
}

void buildBoard() {
  bool flag = true;
  while (flag) {
    board = List.filled(81, 0, growable: false);
    countNumber = 0;
    thisNum = 1;
    countEmpty = 0;
    for (int t = 0; t < 50; t++) {
      for (int i = 0; i < 81; i++) {
        if (countNumber == 0) {
          if (board[i] == 0) {
            fillBoard(thisNum, i);
            if (countNumber == 9) {
              countNumber = 0;
              thisNum++;
            }
          } else {
            if (board[i] == thisNum) {
              countNumber--;
              fillBoard(thisNum, i);
              if (countNumber == 9) {
                countNumber = 0;
                thisNum++;
              }
            }
          }
        }
      }
    }
    int countFull = 0;
    for (int i = 0; i < 81; i++) {
      if (board[i] != 0) {
        countFull++;
      }
    }
    if (countFull == 81) {
      flag = false;
    }
  }
}

class _GameScreenState extends State<GameScreen> {
  Timer? timer, timer1;

  bool passMove(List<int> valueStatic, int i, int j, int number) {
    if (longSolve) {
      return false;
    }
    for (int x = 0; x < 9; x++) {
      if (valueStatic[x + j * 9] == number ||
          valueStatic[i + x * 9] == number) {
        return false;
      }
    }
    int currentRegion = board[i + j * 9];
    Queue<Pair> q = Queue();
    q.add(Pair(i, j));
    List<bool> visited = List.filled(81, false, growable: false);
    visited[i + j * 9] = true;
    while (q.isNotEmpty) {
      Pair front = q.first;
      q.removeFirst();
      if (front.first + 1 < 9 &&
          board[front.first + 1 + front.second * 9] == currentRegion &&
          !visited[front.first + 1 + front.second * 9]) {
        if (valueStatic[front.first + 1 + front.second * 9] == number) {
          return false;
        }
        q.addLast(Pair(front.first + 1, front.second));
        visited[front.first + 1 + front.second * 9] = true;
      }
      if (front.first - 1 >= 0 &&
          board[front.first - 1 + front.second * 9] == currentRegion &&
          !visited[front.first - 1 + front.second * 9]) {
        if (valueStatic[front.first - 1 + front.second * 9] == number) {
          return false;
        }
        q.addLast(Pair(front.first - 1, front.second));
        visited[front.first - 1 + front.second * 9] = true;
      }
      if (front.second + 1 < 9 &&
          board[front.first + (front.second + 1) * 9] == currentRegion &&
          !visited[front.first + (front.second + 1) * 9]) {
        if (valueStatic[front.first + (front.second + 1) * 9] == number) {
          return false;
        }
        q.addLast(Pair(front.first, front.second + 1));
        visited[front.first + (front.second + 1) * 9] = true;
      }
      if (front.second - 1 >= 0 &&
          board[front.first + (front.second - 1) * 9] == currentRegion &&
          !visited[front.first + (front.second - 1) * 9]) {
        if (valueStatic[front.first + (front.second - 1) * 9] == number) {
          return false;
        }
        q.addLast(Pair(front.first, front.second - 1));
        visited[front.first + (front.second - 1) * 9] = true;
      }
    }
    countIter++;
    if (countIter == 1e5) {
      longSolve = true;
    }
    return true;
  }

  bool sudokuSolver(List<int> valueStatic, int i, int j) {
    if (i == 9) {
      return true;
    }
    if (j == 9) {
      return sudokuSolver(valueStatic, i + 1, 0);
    }
    if (valueStatic[i + j * 9] != 0) {
      return sudokuSolver(valueStatic, i, j + 1);
    } else {
      for (int number = 1; number <= 9; number++) {
        if (passMove(valueStatic, i, j, number)) {
          valueStatic[i + j * 9] = number;
          bool check = sudokuSolver(valueStatic, i, j + 1);
          if (check == true) {
            return true;
          }
        }
      }
      valueStatic[i + j * 9] = 0;
      return false;
    }
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

  List<int> valueArg = [], valueStatic = List.filled(81, 0, growable: false);

  bool correctBoard() {
    Note test = Note();
    for (int i = 0; i < 9; i++) {
      test.clear();
      for (int j = 0; j < 9; j++) {
        test.add(valueArg[i + j * 9]);
      }
      if (test.count() != 9) {
        return false;
      }
    }
    Note k1 = Note(),
        k2 = Note(),
        k3 = Note(),
        k4 = Note(),
        k5 = Note(),
        k6 = Note(),
        k7 = Note(),
        k8 = Note(),
        k9 = Note();
    for (int i = 0; i < 81; i++) {
      switch (board[i]) {
        case 1:
          k1.add(valueArg[i]);
          break;
        case 2:
          k2.add(valueArg[i]);
          break;
        case 3:
          k3.add(valueArg[i]);
          break;
        case 4:
          k4.add(valueArg[i]);
          break;
        case 5:
          k5.add(valueArg[i]);
          break;
        case 6:
          k6.add(valueArg[i]);
          break;
        case 7:
          k7.add(valueArg[i]);
          break;
        case 8:
          k8.add(valueArg[i]);
          break;
        case 9:
          k9.add(valueArg[i]);
          break;
      }
    }
    if (k1.count() != 9) {
      return false;
    }
    if (k2.count() != 9) {
      return false;
    }
    if (k3.count() != 9) {
      return false;
    }
    if (k4.count() != 9) {
      return false;
    }
    if (k5.count() != 9) {
      return false;
    }
    if (k6.count() != 9) {
      return false;
    }
    if (k7.count() != 9) {
      return false;
    }
    if (k8.count() != 9) {
      return false;
    }
    if (k9.count() != 9) {
      return false;
    }
    return true;
  }

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
            content: Text('${tr('win')}\n${tr('time')} ${((_gametime / 60).truncate()).toString().padLeft(2, '0')}:${(_gametime % 60).toString().padLeft(2, '0')}'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _isStart = false;
                  Navigator.pop(context);
                  setState(() {});
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
      int ready = 0;
      switch (typegame) {
        case 0:
          {
            levelGame = tr('easy');
            ready = 45;
          }
          break;
        case 1:
          {
            levelGame = tr('medium');
            ready = 30;
          }
          break;
        case 2:
          {
            levelGame = tr('hard');
            ready = 20;
          }
          break;
        case 3:
          {
            levelGame = tr('expert');
            ready = 12;
          }
          break;
      }
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
                    _isStart = false;
                    Navigator.pushReplacementNamed(context, '/game');
                  },
                  child: Center(child: Text(tr('easy'), style: txtstyle)),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    typegame = 1;
                    stopTimer();
                    _isStart = false;
                    Navigator.pushReplacementNamed(context, '/game');
                  },
                  child: Center(child: Text(tr('medium'), style: txtstyle)),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    typegame = 2;
                    stopTimer();
                    _isStart = false;
                    Navigator.pushReplacementNamed(context, '/game');
                  },
                  child: Center(child: Text(tr('hard'), style: txtstyle)),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    typegame = 3;
                    stopTimer();
                    _isStart = false;
                    Navigator.pushReplacementNamed(context, '/game');
                  },
                  child: Center(child: Text(tr('expert'), style: txtstyle)),
                )
              ],
            );
          });
    }

    error(String str) {
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

    solver() {
      isSolver = true;
      longSolve = false;
      countIter = 0;
      bool solver = sudokuSolver(valueArg, 0, 0);
      if (!solver) {
        error(tr('error2'));
      } else {
        bool correct = correctBoard();
        if (!correct) {
          error(tr('error1'));
        }
      }
    }

    getRecords() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int timeEasy = (prefs.getInt('timeEasy') ?? -1);
      String records = '';
      timeEasy != -1
          ? records += '${tr('easy')}\n${tr('time')} ${((timeEasy / 60).truncate()).toString().padLeft(2, '0')}:${(timeEasy % 60).toString().padLeft(2, '0')}\n'
          : records += '${tr('easy')}\n${tr('noRecord')}\n';
      int timeMedium = (prefs.getInt('timeMedium') ?? -1);
      timeMedium != -1
          ? records += '${tr('medium')}\n${tr('time')} ${((timeMedium / 60).truncate()).toString().padLeft(2, '0')}:${(timeMedium % 60).toString().padLeft(2, '0')}\n'
          : records += '${tr('medium')}\n${tr('noRecord')}\n';
      int timeHard = (prefs.getInt('timeHard') ?? -1);
      timeHard != -1
          ? records += '${tr('hard')}\n${tr('time')} ${((timeHard / 60).truncate()).toString().padLeft(2, '0')}:${(timeHard % 60).toString().padLeft(2, '0')}\n'
          : records += '${tr('hard')}\n${tr('noRecord')}\n';
      int timeExpert = (prefs.getInt('timeExpert') ?? -1);
      timeExpert != -1
          ? records += '${tr('expert')}\n${tr('time')} ${((timeExpert / 60).truncate()).toString().padLeft(2, '0')}:${(timeExpert % 60).toString().padLeft(2, '0')}\n'
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

    save(String locate) async{
      context.setLocale(locate.toLocale());
        setState(() { switch (typegame) {
          case 0:
            levelGame = tr('easy');
            break;
          case 1:
            levelGame = tr('medium');
            break;
          case 2:
            levelGame = tr('hard');
            break;
          case 3:
            levelGame = tr('expert');
            break;
        }});
      Navigator.pop(context);
    }

    settingsSudoku() async {
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
                      WidgetsBinding.instance.addPostFrameCallback((_) => save(locate));
                    },
                    child: Text(tr('Save')),
                  ),
                ],
              );
            });
          });
    }

    toggleNotes() {
      if (notesState) {
        notesState = false;
        notes = const Color(0xd56aeaee);
      } else {
        notes = const Color(0xff2d6072);
        notesState = true;
      }
      setState(() {});
    }

    moveSelect(int i) {
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
      setState(() {});
    }

    int i = 0;
    return Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.delete): const DelIntent(),
          LogicalKeySet(LogicalKeyboardKey.backspace): const DelIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SettingIntent(),
          LogicalKeySet(LogicalKeyboardKey.tab): const NoteIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit1): const OneIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit2): const TwoIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit3): const ThreeIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit4): const FourIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit5): const FiveIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit6): const SixIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit7): const SevenIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit8): const EightIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit9): const NineIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowUp): const UpIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowDown): const DownIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowRight): const RightIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowLeft): const LeftIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyR):
              const RecordsIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
              const NewIntent(),
        },
        child: Actions(
            actions: <Type, Action<Intent>>{
              RecordsIntent: CallbackAction<RecordsIntent>(
                  onInvoke: (RecordsIntent intent) => getRecords()),
              NewIntent: CallbackAction<NewIntent>(
                onInvoke: (NewIntent intent) => newGame(),
              ),
              SettingIntent: CallbackAction<SettingIntent>(
                onInvoke: (SettingIntent intent) => settingsSudoku(),
              ),
              OneIntent: CallbackAction<OneIntent>(
                onInvoke: (OneIntent intent) => tapNumber(1),
              ),
              TwoIntent: CallbackAction<TwoIntent>(
                onInvoke: (TwoIntent intent) => tapNumber(2),
              ),
              ThreeIntent: CallbackAction<ThreeIntent>(
                onInvoke: (ThreeIntent intent) => tapNumber(3),
              ),
              FourIntent: CallbackAction<FourIntent>(
                onInvoke: (FourIntent intent) => tapNumber(4),
              ),
              FiveIntent: CallbackAction<FiveIntent>(
                onInvoke: (FiveIntent intent) => tapNumber(5),
              ),
              SixIntent: CallbackAction<SixIntent>(
                onInvoke: (SixIntent intent) => tapNumber(6),
              ),
              SevenIntent: CallbackAction<SevenIntent>(
                onInvoke: (SevenIntent intent) => tapNumber(7),
              ),
              EightIntent: CallbackAction<EightIntent>(
                onInvoke: (EightIntent intent) => tapNumber(8),
              ),
              NineIntent: CallbackAction<NineIntent>(
                onInvoke: (NineIntent intent) => tapNumber(9),
              ),
              UpIntent: CallbackAction<UpIntent>(
                onInvoke: (UpIntent intent) => moveSelect(0),
              ),
              DownIntent: CallbackAction<DownIntent>(
                onInvoke: (DownIntent intent) => moveSelect(1),
              ),
              LeftIntent: CallbackAction<LeftIntent>(
                onInvoke: (LeftIntent intent) => moveSelect(2),
              ),
              RightIntent: CallbackAction<RightIntent>(
                onInvoke: (RightIntent intent) => moveSelect(3),
              ),
              DelIntent: CallbackAction<DelIntent>(
                onInvoke: (DelIntent intent) => tapNumber(0),
              ),
              NoteIntent: CallbackAction<NoteIntent>(
                onInvoke: (NoteIntent intent) => toggleNotes(),
              ),
            },
            child: Focus(
                autofocus: true,
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
                                              fontSize: 32.toFont,
                                              color: Colors.black),
                                        );
                                        if (boardNote[key].isNotEmpty()) {
                                          it = GridView.count(
                                              crossAxisCount: 3,
                                              children: [
                                                Center(
                                                    child: Text(
                                                        boardNote[key].one ==
                                                                true
                                                            ? '1'
                                                            : ' ',
                                                        style: TextStyle(
                                                            fontSize: 9.0.toFont,
                                                            color:
                                                                Colors.black))),
                                                Center(
                                                    child: Text(
                                                        boardNote[key].two ==
                                                                true
                                                            ? '2'
                                                            : ' ',
                                                        style: TextStyle(
                                                            fontSize: 9.toFont,
                                                            color:
                                                                Colors.black))),
                                                Center(
                                                    child: Text(
                                                        boardNote[key].three ==
                                                                true
                                                            ? '3'
                                                            : ' ',
                                                        style:  TextStyle(
                                                            fontSize: 9.toFont,
                                                            color:
                                                                Colors.black))),
                                                Center(
                                                    child: Text(
                                                        boardNote[key].four ==
                                                                true
                                                            ? '4'
                                                            : ' ',
                                                        style: TextStyle(
                                                            fontSize: 9.toFont,
                                                            color:
                                                                Colors.black))),
                                                Center(
                                                    child: Text(
                                                        boardNote[key].five ==
                                                                true
                                                            ? '5'
                                                            : ' ',
                                                        style: TextStyle(
                                                            fontSize: 9.toFont,
                                                            color:
                                                                Colors.black))),
                                                Center(
                                                    child: Text(
                                                        boardNote[key].six ==
                                                                true
                                                            ? '6'
                                                            : ' ',
                                                        style: TextStyle(
                                                            fontSize: 9.toFont,
                                                            color:
                                                                Colors.black))),
                                                Center(
                                                    child: Text(
                                                        boardNote[key].seven ==
                                                                true
                                                            ? '7'
                                                            : ' ',
                                                        style: TextStyle(
                                                            fontSize: 9.toFont,
                                                            color:
                                                                Colors.black))),
                                                Center(
                                                    child: Text(
                                                        boardNote[key].eight ==
                                                                true
                                                            ? '8'
                                                            : ' ',
                                                        style: TextStyle(
                                                            fontSize: 9.toFont,
                                                            color:
                                                                Colors.black))),
                                                Center(
                                                    child: Text(
                                                        boardNote[key].nine ==
                                                                true
                                                            ? '9'
                                                            : ' ',
                                                        style: TextStyle(
                                                            fontSize:9.toFont,
                                                            color:
                                                                Colors.black)))
                                              ]);
                                        }
                                      } else {
                                        it = Text(valueStatic[key].toString(),
                                            style: TextStyle(
                                                fontSize: 32.0.toFont,
                                                color: const Color(0xFF595959)));
                                      }
                                      Color tempColor =
                                          nonominoColors[board[key]];

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
                                                          color:
                                                              Colors.black))),
                                              child: Center(
                                                child: it,
                                              )),
                                          onTap: () {
                                            index = key;
                                            setState(() {});
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
                                        levelGame,
                                        style: TextStyle(
                                            fontSize: 10.toFont,
                                            color: Colors.black),
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
                                            fontSize: 10.toFont,
                                            color: Colors.black),
                                      )))))
                        ]),
                        SizedBox(height: screenSize.height / 30),
                        GestureDetector(
                            onTap: solver,
                            child: SizedBox(
                                height: screenSize.height / 30,
                                child: Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xef05dffc),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        width: screenSize.width / 3 * 0.8,
                                        height: screenSize.height / 7 * 0.8,
                                        child: Center(
                                            child: Text(
                                          tr('Solver'),
                                          style: TextStyle(
                                              fontSize: 9.toFont,
                                              color: Colors.black),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        width: screenSize.width / 3 * 0.8,
                                        height: screenSize.height / 7 * 0.8,
                                        child: Center(
                                            child: Text(
                                          tr('NewGame'),
                                          style: TextStyle(
                                              fontSize: 13.toFont,
                                              color: Colors.black),
                                        )))))),
                        Row(children: [
                          SizedBox(
                              width: screenSize.width / 12,
                              height: screenSize.height / 7,
                              child: GestureDetector(
                                child: Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xd56aeaee),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        width: screenSize.width / 12 * 0.8,
                                        height: screenSize.height / 7 * 0.8,
                                        child: Center(
                                            child: Text(
                                          '1',
                                          style: TextStyle(
                                              fontSize: 24.toFont,
                                              color: Colors.black),
                                        )))),
                                onTap: () {
                                  tapNumber(1);
                                },
                              )),
                          SizedBox(
                              width: screenSize.width / 12,
                              height: screenSize.height / 7,
                              child: GestureDetector(
                                child: Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xd56aeaee),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        width: screenSize.width / 12 * 0.8,
                                        height: screenSize.height / 7 * 0.8,
                                        child: Center(
                                            child: Text(
                                          '2',
                                          style: TextStyle(
                                              fontSize: 24.toFont,
                                              color: Colors.black),
                                        )))),
                                onTap: () {
                                  tapNumber(2);
                                },
                              )),
                          SizedBox(
                              width: screenSize.width / 12,
                              height: screenSize.height / 7,
                              child: GestureDetector(
                                child: Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xd56aeaee),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        width: screenSize.width / 12 * 0.8,
                                        height: screenSize.height / 7 * 0.8,
                                        child: Center(
                                            child: Text(
                                          '3',
                                          style: TextStyle(
                                              fontSize: 24.toFont,
                                              color: Colors.black),
                                        )))),
                                onTap: () {
                                  tapNumber(3);
                                },
                              )),
                        ]),
                        Row(children: [
                          SizedBox(
                              width: screenSize.width / 12,
                              height: screenSize.height / 7,
                              child: GestureDetector(
                                child: Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xd56aeaee),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        width: screenSize.width / 12 * 0.8,
                                        height: screenSize.height / 7 * 0.8,
                                        child: Center(
                                            child: Text(
                                          '4',
                                          style: TextStyle(
                                              fontSize: 24.toFont,
                                              color: Colors.black),
                                        )))),
                                onTap: () {
                                  tapNumber(4);
                                },
                              )),
                          SizedBox(
                              width: screenSize.width / 12,
                              height: screenSize.height / 7,
                              child: GestureDetector(
                                child: Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xd56aeaee),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        width: screenSize.width / 12 * 0.8,
                                        height: screenSize.height / 7 * 0.8,
                                        child: Center(
                                            child: Text(
                                          '5',
                                          style: TextStyle(
                                              fontSize: 24.toFont,
                                              color: Colors.black),
                                        )))),
                                onTap: () {
                                  tapNumber(5);
                                },
                              )),
                          SizedBox(
                              width: screenSize.width / 12,
                              height: screenSize.height / 7,
                              child: GestureDetector(
                                child: Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xd56aeaee),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        width: screenSize.width / 12 * 0.8,
                                        height: screenSize.height / 7 * 0.8,
                                        child: Center(
                                            child: Text(
                                          '6',
                                          style: TextStyle(
                                              fontSize: 24.toFont,
                                              color: Colors.black),
                                        )))),
                                onTap: () {
                                  tapNumber(6);
                                },
                              )),
                        ]),
                        Row(children: [
                          SizedBox(
                              width: screenSize.width / 12,
                              height: screenSize.height / 7,
                              child: GestureDetector(
                                child: Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xd56aeaee),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        width: screenSize.width / 12 * 0.8,
                                        height: screenSize.height / 7 * 0.8,
                                        child: Center(
                                            child: Text(
                                          '7',
                                          style: TextStyle(
                                              fontSize: 24.toFont,
                                              color: Colors.black),
                                        )))),
                                onTap: () {
                                  tapNumber(7);
                                },
                              )),
                          SizedBox(
                              width: screenSize.width / 12,
                              height: screenSize.height / 7,
                              child: GestureDetector(
                                child: Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xd56aeaee),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        width: screenSize.width / 12 * 0.8,
                                        height: screenSize.height / 7 * 0.8,
                                        child: Center(
                                            child: Text(
                                          '8',
                                          style: TextStyle(
                                              fontSize: 24.toFont,
                                              color: Colors.black),
                                        )))),
                                onTap: () {
                                  tapNumber(8);
                                },
                              )),
                          SizedBox(
                              width: screenSize.width / 12,
                              height: screenSize.height / 7,
                              child: GestureDetector(
                                child: Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xd56aeaee),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        width: screenSize.width / 12 * 0.8,
                                        height: screenSize.height / 7 * 0.8,
                                        child: Center(
                                            child: Text(
                                          '9',
                                          style: TextStyle(
                                              fontSize: 24.toFont,
                                              color: Colors.black),
                                        )))),
                                onTap: () {
                                  tapNumber(9);
                                },
                              )),
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
                                                style: TextStyle(
                                                    fontSize: 20.toFont))))),
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
                                onTap: getRecords,
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
                                                style: TextStyle(
                                                    fontSize: 20.toFont))))),
                              )),
                          SizedBox(
                              width: screenSize.width / 12,
                              height: screenSize.height / 7,
                              child: GestureDetector(
                                onTap: settingsSudoku,
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
                                                style: TextStyle(
                                                    fontSize: 20.toFont))))),
                              )),
                        ]),
                      ]),
                    ])))));
  }
}

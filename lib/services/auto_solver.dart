import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:nonomino/classes/note.dart';
import 'package:nonomino/classes/pair.dart';
import 'package:nonomino/services/generation.dart';
import 'package:nonomino/views/screens/game.dart';
import 'package:nonomino/views/widgets/error.dart';

int countIter = 0;
bool longSolve = false, isSolver = false;

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

bool passMove(List<int> valueStatic, int i, int j, int number) {
  if (longSolve) {
    return false;
  }
  for (int x = 0; x < 9; x++) {
    if (valueStatic[x + j * 9] == number || valueStatic[i + x * 9] == number) {
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

solver(context) {
  isSolver = true;
  longSolve = false;
  countIter = 0;
  bool solver = sudokuSolver(valueArg, 0, 0);
  if (!solver) {
    error(tr('error2'), context);
  } else {
    bool correct = correctBoard();
    if (!correct) {
      error(tr('error1'), context);
    }
  }
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

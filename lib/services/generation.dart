import 'dart:math';

List<int> board = List.filled(81, 0, growable: false),
    boardTemp = [],
    getMove = [];
int countEmpty = 0, countNumber = 0, thisNum = 1;
Random rand = Random();

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

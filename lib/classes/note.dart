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

  bool isNotEmpty() {
    if (one || two || three || four || five || six || seven || eight || nine) {
      return true;
    }
    return false;
  }
}

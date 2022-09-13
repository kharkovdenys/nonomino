class Note {
  List<bool> notes = List.filled(9, false, growable: false);

  void add(int num) {
    notes[num - 1] = !notes[num - 1];
  }

  void clear() {
    for (int i = 0; i < 9; i++) {
      notes[i] = false;
    }
  }

  int count() {
    int s = 0;
    for (int i = 0; i < 9; i++) {
      s += notes[i] ? 1 : 0;
    }
    return s;
  }

  bool isNotEmpty() {
    for (int i = 0; i < 9; i++) {
      if (notes[i]) return true;
    }
    return false;
  }

  bool value(int num) {
    return notes[num - 1];
  }
}

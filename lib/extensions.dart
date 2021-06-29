extension EmptyPlacesX on List<int> {
  List<int> get emptyPlaces {
    final ans = <int>[];
    for (int i = 0; i < length; ++i) {
      if (this[i] == 0) {
        ans.add(i);
      }
    }
    return ans;
  }

  List<int> copyWithIndexTo(int index, int to) {
    final ans = <int>[...this];
    ans[index] = to;
    return ans;
  }

  List<int> getWinningIndicies() {
    final ans = <int>[];
    for (int i = 0; i < 9; i += 3) {
      if (this[i] == this[i + 1] &&
          this[i] == this[i + 2] &&
          this[i + 1] == this[i + 2]) {
        if (this[i].abs() == 1 &&
            this[i + 1].abs() == 1 &&
            this[i + 2].abs() == 1) {
          ans.add(i);
          ans.add(i + 1);
          ans.add(i + 2);
          return ans;
        }
      }
    }
    for (int i = 0; i < 3; i += 1) {
      if (this[i] == this[i + 3] &&
          this[i] == this[i + 6] &&
          this[i + 3] == this[i + 6]) {
        if (this[i].abs() == 1 &&
            this[i + 3].abs() == 1 &&
            this[i + 6].abs() == 1) {
          ans.add(i);
          ans.add(i + 3);
          ans.add(i + 6);
          return ans;
        }
      }
    }
    for (int i = 0; i <= 0; i += 1) {
      if (this[i] == this[i + 4] &&
          this[i] == this[i + 8] &&
          this[i + 4] == this[i + 8]) {
        if (this[i].abs() == 1 &&
            this[i + 4].abs() == 1 &&
            this[i + 8].abs() == 1) {
          ans.add(i);
          ans.add(i + 4);
          ans.add(i + 8);
          return ans;
        }
      }
    }
    for (int i = 2; i <= 2; i += 1) {
      if (this[i] == this[i + 2] &&
          this[i] == this[i + 4] &&
          this[i + 2] == this[i + 4]) {
        if (this[i].abs() == 1 &&
            this[i + 2].abs() == 1 &&
            this[i + 4].abs() == 1) {
          ans.add(i);
          ans.add(i + 2);
          ans.add(i + 4);
          return ans;
        }
      }
    }
    return ans;
  }
}

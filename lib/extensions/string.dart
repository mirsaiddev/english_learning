extension StringExtensions on String {
  int toAnswerIndex() {
    return answerToIndex[this] ?? 0;
  }
}

Map<String, int> answerToIndex = {
  'A': 0,
  'B': 1,
  'C': 2,
  'D': 3,
};

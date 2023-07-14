import 'package:flutter/cupertino.dart';
import 'package:flutter_interview_questions/model/difficulty.dart';
import 'package:flutter_interview_questions/model/language_item.dart';
import 'package:flutter_interview_questions/model/quiz_item.dart';

import 'question_bank.dart';

export '../components/provider.dart';
export 'question.dart';

enum QuizStatus {
  /// The initial state of the quiz, before any data has been loaded.
  loading,

  ///The state of the quiz loaded successfully with data.
  display,

  /// The state of the quiz loaded successfully but data is empty.
  empty,

  /// The state of the quiz loaded failed.
  error
}

class QuizModel extends ChangeNotifier {
  late Bank allQuestions;

  late List<QuizItem> quizItems; // a set of questions used for a quiz

  int get totalCount => allQuestions.values.expand((e) => e).length;

  QuizStatus _status = QuizStatus.loading;

  QuizStatus get status => _status;

  bool get completed => quizItems.every((item) => item.answered);

  QuizModel() {
    QuestionBank.getAllQuestions().then((bank) {
      allQuestions = bank;
      _status = QuizStatus.display;
      notifyListeners();
    });
  }

  /// Gather preferences from users, such as how many questions they want, tags,
  /// and difficulty level etc, then generate a list of [QuizItem]s to use.
  void setup({
    required int count,
    required Set<LanguageItem> selectedTags,
    required Set<Difficulty> selectedDifficulty,
  }) {
    var resultTemp = allQuestions.values.expand((e) => e);
    if (selectedDifficulty.length != Difficulty.values.length) {
      resultTemp = resultTemp.where((e) => selectedDifficulty
          .any((element) => (element.index + 1) == e.difficulty));
    }
    if (selectedTags.length != allQuestions.length) {
      resultTemp = resultTemp
          .where((e) => selectedTags.intersection(e.tags.toSet()).isNotEmpty);
    }

    quizItems = resultTemp.take(count).map<QuizItem>(QuizItem.new).toList();
  }

  @override
  bool operator ==(Object other) {
    return other is QuizModel && allQuestions == other.allQuestions;
  }

  @override
  int get hashCode => allQuestions.hashCode;
}

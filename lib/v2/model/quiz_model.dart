import 'package:flutter/foundation.dart';

import 'question.dart';
import 'quiz_item.dart';

export 'question.dart';

class QuizModel extends ChangeNotifier {
  late List<QuizItem> questions; // a set of questions used for a quiz

  QuizModel(List<Question> selectedQuestions) {
    print('new quiz model');
    questions = selectedQuestions.map<QuizItem>(QuizItem.new).toList();
  }

  bool get completed => questions.every((item) => item.answered);
}

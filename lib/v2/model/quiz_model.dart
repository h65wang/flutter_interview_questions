import 'question.dart';
import 'quiz_item.dart';

export 'question.dart';

class QuizModel {
  late List<QuizItem> questions; // a set of questions used for a quiz

  QuizModel(List<Question> selectedQuestions) {
    print('new quiz model');
    questions = selectedQuestions.map<QuizItem>(QuizItem.new).toList();
  }

  bool get completed => questions.every((item) => item.answered);
}

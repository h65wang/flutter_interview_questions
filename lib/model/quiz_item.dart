import 'question.dart';

/// Describe a question shown in a quiz.
class QuizItem {
  final Question question;

  late final List<Choice> choices;

  QuizItem(this.question) {
    choices = ([
      ...question.answers,
      ...question.candidates,
    ]..shuffle())
        .map(Choice.new)
        .toList();
  }

  /// Returns true if user has selected ANYTHING at all.
  bool get answered => choices.any((choice) => choice.selected);

  /// Returns true if this question is answered correctly.
  bool get correct => choices.every((choice) =>
      (question.answers.contains(choice.content)) == choice.selected);

  /// Returns true if this question has multiple correct answers.
  bool get hasMultipleAnswers => question.answers.length > 1;

}

class Choice {
  final String content; // the "words" of this choice
  bool selected = false; // whether the user has selected it
  int idx = -1;

  Choice(this.content);
}

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

  /// Call this method when the user clicks on a choice, to toggle state.
  void choose(Choice choice) {
    // if this choice had been selected, clicking on it again deselects it
    if (choice.selected) {
      choice.selected = false;
      return;
    }
    // if this question allows multiple choices, we add this choice;
    // otherwise, we exclusively select this choice.
    if (hasMultipleAnswers) {
      choice.selected = true;
    } else {
      for (final c in choices) {
        c.selected = c == choice;
      }
    }
  }
}

class Choice {
  final String content; // the "words" of this choice
  bool selected = false; // whether the user has selected it

  Choice(this.content);
}

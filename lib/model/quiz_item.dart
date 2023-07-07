import 'package:flutter_interview_questions/model/question.dart';

/// Describe a question shown in a quiz.
class QuizItem {
  final Question question;

  late final List<Choice> choices;

  QuizItem(this.question) {
    choices = ([question.answer, ...question.candidates]..shuffle())
        .map(Choice.new)
        .toList();
  }

  /// Returns true if user has selected ANYTHING at all.
  bool get answered => choices.any((choice) => choice.selected);

  /// Returns true if this question is answered correctly.
  bool get correct => choices.every(
      (choice) => (choice.content == question.answer) == choice.selected);

  void radioChoose(Choice choice) {
    for (var element in choices) {
      element.selected = element == choice;
    }
  }
}

class Choice {
  final String content; // the "words" of this choice
  bool selected = false; // whether the user has selected it

  Choice(this.content);
}

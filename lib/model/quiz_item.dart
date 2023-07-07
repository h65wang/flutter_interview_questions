import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/model/question.dart';

/// Describe a question shown in a quiz.
class QuizItem extends ValueNotifier<List<Choice>> {
  final Question question;

  List<Choice> get choices => value;

  QuizItem(this.question)
      : super(([question.answer, ...question.candidates]..shuffle())
            .map(Choice.new)
            .toList());

  /// Returns true if user has selected ANYTHING at all.
  bool get answered => choices.any((choice) => choice.selected);

  /// Returns true if this question is answered correctly.
  bool get correct => choices.every(
      (choice) => (choice.content == question.answer) == choice.selected);

  bool previousFlag = false;//上一个问题是否已经做完  
  set isAnswered(bool flage) {
    isAnswered = flage;
  }

  void radioChoose(Choice choice) {
    for (var element in choices) {
      element.selected = element == choice;
    }
    notifyListeners();
  }
}

class Choice {
  final String content; // the "words" of this choice
  bool selected = false; // whether the user has selected it

  Choice(this.content);
}

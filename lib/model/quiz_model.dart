import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter_interview_questions/model/quiz_item.dart';
import 'package:http/http.dart' as http;

import 'question.dart';

export 'provider.dart';
export 'question.dart';

class QuizModel extends ChangeNotifier {
  List<Question>? allQuestions; // all questions in the knowledge base

  late List<QuizItem> quizItems; // a set of questions used for a quiz

  QuizModel() {
    _fetchAllQuestions();
  }

  Future _fetchAllQuestions() async {
    const root = 'https://raw.githubusercontent.com/h65wang'
        '/flutter_interview_questions/main/public';
    final res = await http.get(Uri.parse('$root/index.json'));
    if (res.statusCode != 200) throw Exception('Network ex: ${res.body}');
    final json = convert.jsonDecode(res.body);
    final questions = <Question>[];
    for (final filename in json['questions']) {
      final res = await http.get(Uri.parse('$root/$filename'));
      if (res.statusCode != 200) throw Exception('Network ex: ${res.body}');
      final json = convert.jsonDecode(res.body);
      questions.addAll(json.map<Question>(Question.fromJson));
    }
    allQuestions = questions;
    notifyListeners();
  }

  /// Gather preferences from users, such as how many questions they want, tags,
  /// and difficulty level etc, then generate a list of [QuizItem]s to use.
  void setup(/* get some params from user */) {
    // TODO - do a proper setup. For now let's just take 2 questions at random.
    quizItems =
        (allQuestions!..shuffle()).take(2).map<QuizItem>(QuizItem.new).toList();
  }

  @override
  bool operator ==(Object other) {
    return other is QuizModel && allQuestions == other.allQuestions;
  }

  @override
  int get hashCode => allQuestions.hashCode;
}

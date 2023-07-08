import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter_interview_questions/model/difficulty.dart';
import 'package:flutter_interview_questions/model/quiz_item.dart';
import 'package:http/http.dart' as http;

import 'question.dart';

export '../components/provider.dart';
export 'question.dart';

class QuizModel extends ChangeNotifier {
  Map<String, List<Question>>?
      allQuestions; // all questions in the knowledge base

  late List<QuizItem> quizItems; // a set of questions used for a quiz

  bool isLoading = false;

  bool get completed => quizItems.every((item) => item.answered);

  QuizModel() {
    fetchAllQuestions();
  }

  Future fetchAllQuestions() async {
    const root = 'https://raw.githubusercontent.com/h65wang'
        '/flutter_interview_questions/main/public';
    isLoading = true;
    notifyListeners();

    final res = await http.get(Uri.parse('$root/index.json'));

    isLoading = false;
    notifyListeners();

    if (res.statusCode != 200) throw Exception('Network ex: ${res.body}');
    final json = convert.jsonDecode(res.body) as Map<String, dynamic>;
    Map<String, List<Question>> resultTemp = {};
    for (final filename in json['questions']) {
      final res = await http.get(Uri.parse('$root/$filename'));
      if (res.statusCode != 200) throw Exception('Network ex: ${res.body}');
      final json = convert.jsonDecode(res.body) as List<dynamic>;
      final questionsTemp = json
          .map<Question>(
              (dynamic e) => Question.fromJson(e as Map<String, dynamic>))
          .toList();
      resultTemp.putIfAbsent(filename as String, () => questionsTemp);
    }
    allQuestions = resultTemp;
    notifyListeners();
  }

  /// Gather preferences from users, such as how many questions they want, tags,
  /// and difficulty level etc, then generate a list of [QuizItem]s to use.
  void setup({
    required int count,
    required Set<String> selectedTags,
    required Set<Difficulty> selectedDifficulty,
  }) {
    var resultTemp = allQuestions!.values.expand((e) => e);
    if (selectedDifficulty.length != Difficulty.values.length) {
      resultTemp = resultTemp.where((e) => selectedDifficulty
          .any((element) => (element.index + 1) == e.difficulty));
    }
    if (selectedTags.length != allQuestions!.length) {
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

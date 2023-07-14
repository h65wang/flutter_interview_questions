import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_interview_questions/model/difficulty.dart';
import 'package:flutter_interview_questions/model/quiz_item.dart';
import 'package:http/http.dart' as http;

import 'question.dart';

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
  Map<String, List<Question>> allQuestions =
      {}; // all questions in the knowledge base

  late List<QuizItem> quizItems; // a set of questions used for a quiz

  int get totalCount => allQuestions.values.expand((e) => e).length;

  QuizStatus _status = QuizStatus.loading;

  QuizStatus get status => _status;

  bool get completed => quizItems.every((item) => item.answered);

  QuizModel() {
    fetchAllQuestions();
  }

  Future<void> fetchAllQuestions() async {
    _status = QuizStatus.loading;
    notifyListeners();
    const root = 'https://raw.githubusercontent.com/h65wang/'
        'flutter_interview_questions/main/public';
    try {
      final res = await http
          .get(Uri.parse('$root/index.json'))
          .timeout(Duration(seconds: 5));
      if (res.statusCode != 200) {
        print('Network ex: ${res.body}');
        _status = await _fetchLocalQuestions();
        notifyListeners();
      }
      final json = convert.jsonDecode(res.body) as Map<String, dynamic>;
      Map<String, List<Question>> resultTemp = {};
      for (final filename in json['questions']) {
        final res = await http
            .get(Uri.parse('$root/$filename'))
            .timeout(Duration(seconds: 5));
        if (res.statusCode != 200) {
          print('Network ex: ${res.body}');
          _status = await _fetchLocalQuestions();
          notifyListeners();
          break;
        }
        final json = convert.jsonDecode(res.body) as List<dynamic>;
        final questionsTemp = json
            .map<Question>(
                (dynamic e) => Question.fromJson(e as Map<String, dynamic>))
            .toList();
        resultTemp.putIfAbsent(filename as String, () => questionsTemp);
      }
      allQuestions = resultTemp;
      _status = resultTemp.isEmpty ? QuizStatus.empty : QuizStatus.display;
      notifyListeners();
      print('loaded from Network');
    } catch (e) {
      print('Network ex:$e');
      _status = await _fetchLocalQuestions();
      notifyListeners();
    }
  }

  /// Fetch questions from local assets, for testing purpose.
  Future<QuizStatus> _fetchLocalQuestions() async {
    var status = QuizStatus.error;
    try {
      final root = 'public';
      final localRootJsonStr = await rootBundle.loadString('$root/index.json');
      final json = convert.jsonDecode(localRootJsonStr) as Map<String, dynamic>;
      Map<String, List<Question>> resultTemp = {};
      for (final filename in json['questions']) {
        final localJsonStr = await rootBundle.loadString('$root/$filename');
        final json = convert.jsonDecode(localJsonStr) as List<dynamic>;
        final questionsTemp = json
            .map<Question>(
                (dynamic e) => Question.fromJson(e as Map<String, dynamic>))
            .toList();
        resultTemp.putIfAbsent(filename as String, () => questionsTemp);
      }
      allQuestions = resultTemp;
      status = resultTemp.isEmpty ? QuizStatus.empty : QuizStatus.display;
      print('loaded from local');
    } catch (e) {
      print('Local ex:$e');
      status = QuizStatus.error;
    }
    return status;
  }

  /// Gather preferences from users, such as how many questions they want, tags,
  /// and difficulty level etc, then generate a list of [QuizItem]s to use.
  void setup({
    required int count,
    required Set<String> selectedTags,
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

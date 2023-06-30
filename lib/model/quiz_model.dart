import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'question.dart';

export 'provider.dart';
export 'question.dart';

class QuizModel extends ChangeNotifier {
  List<Question>? questions;

  QuizModel() {
    fetch();
  }

  Future fetch() async {
    const url = 'https://raw.githubusercontent.com/h65wang'
        '/flutter_interview_questions/main/lib/hosted/questions.json';
    final res = await http.get(Uri.parse(url));
    await Future.delayed(const Duration(seconds: 1));
    if (res.statusCode != 200) throw Exception('Network ex: ${res.body}');
    final json = convert.jsonDecode(res.body);
    questions = json.map<Question>(Question.fromJson).toList();
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return other is QuizModel && questions == other.questions;
  }

  @override
  int get hashCode => questions.hashCode;
}

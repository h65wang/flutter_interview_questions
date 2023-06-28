import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'question.dart';

export 'question.dart';

class Repo extends ChangeNotifier {
  List<Question>? questions;

  Repo() {
    fetch();
  }

  Future fetch() async {
    const url = 'https://raw.githubusercontent.com/h65wang'
        '/flutter_interview_questions/main/lib/hosted/questions.json';
    final res = await http.get(Uri.parse(url));
    await Future.delayed(const Duration(seconds: 2));
    if (res.statusCode != 200) throw Exception('Network ex: ${res.body}');
    final json = convert.jsonDecode(res.body);
    questions = json.map<Question>(Question.fromJson).toList();
    notifyListeners();
  }
}

class RepoProvider extends InheritedWidget {
  static Repo? _repo;

  RepoProvider({
    super.key,
    required super.child,
    required Repo Function() create,
  }) {
    if (_repo != null) return;
    _repo = create();
  }

  Repo get repo => _repo!;

  static RepoProvider of(BuildContext context) {
    final repo = context.dependOnInheritedWidgetOfExactType<RepoProvider>();
    if (repo == null) throw Exception('`RepoProvider` not found.');
    return repo;
  }

  @override
  bool updateShouldNotify(RepoProvider oldWidget) {
    return repo != oldWidget.repo;
  }
}

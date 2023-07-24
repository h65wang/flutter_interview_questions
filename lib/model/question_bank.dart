import 'dart:convert' as convert;

import 'package:flutter/services.dart' show rootBundle;

import 'language_item.dart';
import 'question.dart';

/// A [Bank] consists of all questions in the entire database.
/// They are grouped by languages. For each [LanguageItem], there can be
/// multiple files. Each file is called a [QuestionSet], which contains of
/// multiple questions that focuses on a theme.
typedef Bank = Map<LanguageItem, List<QuestionSet>>;

class QuestionSet {
  final String name;
  final String description;
  final String? author;
  final List<Question> questions;

  QuestionSet({
    required this.name,
    required this.description,
    required this.author,
    required this.questions,
  });

  factory QuestionSet.fromJson(dynamic json) => QuestionSet(
        name: json['name'] as String,
        description: json['description'] as String,
        author: json['author'] as String?,
        questions: (json['questions'] as List).map(Question.fromJson).toList(),
      );
}

class QuestionBank {
  static Future<Bank> getAllQuestions() async {
    // Fetch `index` to get the list of files for all locale
    List index;
    try {
      index = await _loadUrlAsJson('index.json') as List;
    } catch (_) {
      index = await _loadFileAsJson('index.json') as List;
    }
    final languages = index.map(LanguageItem.fromJson).toList();

    // Construct question bank by reading all files
    final Bank bank = {};
    for (final lang in languages) {
      final sets = <QuestionSet>[];
      for (final file in lang.files) {
        final dynamic json = await _loadFileAsJson('${lang.folder}/$file');
        final questionSet = QuestionSet.fromJson(json);
        sets.add(questionSet);
      }
      bank[lang] = sets;
    }
    return bank;
  }

  static Future<dynamic> _loadUrlAsJson(String url) async {
    throw UnimplementedError();
  }

  static Future<dynamic> _loadFileAsJson(String filename) async {
    const root = 'assets/questions';
    final file = await rootBundle.loadString('$root/$filename');
    final dynamic json = convert.jsonDecode(file);

    return json;
  }
}

import 'dart:convert' as convert;

import 'package:flutter/services.dart' show rootBundle;

import 'language_item.dart';
import 'question.dart';

typedef Bank = Map<LanguageItem, List<Question>>;

class QuestionBank {
  static Future<Bank> getAllQuestions() async {
    // Fetch `index` to get the list of files for all locale
    List index;
    try {
      index = await _loadUrlAsJson('index.json');
    } catch (_) {
      index = await _loadFileAsJson('index.json');
    }
    final languages = index.map(LanguageItem.fromJson).toList();

    // Construct question bank, group questions by locale
    final Bank bank = {};
    for (final lang in languages) {
      final questions = <Question>[];
      for (final file in lang.files) {
        final json = await _loadFileAsJson('${lang.folder}/$file');
        final q = json.map(Question.fromJson).toList();
        questions.addAll(q);
      }
      bank[lang] = questions;
    }
    return bank;
  }

  static Future<List<dynamic>> _loadUrlAsJson(String url) async {
    throw UnimplementedError();
  }

  static Future<List<dynamic>> _loadFileAsJson(String filename) async {
    const root = 'assets/questions';
    final file = await rootBundle.loadString('$root/$filename');
    final json = convert.jsonDecode(file) as List<dynamic>;
    return json;
  }
}

import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'language_item.dart';
import 'question.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AssetReader().loadFileList();
}

class AssetReader {
  late final Map<LanguageItem, List<Question>> _bank;

  Future loadFileList() async {
    List index;
    try {
      index = await _loadUrlAsJson('index.json');
    } catch (_) {
      index = await _loadFileAsJson('index.json');
    }
    final languages = index.map(LanguageItem.fromJson).toList();

    final Map<LanguageItem, List<Question>> bank = {};

    for (final lang in languages) {
      final questions = <Question>[];
      for (final file in lang.files) {
        final json = await _loadFileAsJson('/${lang.folder}/$file');
        final q = json.map(Question.fromJson).toList();
        questions.addAll(q);
      }
      bank[lang] = questions;
    }

    _bank = Map.unmodifiable(bank);
  }

  Future<List<dynamic>> _loadUrlAsJson(String url) async {
    throw UnimplementedError();
  }

  Future<List<dynamic>> _loadFileAsJson(String filename) async {
    const root = 'assets/questions';
    final file = await rootBundle.loadString('$root/$filename');
    final json = convert.jsonDecode(file) as List<dynamic>;
    return json;
  }
}

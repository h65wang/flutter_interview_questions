import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AssetReader().loadFileList();
}

class AssetReader {
  Future loadFileList() async {
    List<dynamic> index;
    try {
      index = await loadUrlAsJson('index.json');
    } catch (_) {
      index = await loadFileAsJson('index.json');
    }
    print(index);
  }

  Future<List<dynamic>> loadUrlAsJson(String url) async {
    throw UnimplementedError();
  }

  Future<List<dynamic>> loadFileAsJson(String filename) async {
    const root = 'assets/questions';
    final file = await rootBundle.loadString('$root/$filename');
    final json = convert.jsonDecode(file) as List<dynamic>;
    return json;
  }
}

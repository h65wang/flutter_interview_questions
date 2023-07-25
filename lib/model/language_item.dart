class LanguageItem {
  final String lang;
  final String locale;
  final String folder;
  final List<String> files;

  final Map<String, dynamic> translations;

  LanguageItem.fromJson(dynamic json)
      : lang = json['lang'] as String,
        locale = json['locale'] as String,
        folder = json['folder'] as String,
        files = List<String>.from(json['files'] as List<dynamic>),
        translations = (json['translations'] as Map<String, dynamic>);

  @override
  String toString() => '$lang: $files';
}

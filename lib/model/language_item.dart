
class LanguageItem {
  final String lang;
  final String locale;
  final String folder;
  final List<String> files;

  LanguageItem.fromJson(dynamic json)
      : lang = json['lang'] as String,
        locale = json['locale'] as String,
        folder = json['folder'] as String,
        files = List<String>.from(json['files'] as List<dynamic>);

  @override
  String toString() => '$lang: $files';
}

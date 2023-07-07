import 'common.dart';

/// Describe a question from the knowledge base, stored in JSON format.
class Question {
  final String title;
  final String answer;
  final List<String> candidates;
  final List<String> tags;
  final int? difficulty;
  final String? credit;

  Question.fromJson(Json json)
      : title = as<String>(json['title'] ?? json['question'], '')!,
        answer = as<String>(json['answer'], '')!,
        candidates = List.from(as<List>(json['candidates'], <String>[])!),
        tags = List.from(as<List>(json['tags'], <String>[])!),
        difficulty = as<int>(json['difficulty']),
        credit = as<String>(json['credit']);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'answer': answer,
        'candidates': candidates,
        'tags': tags,
        'difficulty': difficulty,
        'credit': credit,
      };

  @override
  String toString() =>
      'Q(${title.length > 20 ? '${title.substring(0, 17)}...' : title})';
}

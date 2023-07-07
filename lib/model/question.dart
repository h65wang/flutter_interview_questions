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
      : title = (json['title'] ?? json['question']) as String,
        answer = json['answer'] as String,
        candidates = List.from(json['candidates'] as List),
        tags = List.from(json['tags'] as List),
        difficulty = json['difficulty'] as int?,
        credit = json['credit'] as String?;

  Json toJson() => <String, dynamic>{
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

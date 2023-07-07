/// Describe a question from the knowledge base, stored in JSON format.
class Question {
  final String title;
  final String answer;
  final List<String> candidates;
  final List<String> tags;
  final int? difficulty;
  final String? credit;

  Question.fromJson(Map<String, dynamic> json)
      : title = '${json['title'] ?? json['question']}',
        answer = '${json['answer']}',
        candidates = (json['candidates'] is List)
            ? List<String>.from(json['candidates'] as List)
            : [],
        tags = (json['tags'] is List)
            ? List<String>.from(json['tags'] as List)
            : [],
        difficulty =
            (json['difficulty'] is int) ? (json['difficulty'] as int) : 0,
        credit = '${json['credit']}';

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

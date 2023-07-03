/// Describe a question from the knowledge base, stored in JSON format.
class Question {
  final String title;
  final String answer;
  final List<String> candidates;
  final List<String> tags;
  final int? difficulty;
  final String? credit;

  Question.fromJson(json)
      : title = json['title'] ?? json['question'],
        answer = json['answer'],
        candidates = List.from(json['candidates']),
        tags = List.from(json['tags']),
        difficulty = json['difficulty'],
        credit = json['credit'];

  Map<String, dynamic> toJson() => {
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

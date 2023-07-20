/// A question from the knowledge base, stored in JSON format.
class Question {
  final String title;
  final List<String> answers;
  final List<String> candidates;

  Question.fromJson(dynamic json)
      : title = json['title'] as String,
        answers = List.from(json['answers'] as List),
        candidates = List.from(json['candidates'] as List);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'answer': answers,
        'candidates': candidates,
      };

  @override
  String toString() =>
      'Q(${title.length > 20 ? '${title.substring(0, 17)}...' : title})';
}

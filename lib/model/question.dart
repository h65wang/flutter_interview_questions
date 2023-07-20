/// A question from the knowledge base, stored in JSON format.
class Question {
  final String title;
  final List<String> answers;
  final List<String> candidates;

  const Question({
    required this.title,
    required this.answers,
    required this.candidates,
  });

  factory Question.fromJson(dynamic json) {
    final String title;
    final List<String> answers;
    final List<String> candidates;
    try {
      title = json['title'] as String;
      answers = List.from(json['answers'] as List);
      candidates = List.from(json['candidates'] as List);
      return Question(title: title, answers: answers, candidates: candidates);
    } catch (ex) {
      print('$ex: $json');
      rethrow;
    }
  }

  @override
  String toString() =>
      'Q(${title.length > 20 ? '${title.substring(0, 17)}...' : title})';
}

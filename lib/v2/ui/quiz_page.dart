import 'package:flutter/material.dart';

import '../model/quiz_item.dart';
import '../model/quiz_model.dart';
import '../widget/selector_group.dart';

class QuizPage extends StatefulWidget {
  final QuizModel model;

  const QuizPage({Key? key, required this.model}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Quiz Page!'),
      ),
      body: ListView.builder(
        itemCount: widget.model.questions.length,
        itemBuilder: (BuildContext context, int index) {
          final q = widget.model.questions[index];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: _QuizItemCard(q),
          );
        },
      ),
    );
  }
}

class _QuizItemCard extends StatefulWidget {
  final QuizItem q;

  const _QuizItemCard(this.q, {Key? key}) : super(key: key);

  @override
  State<_QuizItemCard> createState() => _QuizItemCardState();
}

class _QuizItemCardState extends State<_QuizItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.q.question.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SelectorGroup<Choice>(
            items: widget.q.choices,
            selected: widget.q.choices.where((c) => c.selected).toList(),
            onTap: (Choice c) {
              widget.q.choose(c);
              setState(() {});
            },
            display: (Choice c) => c.content,
          ),
        ],
      ),
    );
  }
}

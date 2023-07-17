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
  bool _reviewing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Quiz Page!'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final q = widget.model.questions[index];
                return Center(
                  child: SizedBox(
                    width: 800,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: _QuizItemCard(
                        quizItem: q,
                        showWarning: _reviewing,
                      ),
                    ),
                  ),
                );
              },
              childCount: widget.model.questions.length,
            ),
          ),
          SliverToBoxAdapter(
            child: SafeArea(
              minimum: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    _reviewing = true;
                  }),
                  child: Text('Review'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizItemCard extends StatefulWidget {
  final QuizItem quizItem;
  final bool showWarning;

  const _QuizItemCard({required this.quizItem, required this.showWarning});

  @override
  State<_QuizItemCard> createState() => _QuizItemCardState();
}

class _QuizItemCardState extends State<_QuizItemCard> {
  @override
  Widget build(BuildContext context) {
    final q = widget.quizItem;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              q.question.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (q.warning != null && widget.showWarning)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                q.warning!,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          SelectorGroup<Choice>(
            items: q.choices,
            selected: q.choices.where((c) => c.selected).toList(),
            onTap: (Choice c) => setState(() {
              q.choose(c);
            }),
            display: (Choice c) => c.content,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../model/quiz_item.dart';
import '../model/quiz_model.dart';
import '../widget/multi_select_widget.dart';
import '../widget/single_select_widget.dart';

class QuizPage extends StatefulWidget {
  final QuizModel model;

  const QuizPage({Key? key, required this.model}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // After the user clicks submit at least once, we will highlight any
  // questions that they did not provide an answer.
  bool _reviewed = false;

  // After the user submits, we lock all answers so they cannot change them.
  // And we reveal the result (correct/incorrect).
  bool _submitted = false;

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
                      child: IgnorePointer(
                        ignoring: _submitted,
                        child: _QuizItemCard(
                          quizItem: q,
                          showUnanswered: _reviewed,
                          showGrading: _submitted,
                        ),
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
                child: _submitted
                    ? ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Go back'),
                      )
                    : FilledButton(
                        onPressed: _submit,
                        child: Text('Review & Submit'),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    final confirmSubmit = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final ready = widget.model.completed;
        return AlertDialog(
          title: Text(ready ? 'Ready to submit' : 'Missing answers'),
          content: Text(ready
              ? 'You have answered all questions.'
              : 'Not all questions have been answered. '
                  'Please go back and review.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Go back'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                ready ? 'Submit' : 'Submit anyway',
                style: ready ? null : TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
    if (confirmSubmit ?? false) {
      setState(() => _submitted = true);
    } else {
      setState(() => _reviewed = true);
    }
  }
}

class _QuizItemCard extends StatefulWidget {
  final QuizItem quizItem;
  final bool showUnanswered; // display "answer not provided" if unanswered
  final bool showGrading; // display grading (correct or incorrect)

  const _QuizItemCard({
    required this.quizItem,
    required this.showUnanswered,
    required this.showGrading,
  });

  @override
  State<_QuizItemCard> createState() => _QuizItemCardState();
}

class _QuizItemCardState extends State<_QuizItemCard> {
  late int singleSelectIndex;

  @override
  void initState() {
    super.initState();
    singleSelectIndex = -1;
    print('_QuizItemCardState.initState');
  }

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
          if ((widget.showUnanswered || widget.showGrading) && !q.answered)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "No answer provided",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (widget.showGrading && q.answered)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                q.correct ? "Correct" : "Incorrect",
                style: TextStyle(
                  color: q.correct ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          _buildSelectWidget(q),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSelectWidget(QuizItem q) {
    if (q.hasMultipleAnswers)
      return MultiSelectWidget(
        items: q.choices,
        onTap: () {
          setState(() {});
        },
      );
    return SingleSelectWidget(
      items: q.choices,
      index: singleSelectIndex,
      onTap: (value) {
        setState(
          () {
            q.choices.forEach((element) {
              element.selected = false;
            });
            value.selected = true;
          },
        );
      },
    );
  }
}

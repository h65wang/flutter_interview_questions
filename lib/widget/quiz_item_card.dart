import 'package:flutter/material.dart';

import '../model/quiz_item.dart';
import 'markdown.dart';

class QuizItemCard extends StatefulWidget {
  final QuizItem quizItem;
  final bool showUnanswered; // display "answer not provided" if unanswered
  final bool showGrading; // display grading (correct or incorrect)

  const QuizItemCard({
    required this.quizItem,
    required this.showUnanswered,
    required this.showGrading,
  });

  @override
  State<QuizItemCard> createState() => _QuizItemCardState();
}

class _QuizItemCardState extends State<QuizItemCard> {
  @override
  Widget build(BuildContext context) {
    final q = widget.quizItem;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Markdown(
              q.question.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
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
          for (final choice in q.choices)
            _ChoiceItem(
              choice: choice,
              allowMultiSelect: q.hasMultipleAnswers,
              onTap: () => setState(() => q.choose(choice)),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ChoiceItem extends StatelessWidget {
  final Choice choice;
  final bool allowMultiSelect;
  final VoidCallback onTap;

  const _ChoiceItem({
    required this.choice,
    required this.allowMultiSelect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (allowMultiSelect) {
      child = CheckboxListTile(
        title: Markdown(choice.content),
        controlAffinity: ListTileControlAffinity.leading,
        value: choice.selected,
        onChanged: (_) {},
      );
    } else {
      child = RadioListTile(
        title: Markdown(choice.content),
        value: choice.selected,
        groupValue: true,
        onChanged: (_) {},
      );
    }

    return InkWell(
      onTap: onTap,
      child: IgnorePointer(
        child: child,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/model/quiz_model.dart';
import 'package:flutter_interview_questions/result/result_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    final quizItems = context.watch<QuizModel>().quizItems;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Quiz Page'),
      ),
      body: quizItems.isEmpty
          ? const Center(
              child: Text(
                'There are no matching questions in the question bank',
              ),
            )
          : Column(
              children: [
                const _Overview(),
                const Divider(),
                Expanded(
                  child: PageView.builder(
                    itemCount: quizItems.length,
                    itemBuilder: (_, int index) => _PageItem(index),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Submit',
        child: const Icon(Icons.done),
        onPressed: () {
          final completed = quizItems.every((item) => item.answered);
          if (!completed) {
            // TODO: alert dialog if they haven't answered all questions yet
            print('you are missing some answers');
          }
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ResultPage()),
          );
        },
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quizItems = context.watch<QuizModel>().quizItems;
    return Wrap(
      children: [
        for (final item in quizItems)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 40,
            height: 40,
            color: item.answered ? Colors.green.shade200 : Colors.grey,
            // TODO: ^ this panel does not refresh, when user selects answers
          ),
      ],
    );
  }
}

class _PageItem extends StatefulWidget {
  final int index;

  const _PageItem(this.index, {Key? key}) : super(key: key);

  @override
  State<_PageItem> createState() => _PageItemState();
}

class _PageItemState extends State<_PageItem> {
  @override
  Widget build(BuildContext context) {
    final item = context.watch<QuizModel>().quizItems[widget.index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(item.question.title),
        const Divider(),
        for (final choice in item.choices)
          ListTile(
            title: Text(choice.content),
            selected: choice.selected,
            selectedColor: Colors.black,
            selectedTileColor: Colors.green.shade200,
            onTap: () => setState(() => choice.selected = !choice.selected),
          ),
      ],
    );
  }
}

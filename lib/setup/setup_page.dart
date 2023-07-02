import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/quiz/quiz_page.dart';

import '../model/quiz_model.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final allQuestions = context.watch<QuizModel>().allQuestions;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Setup'),
      ),
      body: allQuestions != null
          ? const _SelectionArea()
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _SelectionArea extends StatelessWidget {
  const _SelectionArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('TODO: Select questions'),
          const Text('Total: 2 questions'),
          const Text('Tags: any'),
          const Text('Difficulty: any'),
          ElevatedButton(
            onPressed: () {
              context.read<QuizModel>().setup();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const QuizPage()),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

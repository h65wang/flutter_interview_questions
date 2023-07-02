import 'package:flutter/material.dart';

import '../model/quiz_model.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final quizItems = context.watch<QuizModel>().quizItems;
    final int corrects = quizItems.where((item) => item.correct).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Result'),
      ),
      body: Center(
        child: Text('You got $corrects/${quizItems.length}'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'model/quiz_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: () => QuizModel(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final questions = context.watch<QuizModel>().questions;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('FiQ'),
      ),
      body: questions != null
          ? ListView.builder(
              itemCount: questions.length,
              itemBuilder: (_, index) {
                final q = questions[index];
                return ListTile(
                  title: Text(q.title),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

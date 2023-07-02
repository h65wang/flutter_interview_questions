import 'package:flutter/material.dart';

import 'model/quiz_model.dart';
import 'setup/setup_page.dart';

void main() {
  runApp(const MyApp());
}

/// First, we take users to [SetupPage], where they customize their questions.
/// Then we take them to [QuizPage] for the main thing.
/// Lastly we take them to [ResultPage] for victory!
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
        home: const SetupPage(),
      ),
    );
  }
}

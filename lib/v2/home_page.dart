import 'package:flutter/material.dart';

import 'model/question_bank.dart';
import 'ui/welcome_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Bank> fetcher = QuestionBank.getAllQuestions();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetcher,
      builder: (_, AsyncSnapshot<Bank> snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorSchemeSeed: Colors.blue,
              useMaterial3: true,
            ),
            home: WelcomePage(bank: snapshot.data!),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

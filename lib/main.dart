import 'package:flutter/material.dart';

import 'model/question_bank.dart';
import 'ui/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Bank> fetcher = QuestionBank.getAllQuestions();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Interview Questions',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: fetcher,
        builder: (_, AsyncSnapshot<Bank> snapshot) {
          if (snapshot.hasData) {
            return WelcomePage(bank: snapshot.data!);
          }
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

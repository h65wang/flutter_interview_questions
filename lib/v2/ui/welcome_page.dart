import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/v2/model/quiz_model.dart';

import '../model/language_item.dart';
import '../model/question_bank.dart';
import '../widget/selector_group.dart';
import 'quiz_page.dart';

class WelcomePage extends StatefulWidget {
  final Bank bank;

  const WelcomePage({Key? key, required this.bank}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Current language being selected.
  late LanguageItem _language = widget.bank.keys.first;

  // [QuestionSet] being selected. By default we select everything.
  late Set<QuestionSet> _sets = widget.bank.values.expand((s) => s).toSet();

  // A list of questions that matches user's preference on language and sets.
  List<Question> get selectedQuestions => widget.bank[_language]!
      .where((s) => _sets.contains(s))
      .expand((s) => s.questions)
      .toList();

  @override
  Widget build(BuildContext context) {
    print('selected lan: $_language');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Welcome!'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            SizedBox(
              width: 600,
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Select language:",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SelectorGroup<LanguageItem>(
                      items: widget.bank.keys.toList(),
                      selected: [_language],
                      onTap: (LanguageItem it) => setState(() {
                        _language = it;
                      }),
                      display: (LanguageItem it) => it.lang,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 600,
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Select question set(s):',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SelectorGroup<QuestionSet>(
                      items: widget.bank[_language]!,
                      selected: _sets,
                      onTap: (QuestionSet it) => setState(() {
                        if (_sets.contains(it)) {
                          _sets.remove(it);
                        } else {
                          _sets.add(it);
                        }
                      }),
                      display: (QuestionSet set) => set.name,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: selectedQuestions.isNotEmpty ? _startQuiz : null,
              child: Text("Let's go!"),
            ),
          ],
        ),
      ),
    );
  }

  void _startQuiz() {
    final model = QuizModel(selectedQuestions..shuffle());
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => QuizPage(model: model),
      ),
    );
  }
}

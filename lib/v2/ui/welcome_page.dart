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
  late LanguageItem _language = widget.bank.keys.first;
  late Set<QuestionSet> _sets = widget.bank[_language]!.toSet();

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
            Text("Select language:"),
            SelectorGroup<LanguageItem>(
              items: widget.bank.keys.toList(),
              selected: [_language],
              onTap: (LanguageItem it) => setState(() {
                _language = it;
              }),
            ),
            Divider(),
            Text('Select question set(s):'),
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final q = _sets.expand((s) => s.questions).toList();
                final model = QuizModel(q..shuffle());
                Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (_) => QuizPage(model: model),
                  ),
                );
              },
              child: Text("Let's go!"),
            ),
          ],
        ),
      ),
    );
  }
}

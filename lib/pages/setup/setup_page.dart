import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/components/toast.dart';
import 'package:flutter_interview_questions/model/language_item.dart';
import 'package:flutter_interview_questions/widget/error_displayer.dart';
import 'package:flutter_interview_questions/widget/status_widget.dart';

import '../../config/constants.dart';
import '../../model/difficulty.dart';
import '../../model/quiz_model.dart';
import '../quiz/quiz_page.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<QuizModel>().status;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: AnimatedSwitcher(
          duration: k300MS,
          child: StatusWidget(
            status: status,
            contentWidget: (_) => _SelectionArea(),
            onRefresh: () {},
          ),
        ),
      ),
    );
  }
}

class _SelectionArea extends StatefulWidget {
  const _SelectionArea({Key? key}) : super(key: key);

  @override
  State<_SelectionArea> createState() => _SelectionAreaState();
}

class _SelectionAreaState extends State<_SelectionArea> {
  late final quizModel = context.read<QuizModel>();
  late final ValueNotifier<int> _questionsCount = ValueNotifier<int>(
    quizModel.allQuestions.values.expand((e) => e).length,
  );
  late final ValueNotifier<Set<LanguageItem>> _selectedTags =
      ValueNotifier<Set<LanguageItem>>(
    quizModel.allQuestions.keys.toSet(),
  );
  final ValueNotifier<Set<Difficulty>> _selectedDifficulty = ValueNotifier(
    {Difficulty.easy},
  );

  @override
  Widget build(BuildContext context) {
    final totalCount = quizModel.totalCount;
    final themeData = Theme.of(context);

    final quizCountPicker = ListTile(
      title: Text(
        'Total: $totalCount questions',
        style: themeData.textTheme.titleLarge,
      ),
      subtitle: ValueListenableBuilder(
        valueListenable: _questionsCount,
        builder: (_, questionsCount, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select number of questions: $questionsCount',
              style: themeData.textTheme.bodyMedium,
            ),
            if (totalCount > 1)
              Slider(
                value: questionsCount.toDouble(),
                min: 1,
                max: totalCount.toDouble(),
                divisions: totalCount - 1,
                label: questionsCount.toString(),
                onChanged: (e) {
                  _questionsCount.value = e.toInt();
                },
              ),
          ],
        ),
      ),
    );

    final tagPicker = ValueListenableBuilder(
      valueListenable: _selectedTags,
      builder: (context, selectedTags, __) => Card(
        child: ExpansionTile(
          title: Text(
            'Select Tags (${selectedTags.length}/${quizModel.allQuestions.length})',
            style: themeData.textTheme.titleMedium,
          ),
          initiallyExpanded: true,
          children: [
            ...quizModel.allQuestions.keys
                .map((key) => CheckboxListTile(
                      value: selectedTags.contains(key),
                      title: Text(key.lang),
                      onChanged: (e) {
                        if (e == null) return;
                        final resultTemp = selectedTags.toSet();
                        if (e) {
                          resultTemp.add(key);
                        } else {
                          resultTemp.remove(key);
                        }
                        _selectedTags.value = resultTemp;
                      },
                    ))
                .toList(),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 16),
              child: ErrorDisplayer(
                errorText: selectedTags.isEmpty ? 'Choose at least one' : null,
              ),
            ),
          ],
        ),
      ),
    );

    final difficultyPicker = ValueListenableBuilder(
      valueListenable: _selectedDifficulty,
      builder: (context, selectedDifficulty, __) => Card(
        child: ExpansionTile(
          title: Text(
            'Select Difficulty',
            style: themeData.textTheme.titleMedium,
          ),
          initiallyExpanded: true,
          subtitle: Text(
            Difficulty.values
                .map((e) =>
                    '${e.name}: ${selectedDifficulty.contains(e).pictoChar}')
                .join(', '),
            style: themeData.textTheme.titleSmall,
          ),
          children: [
            ...Difficulty.values
                .map((difficultyValue) => CheckboxListTile(
                      value: selectedDifficulty.contains(difficultyValue),
                      title: Text(difficultyValue.name),
                      onChanged: (e) {
                        if (e == null) return;
                        final resultTemp = selectedDifficulty.toSet();
                        if (e) {
                          resultTemp.add(difficultyValue);
                        } else {
                          resultTemp.remove(difficultyValue);
                        }
                        _selectedDifficulty.value = resultTemp;
                      },
                    ))
                .toList(),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 16),
              child: ErrorDisplayer(
                errorText:
                    selectedDifficulty.isEmpty ? 'Choose at least one' : null,
              ),
            ),
          ],
        ),
      ),
    );

    final checkoutButton = ListTile(
      title: FilledButton(
        onPressed: () {
          if (_selectedTags.value.isEmpty ||
              _selectedDifficulty.value.isEmpty) {
            Toast.show('Choose at least one');
            return;
          }
          quizModel.setup(
            count: _questionsCount.value,
            selectedTags: _selectedTags.value,
            selectedDifficulty: _selectedDifficulty.value,
          );
          if (quizModel.quizItems.isEmpty) {
            Toast.show(
              'There are no matching questions in the question bank',
            );
            return;
          }
          Navigator.of(context).push<void>(
            MaterialPageRoute(builder: (_) => const QuizPage()),
          );
        },
        child: const Text('OK'),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          children: [
            quizCountPicker,
            if (constraints.maxWidth > 640)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: tagPicker),
                  SizedBox(width: 16),
                  Expanded(child: difficultyPicker),
                ],
              )
            else ...[
              tagPicker,
              difficultyPicker,
            ],
            checkoutButton,
          ],
        );
      },
    );
  }
}

extension on bool {
  String get pictoChar => this ? '√' : '×';
}

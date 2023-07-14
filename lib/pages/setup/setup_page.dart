import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/components/toast.dart';
import 'package:flutter_interview_questions/config/constants.dart';
import 'package:flutter_interview_questions/model/difficulty.dart';
import 'package:flutter_interview_questions/model/quiz_model.dart';
import 'package:flutter_interview_questions/pages/quiz/quiz_page.dart';
import 'package:flutter_interview_questions/widget/error_displayer.dart';
import 'package:flutter_interview_questions/widget/status_widget.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<QuizModel>().status;
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: AnimatedSwitcher(
        duration: k300MS,
        child: StatusWidget(
          status: status,
          contentWidget: (_) => _SelectionArea(),
          onRefresh: context.read<QuizModel>().fetchAllQuestions,
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
  late final ValueNotifier<Set<String>> _selectedTags =
      ValueNotifier<Set<String>>(
    quizModel.allQuestions.keys.toSet(),
  );
  final ValueNotifier<Set<Difficulty>> _selectedDifficulty = ValueNotifier(
    {Difficulty.easy},
  );

  @override
  Widget build(BuildContext context) {
    final totalCount = quizModel.totalCount;
    final themeData = Theme.of(context);
    return ListView(
      children: [
        ListTile(
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
        ),
        ValueListenableBuilder(
          valueListenable: _selectedTags,
          builder: (context, selectedTags, __) => Card(
            child: ExpansionTile(
              title: Text(
                'Select Tags (${selectedTags.length}/${quizModel.allQuestions.length})',
                style: themeData.textTheme.titleMedium,
              ),
              children: [
                ...quizModel.allQuestions.keys
                    .map((key) => CheckboxListTile(
                          value: selectedTags.contains(key),
                          title: Text(key),
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
                    errorText:
                        selectedTags.isEmpty ? 'Choose at least one' : null,
                  ),
                ),
              ],
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _selectedDifficulty,
          builder: (context, selectedDifficulty, __) => Card(
            child: ExpansionTile(
              title: Text(
                'Select Difficulty',
                style: themeData.textTheme.titleMedium,
              ),
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
                    errorText: selectedDifficulty.isEmpty
                        ? 'Choose at least one'
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          title: FilledButton(
            onPressed: () {
              if (_selectedTags.value.isEmpty ||
                  _selectedDifficulty.value.isEmpty) {
                Toast.show('Choose at least one');
                return;
              }
              quizModel.setup(
                count: _questionsCount.value,
                selectedTags: _selectedTags.value
                    .map(_indexItem2Tag)
                    .whereType<String>()
                    .toSet(),
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
        ),
      ],
    );
  }

  String? _indexItem2Tag(String value) =>
      RegExp(r'/([^/]+).json').firstMatch(value)?.group(1);
}

extension on bool {
  String get pictoChar => this ? '√' : '×';
}

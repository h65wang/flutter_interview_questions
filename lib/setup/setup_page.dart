import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/model/difficulty.dart';
import 'package:flutter_interview_questions/model/quiz_model.dart';
import 'package:flutter_interview_questions/quiz/quiz_page.dart';


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

class _SelectionArea extends StatefulWidget {
  const _SelectionArea({Key? key}) : super(key: key);

  @override
  State<_SelectionArea> createState() => _SelectionAreaState();
}

class _SelectionAreaState extends State<_SelectionArea> {
  late final ValueNotifier<int> _questionsCount = ValueNotifier(
      context.read<QuizModel>().allQuestions!.values.expand((e) => e).length);
  late final ValueNotifier<Set<String>> _selectedTags =
      ValueNotifier(context.read<QuizModel>().allQuestions!.keys.toSet());
  late final ValueNotifier<Set<Difficulty>> _selectedDifficulty =
      ValueNotifier({Difficulty.easy});

  @override
  void dispose() {
    _questionsCount.dispose();
    _selectedTags.dispose();
    _selectedDifficulty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allQuestions = context.watch<QuizModel>().allQuestions!;
    final totalCount = allQuestions.values.expand((e) => e).length;

    return ListView(
      children: [
        ListTile(
          title: Text(
            'Total: $totalCount questions',
          ),
          subtitle: ValueListenableBuilder(
            valueListenable: _questionsCount,
            builder: (_, questionsCount, __) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select number of questions: $questionsCount'),
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
          builder: (context, selectedTags, __) => ExpansionTile(
            title: Text(
              'Select Tags (${selectedTags.length}/${allQuestions.length})',
            ),
            children: allQuestions.keys
                .map((key) => CheckboxListTile(
                      value: selectedTags.contains(key),
                      title: Text(key),
                      onChanged: (e) {
                        if (e == null) return;
                        final resultTemp = selectedTags.toSet();
                        if (e) {
                          resultTemp.add(key);
                        } else {
                          if (resultTemp.length == 1) {
                            ScaffoldMessenger.of(context)
                                .showMessage('Choose at least one');
                            return;
                          }
                          resultTemp.remove(key);
                        }
                        _selectedTags.value = resultTemp;
                      },
                    ))
                .toList(),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _selectedDifficulty,
          builder: (context, selectedDifficulty, __) => ExpansionTile(
            title: Text(
              'Select Difficulty (${Difficulty.values.map((e) => '${e.name}: ${selectedDifficulty.contains(e).pictoChar}').join(', ')})',
            ),
            children: Difficulty.values
                .map((difficultyValue) => CheckboxListTile(
                      value: selectedDifficulty.contains(difficultyValue),
                      title: Text(difficultyValue.name),
                      onChanged: (e) {
                        if (e == null) return;
                        final resultTemp = selectedDifficulty.toSet();
                        if (e) {
                          resultTemp.add(difficultyValue);
                        } else {
                          if (resultTemp.length == 1) {
                            ScaffoldMessenger.of(context)
                                .showMessage('Choose at least one');
                            return;
                          }
                          resultTemp.remove(difficultyValue);
                        }
                        _selectedDifficulty.value = resultTemp;
                      },
                    ))
                .toList(),
          ),
        ),
        ListTile(
          title: ElevatedButton(
            onPressed: () {
              context.read<QuizModel>().setup(
                    count: _questionsCount.value,
                    selectedTags: _selectedTags.value
                        .map(_indexItem2Tag)
                        .whereType<String>()
                        .toSet(),
                    selectedDifficulty: _selectedDifficulty.value,
                  );
              Navigator.of(context).push(
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

extension on ScaffoldMessengerState {
  void showMessage(String content) {
    showSnackBar(SnackBar(content: Text(content)));
  }
}

extension on bool {
  String get pictoChar => this ? '√' : '×';
}

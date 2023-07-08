import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/model/quiz_model.dart';

import '../result/result_page.dart';

const _kAnimationDuration = Duration(milliseconds: 800);
const _kAnimationCurve = Curves.easeOutCirc;

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  final _pageController = PageController();

  bool _isAnimating = false;

  @override
  Widget build(BuildContext context) {
    final quizItems = context.read<QuizModel>().quizItems;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Quiz Page'),
      ),
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: _currentPage,
            builder: (context, value, child) => _Overview(
              currentIndex: value,
              itemOnTap: (index) {
                _isAnimating = true;
                _pageController
                    .animateToPage(
                  index,
                  duration: _kAnimationDuration,
                  curve: _kAnimationCurve,
                )
                    .then((value) {
                  _isAnimating = false;
                  _currentPage.value = index;
                });
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: PageView.builder(
              itemCount: quizItems.length,
              onPageChanged: (value) {
                if (_isAnimating) return;
                _currentPage.value = value;
              },
              controller: _pageController,
              itemBuilder: (_, index) => _PageItem(
                index,
                onComplete: () => _pageController.nextPage(
                  duration: _kAnimationDuration,
                  curve: _kAnimationCurve,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Submit',
        child: const Icon(Icons.done),
        onPressed: () async {
          final navigator = Navigator.of(context);
          var completed = quizItems.every((item) => item.answered);
          if (!completed) {
            completed = (await showDialog<bool?>(
                  context: context,
                  builder: (context) => AlertDialog(
                    content:
                        const Text('You are missing some answers, continue?'),
                    actions: [
                      TextButton(
                        onPressed: Navigator.of(context).pop,
                        child: const Text('no'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('yes'),
                      ),
                    ],
                  ),
                )) ==
                true;
          }
          if (!completed) return;
          navigator.push<void>(
            MaterialPageRoute(builder: (_) => const ResultPage()),
          );
        },
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({
    Key? key,
    required this.currentIndex,
    this.itemOnTap,
  }) : super(key: key);

  final int currentIndex;
  final void Function(int index)? itemOnTap;

  @override
  Widget build(BuildContext context) {
    final quizItems = context.read<QuizModel>().quizItems;
    final indexTemp = _getItems(quizItems.length);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indexTemp.map(
        (e) {
          final isCurrent = e == currentIndex;
          return RawMaterialButton(
            constraints: BoxConstraints(minWidth: 36, minHeight: 36),
            onPressed: isCurrent ? null : () => itemOnTap?.call(e),
            shape: CircleBorder(
              side: quizItems[e].answered
                  ? BorderSide(color: colorScheme.tertiary)
                  : isCurrent
                      ? BorderSide.none
                      : BorderSide(color: colorScheme.primary),
            ),
            elevation: isCurrent ? 0 : 4,
            fillColor:
                isCurrent ? colorScheme.primary : colorScheme.inversePrimary,
            child: Text(
              '${e + 1}',
              style: TextStyle(
                color:
                    isCurrent ? Colors.white : Theme.of(context).primaryColor,
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  List<int> _getItems(int quizCount) {
    final resultLength = min(quizCount, 5);
    final centerOffset = resultLength ~/ 2;
    final startItem = min(
      max(currentIndex - centerOffset, 0),
      quizCount - resultLength,
    );
    return List.generate(resultLength, (index) => startItem + index);
  }
}

class _PageItem extends StatefulWidget {
  final int index;
  final VoidCallback? onComplete;

  const _PageItem(this.index, {Key? key, this.onComplete}) : super(key: key);

  @override
  State<_PageItem> createState() => _PageItemState();
}

class _PageItemState extends State<_PageItem> {
  @override
  Widget build(BuildContext context) {
    final item = context.read<QuizModel>().quizItems[widget.index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(item.question.title),
        const Divider(),
        for (final choice in item.choices)
          ListTile(
            title: Text(choice.content),
            selected: choice.selected,
            selectedColor: Colors.black,
            selectedTileColor: Theme.of(context).colorScheme.tertiaryContainer,
            onTap: () {
              setState(() => item.radioChoose(choice));
              widget.onComplete?.call();
            },
          ),
      ],
    );
  }
}

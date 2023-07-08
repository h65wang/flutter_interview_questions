import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/components/toast.dart';
import 'package:flutter_interview_questions/components/indicator.dart';
import 'package:flutter_interview_questions/model/quiz_model.dart';

import '../../model/quiz_item.dart';
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
  late final ValueNotifier<int> _currentFlage = ValueNotifier(0);

  final _pageController = PageController();
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
            builder: (BuildContext context1, int value, Widget? child) {
              return IndicatorWidget(
                  itemCount: quizItems.length,
                  current: value,
                  onTap: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: _kAnimationDuration,
                      curve: _kAnimationCurve,
                    );
                  },
                  onTapThumbnail: () {
                    showDialog<String>(
                      context: context1,
                      builder: (BuildContext context) =>
                          _showOverviewDialog(value, context),
                    );
                  },
                  onTapSubmit: () async {
                    final navigator = Navigator.of(context);
                    var isGoToResultPage = await _showSubmitDialog(context);
                    if (isGoToResultPage == true) {
                      navigator.push<void>(
                        MaterialPageRoute(builder: (_) => const ResultPage()),
                      );
                    }
                  });
            },
          ),
          const Divider(),
          Expanded(
            child: PageView.builder(
              itemCount: quizItems.length,
              onPageChanged: (value) {
                _currentPage.value = value;
                _currentFlage.value = value;
                if (value > 0) {
                  quizItems[value - 1].previousFlag = true;
                } else {
                  quizItems[value].previousFlag = true;
                }
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
          ValueListenableBuilder(
            valueListenable: _currentFlage,
            builder: (BuildContext context, int value, Widget? child) {
              if (value != quizItems.length - 1) {
                return Container();
              }
              return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                      onPressed: () => _submitEvent(quizItems),
                      child: const Text('Submit')));
            },
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
      //TODO:提交按钮是否要在所有页面都要展现？
      // floatingActionButton: FloatingActionButton(
      //   tooltip: 'Submit',
      //   child: const Icon(Icons.done),
      //   onPressed: () async {
      //     final navigator = Navigator.of(context);
      //     var completed = quizItems.every((item) => item.answered);
      //     if (!completed) {
      //       completed = (await showDialog<bool?>(
      //             context: context,
      //             builder: (context) => AlertDialog(
      //               content:
      //                   const Text('You are missing some answers, continue?'),
      //               actions: [
      //                 TextButton(
      //                   onPressed: Navigator.of(context).pop,
      //                   child: const Text('no'),
      //                 ),
      //                 TextButton(
      //                   onPressed: () => Navigator.of(context).pop(true),
      //                   child: const Text('yes'),
      //                 ),
      //               ],
      //             ),
      //           )) ==
      //           true;
      //     }
      //     if (!completed) return;
      //     navigator.push<void>(
      //       MaterialPageRoute(builder: (_) => const ResultPage()),
      //     );
      //   },
      // ),
    );
  }

  void _submitEvent(List<QuizItem> quizItems) async {
    final completed = quizItems.every((item) => item.answered);
    if (!completed) {
      // TODO: alert dialog if they haven't answered all questions yet
      print('you are missing some answers');
      Toast.show('you are missing some answers');
      return;
    }
    quizItems.lastOrNull?.previousFlag = true;
    Navigator.of(context).push<ResultPage>(
      MaterialPageRoute(builder: (_) => const ResultPage()),
    );
  }

  Future<bool?> _showSubmitDialog(BuildContext context) {
    var completed = context.read<QuizModel>().completed;
    if (completed) {
      return showDialog<bool?>(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('Do you confirm to submit?'),
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
      );
    }
    return showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('You are missing some answers, continue?'),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('yes'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('submit anyway'),
          ),
        ],
      ),
    );
  }

  Widget _showOverviewDialog(int value, BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Quiz Overview'),
            _Overview(
              currentIndex: value,
              itemOnTap: (index) => _pageController.animateToPage(
                index,
                duration: _kAnimationDuration,
                curve: _kAnimationCurve,
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        ),
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

    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 8.0,
      runSpacing: 4.0,
      children: quizItems.mapIndexed(
        (i, e) {
          final isCurrent = e == currentIndex;
          return RawMaterialButton(
            onPressed: isCurrent ? null : () => itemOnTap?.call(i),
            shape: CircleBorder(
              side: e.answered
                  ? const BorderSide(color: Colors.green)
                  : isCurrent
                      ? BorderSide.none
                      : BorderSide(color: Theme.of(context).primaryColor),
            ),
            elevation: isCurrent ? 0 : 4,
            fillColor:
                isCurrent ? Theme.of(context).primaryColor : Colors.white,
            child: Text(
              '${i + 1}',
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            item.question.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(),
        for (final choice in item.choices)
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ListTile(
              title: Text(choice.content),
              selected: choice.selected,
              selectedColor: Colors.black,
              selectedTileColor: Colors.green.shade200,
              onTap: () {
                 //TODO: 多选时候有bug
                if (item.previousFlag && item.answered) {
                  return;
                }
                setState(() => item.radioChoose(choice));
                // widget.onComplete?.call();
              },
            ),
          ),
      ],
    );
  }
}

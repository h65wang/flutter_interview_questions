import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/model/language_item.dart';
import 'package:flutter_interview_questions/model/question_bank.dart';
import 'package:flutter_interview_questions/model/quiz_model.dart';
import 'package:flutter_interview_questions/pages/quiz_page.dart';
import 'package:flutter_interview_questions/style/color.dart';
import 'package:flutter_interview_questions/style/size.dart';
import 'package:flutter_interview_questions/style/text.dart';
import 'package:flutter_interview_questions/widget/app_layout.dart';
import 'package:flutter_interview_questions/widget/tapped.dart';

class SelectPage extends StatefulWidget {
  final Bank bank;

  const SelectPage({super.key, required this.bank});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  // Current language being selected.
  late LanguageItem _language = widget.bank.keys.first;

  // [QuestionSet] being selected. By default we select everything.
  late Set<QuestionSet> _sets = widget.bank.values.expand((s) => s).toSet();

  // A list of questions that matches user's preference on language and sets.
  List<Question> get selectedQuestions => widget.bank[_language]!
      .where((s) => _sets.contains(s))
      .expand((s) => s.questions)
      .toList();

  List<QuestionSet> get currentQuestionSets =>
      widget.bank[_language] ?? <QuestionSet>[];

  void _start() {
    final model = QuizModel(selectedQuestions..shuffle());
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => QuizPage(
          model: model,
          language: _language,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 又不是不能用
    List<Widget> cards = [];
    for (int i = 0; i < (currentQuestionSets.length / 2).ceil(); i++) {
      var card = _Card(
        questionSet: currentQuestionSets[i * 2],
        language: _language,
        selected: _sets.contains(currentQuestionSets[i * 2]),
        onTap: () {
          setState(() {
            final current = currentQuestionSets[i * 2];
            if (_sets.contains(current))
              _sets.remove(current);
            else
              _sets.add(current);
          });
        },
      );
      var card2 = _Card(
        questionSet: currentQuestionSets[i * 2 + 1],
        language: _language,
        selected: _sets.contains(currentQuestionSets[i * 2 + 1]),
        onTap: () {
          setState(() {
            final current = currentQuestionSets[i * 2 + 1];
            if (_sets.contains(current))
              _sets.remove(current);
            else
              _sets.add(current);
          });
        },
      );
      if (MediaQuery.of(context).size.width >= 700) {
        cards.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: card,
              ),
              Expanded(
                child: currentQuestionSets.asMap()[i * 2 + 1] == null
                    ? Container()
                    : card2,
              )
            ],
          ),
        );
      } else {
        cards.add(Column(
          children: [
            card,
            currentQuestionSets.asMap()[i * 2 + 1] == null
                ? Container()
                : card2,
          ],
        ));
      }
    }

    Widget pageBody = Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: ListView(
        children: cards,
      ),
    );
    return AppLayout(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 22),
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 22,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ColorPlate.lightGray,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: StText.big(
                      'Flutter Interview Questions',
                      style: TextStyle(
                        height: oneLineH,
                        fontSize: SysSize.huge,
                      ),
                    ),
                  ),
                  Tapped(
                    child: Icon(
                      Icons.share,
                      color: ColorPlate.primaryPink,
                      size: SysSize.huge,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 32,
              ).copyWith(bottom: 4),
              child: Row(
                children: [
                  Spacer(),
                  _LanguagePicker(
                    language: _language,
                    languageList: widget.bank.keys,
                    onSelect: (target) {
                      setState(() {
                        _language = target;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(child: pageBody),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 22),
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: ColorPlate.lightGray,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Tapped(
                    onTap: () {
                      setState(() {
                        _sets = widget.bank.values.expand((s) => s).toSet();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: StText.big(
                        'Reset',
                        style: TextStyle(
                          height: oneLineH,
                          color: ColorPlate.primaryPink,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  AbsorbPointer(
                    absorbing: selectedQuestions.isEmpty,
                    child: Tapped(
                      onTap: _start,
                      child: Container(
                        width: 178,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selectedQuestions.isEmpty
                              ? ColorPlate.gray
                              : ColorPlate.primaryPink,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: StText.medium(
                                'Start',
                                style: TextStyle(
                                  height: oneLineH,
                                  color: ColorPlate.white,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: ColorPlate.white,
                              size: SysSize.normal,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  final LanguageItem language;
  final Iterable<LanguageItem> languageList;
  final Function(LanguageItem) onSelect;

  const _LanguagePicker({
    required this.language,
    required this.onSelect,
    required this.languageList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ColorPlate.lightGray,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          for (final item in languageList)
            Expanded(
              child: Tapped(
                onTap: () {
                  onSelect(item);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: language == item
                        ? ColorPlate.primaryPink
                        : ColorPlate.lightGray,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: StText.normal(
                    item.lang,
                    align: TextAlign.center,
                    style: TextStyle(
                      height: oneLineH,
                      color: language == item
                          ? ColorPlate.white
                          : ColorPlate.primaryPink,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final QuestionSet questionSet;
  final LanguageItem language;
  final bool selected;
  final VoidCallback onTap;

  const _Card({
    required this.questionSet,
    required this.language,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tapped(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: ColorPlate.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? ColorPlate.primaryPink.withOpacity(.5)
                : ColorPlate.lightGray,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(12, 18, 0, 0),
              child: Icon(
                Icons.description,
                size: 32,
                color: selected ? ColorPlate.primaryPink : ColorPlate.gray,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(12, 10, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StText.medium(
                            questionSet.name,
                            style: TextStyle(height: oneLineH),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            selected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: selected
                                ? ColorPlate.primaryPink
                                : ColorPlate.gray,
                            size: SysSize.normal,
                          ),
                        )
                      ],
                    ),
                    StText.small(
                      '${language.translations['total-question-count']}'
                          .replaceFirst('%', '${questionSet.questions.length}'),
                      style: TextStyle(height: oneLineH),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2),
                      child: StText.small(
                        questionSet.description,
                      ),
                    ),
                    StText.small(
                      '${language.translations['author']}'
                      '${questionSet.author ?? language.translations['anonymous']}',
                      style: TextStyle(height: oneLineH),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

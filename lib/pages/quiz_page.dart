import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/model/quiz_item.dart';
import 'package:flutter_interview_questions/model/quiz_model.dart';
import 'package:flutter_interview_questions/style/color.dart';
import 'package:flutter_interview_questions/style/size.dart';
import 'package:flutter_interview_questions/style/text.dart';
import 'package:flutter_interview_questions/widget/app_layout.dart';
import 'package:flutter_interview_questions/widget/markdown.dart';
import 'package:flutter_interview_questions/widget/tapped.dart';

class QuizPage extends StatefulWidget {
  final QuizModel model;
  const QuizPage({super.key, required this.model});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // After the user submits, we lock all answers so they cannot change them.
  // And we reveal the result (correct/incorrect).
  bool _submitted = false;

  List<QuizItem> get _list => widget.model.questions;

  Map<QuizItem, Set<String>> answerMap = {};

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      itemCount: _list.length,
      itemBuilder: (context, index) {
        final data = _list[index];
        return _Quiz(
          data: data,
          submitted: _submitted,
          selected: answerMap[data] ?? Set(),
          onSelect: (candidate) {
            setState(() {});
            if (answerMap[data] == null) answerMap[data] = Set();
            final set = answerMap[data]!;
            if (!data.hasMultipleAnswers) set.clear();
            if (set.contains(candidate))
              set.remove(candidate);
            else
              set.add(candidate);
          },
        );
      },
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
                  Tapped(
                    onTap: () {
                      Navigator.of(context).maybePop();
                    },
                    child: Icon(
                      Icons.cancel,
                      color: ColorPlate.primaryPink,
                      size: SysSize.huge,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 12),
                      child: StText.big(
                        'Quiz Page',
                        style: TextStyle(
                          height: oneLineH,
                          fontSize: SysSize.huge,
                        ),
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
            Expanded(child: content),
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
                  if (_submitted)
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: _Count(
                            text: '-',
                            icons: Icons.check_circle,
                            color: ColorPlate.green,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: _Count(
                            text: '-',
                            icons: Icons.cancel,
                            color: ColorPlate.primaryPink,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: _Count(
                            text: '-',
                            icons: Icons.help,
                            color: ColorPlate.orange,
                          ),
                        ),
                      ],
                    ),
                  Spacer(),
                  Tapped(
                    onTap: () {
                      setState(() {
                        _submitted = !_submitted;
                      });
                    },
                    child: Container(
                      width: 178,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: ColorPlate.primaryPink,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: StText.medium(
                              _submitted ? 'Retry' : 'Submit',
                              style: TextStyle(
                                height: oneLineH,
                                color: ColorPlate.white,
                              ),
                            ),
                          ),
                          Icon(
                            _submitted ? Icons.refresh : Icons.check,
                            color: ColorPlate.white,
                            size: SysSize.normal,
                          )
                        ],
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

class _Count extends StatelessWidget {
  final String text;
  final IconData icons;
  final Color color;
  const _Count({
    super.key,
    required this.text,
    required this.color,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 4),
          child: StText.big(
            text,
            style: TextStyle(
              height: oneLineH,
              color: color,
            ),
          ),
        ),
        Icon(
          icons,
          size: SysSize.big,
          color: color,
        ),
      ],
    );
  }
}

class _Quiz extends StatelessWidget {
  const _Quiz({
    super.key,
    required this.data,
    required this.onSelect,
    required this.selected,
    required this.submitted,
  });

  final QuizItem data;
  final bool submitted;
  final Set<String> selected;
  final Function(String) onSelect;

  bool get hasError {
    if (data.question.answers.length != selected.length) return true;
    for (var correct in data.question.answers) {
      if (!selected.contains(correct)) return true;
    }
    return false;
  }

  String get tag {
    if (selected.isEmpty) return '未提供答案';
    return hasError == true ? '错误' : '正确';
  }

  Color get highlight {
    if (selected.isEmpty) return ColorPlate.orange;
    return hasError == true ? ColorPlate.primaryPink : ColorPlate.green;
  }

  CandidateStatus statusFromCandidate(String candidate) {
    if (!submitted) return CandidateStatus.notSubmit;
    if (data.question.answers.contains(candidate)) {
      if (selected.contains(candidate)) {
        return CandidateStatus.correct;
      }
      return CandidateStatus.notSelectButCorrect;
    } else {
      return CandidateStatus.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    var candidateList = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final candidate in data.choices.map((e) => e.content))
          Candidate(
            candidate: candidate,
            selected: selected.contains(candidate),
            status: statusFromCandidate(candidate),
            canMutiSelect: data.question.answers.length > 1,
            onTap: () {
              onSelect(candidate);
            },
          ),
      ],
    );
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 12,
      ),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: ColorPlate.lightGray,
          width: 1,
        ),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Markdown(
              data.question.title,
              style: StandardTextStyle.medium,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: candidateList,
              ),
              if (submitted)
                Container(
                  margin: EdgeInsets.only(left: 12),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: highlight.withOpacity(.3),
                    ),
                  ),
                  child: StText.small(
                    tag,
                    style: TextStyle(
                      color: highlight,
                    ),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}

enum CandidateStatus {
  notSubmit,
  correct,
  notSelectButCorrect,
  error,
}

class Candidate extends StatelessWidget {
  const Candidate({
    super.key,
    required this.candidate,
    required this.onTap,
    required this.selected,
    required this.canMutiSelect,
    required this.status,
  });

  final String candidate;
  final VoidCallback onTap;
  final bool selected;
  final bool canMutiSelect;

  final CandidateStatus status;

  Color get highlight {
    if (status == CandidateStatus.notSelectButCorrect) return ColorPlate.orange;
    if (status == CandidateStatus.correct) return ColorPlate.green;
    if (status == CandidateStatus.error) return ColorPlate.primaryPink;
    return ColorPlate.primaryPink;
  }

  bool get showSelectStatus {
    if (status == CandidateStatus.notSelectButCorrect) return true;
    return selected;
  }

  @override
  Widget build(BuildContext context) {
    Widget? tag;
    if (status == CandidateStatus.error && selected) {
      tag = Container(
        padding: EdgeInsets.only(left: 12),
        child: Icon(
          Icons.cancel,
          color: ColorPlate.primaryPink,
        ),
      );
    }
    if (status == CandidateStatus.correct && selected) {
      tag = Container(
        padding: EdgeInsets.only(left: 12),
        child: Icon(
          Icons.check_circle,
          color: ColorPlate.green,
        ),
      );
    }
    if (status == CandidateStatus.notSelectButCorrect) {
      tag = Container(
        padding: EdgeInsets.only(left: 12),
        child: Icon(
          Icons.check_circle_outline_sharp,
          color: ColorPlate.orange,
        ),
      );
    }
    return AbsorbPointer(
      absorbing: status != CandidateStatus.notSubmit,
      child: Tapped(
        onTap: onTap,
        child: Row(
          children: [
            Flexible(
              child: Opacity(
                opacity: (status == CandidateStatus.error) ? 0.3 : 1,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: showSelectStatus
                            ? highlight.withOpacity(.3)
                            : ColorPlate.lightGray),
                  ),
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                        child: Icon(
                          showSelectStatus
                              ? (canMutiSelect
                                  ? Icons.check_box
                                  : Icons.radio_button_checked)
                              : (canMutiSelect
                                  ? Icons.check_box_outline_blank
                                  : Icons.radio_button_off),
                          color: showSelectStatus
                              ? highlight
                              : ColorPlate.halfGray,
                        ),
                      ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Markdown(
                            candidate,
                            style: StandardTextStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(child: tag),
          ],
        ),
      ),
    );
  }
}

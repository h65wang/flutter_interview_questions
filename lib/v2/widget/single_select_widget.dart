import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/v2/model/quiz_item.dart';
import 'package:flutter_interview_questions/v2/widget/markdown.dart';

class SingleSelectWidget extends StatelessWidget {
  final List<Choice> items;
  final void Function(Choice e) onTap;

  const SingleSelectWidget(
      {super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .mapIndexed((i, e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: RadioListTile(
                  title: Markdown(e.content),
                  value: e,
                  groupValue:
                      items.firstWhereOrNull((element) => element.selected),
                  onChanged: (value) {
                    onTap(value!);
                  },
                ),
              ))
          .toList(),
    );
  }
}

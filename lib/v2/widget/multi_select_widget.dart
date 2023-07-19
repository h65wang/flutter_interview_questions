import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/v2/model/quiz_item.dart';
import 'package:flutter_interview_questions/v2/widget/markdown.dart';

class MultiSelectWidget extends StatelessWidget {
  final List<Choice> items;
  final void Function() onTap;

  const MultiSelectWidget(
      {super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map((e) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: e.selected,
                onChanged: (checked) {
                  onTap.call();
                  e.selected = !e.selected;
                },
                title: Markdown(e.content),
              ))
          .toList(),
    );
  }
}

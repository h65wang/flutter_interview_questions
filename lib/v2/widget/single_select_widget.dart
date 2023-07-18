import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/v2/model/quiz_item.dart';

class SingleSelectWidget extends StatelessWidget {
  final List<Choice> items;

  final int index;

  final void Function(int idx) onTap;

  const SingleSelectWidget(
      {super.key,
      required this.items,
      required this.index,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .mapIndexed((i, e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: RadioListTile(
                  title: Text(e.content),
                  value: i,
                  groupValue: index,
                  onChanged: (value) {
                    onTap(value!);
                  },
                ),
              ))
          .toList(),
    );
  }
}

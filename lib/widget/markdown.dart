import 'dart:ui';

import 'package:flutter/material.dart';

class Markdown extends StatefulWidget {
  const Markdown(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  State<Markdown> createState() => _MarkdownState();
}

class _MarkdownState extends State<Markdown> {
  late TextSpan _spanTemp;

  @override
  void initState() {
    super.initState();
    _updateSpan();
  }

  @override
  void didUpdateWidget(Markdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == widget.text) return;
    _updateSpan();
  }

  void _updateSpan() {
    final List<TextSpan> resultTemp = [];
    widget.text.splitMapJoin(
      RegExp(r'`(.*?)`'),
      onMatch: (e) {
        resultTemp.add(
          TextSpan(
            text: ' ${e.group(1)} ',
            style: TextStyle(
              backgroundColor: const Color.fromARGB(255, 238, 238, 238),
              fontWeight: FontWeight.w700,
              fontFamily: 'Courier',
            ),
          ),
        );
        return '';
      },
      onNonMatch: (e) {
        resultTemp.add(TextSpan(text: e));
        return '';
      },
    );
    _spanTemp = TextSpan(children: resultTemp);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: SelectableText.rich(
        _spanTemp,
        selectionHeightStyle: BoxHeightStyle.max,
      ),
    );
  }
}

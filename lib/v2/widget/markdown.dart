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
  late TextSpan _spanTemp = TextSpan(text: widget.text);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _updateSpan();
      });
    });
  }

  @override
  void didUpdateWidget(Markdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == widget.text && oldWidget.style == widget.style)
      return;
    _updateSpan();
  }

  void _updateSpan() {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = widget.style;
    if (effectiveTextStyle == null || effectiveTextStyle.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }
    if (MediaQuery.boldTextOf(context)) {
      effectiveTextStyle = effectiveTextStyle
          .merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    final List<TextSpan> resultTemp = [];
    widget.text.splitMapJoin(
      RegExp(r'`(.*?)`'),
      onMatch: (e) {
        resultTemp.add(
          TextSpan(
            text: '  ${e.group(1)}  ',
            style: effectiveTextStyle!.copyWith(
              fontSize: (effectiveTextStyle.fontSize ?? 14) - 1,
              fontWeight: FontWeight.w500,
              color: effectiveTextStyle.color?.withOpacity(0.9),
              backgroundColor: const Color.fromARGB(255, 238, 238, 238),
            ),
          ),
        );
        return '';
      },
      onNonMatch: (e) {
        resultTemp.add(TextSpan(text: e, style: effectiveTextStyle));
        return '';
      },
    );
    _spanTemp = TextSpan(children: resultTemp);
  }

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      _spanTemp,
      selectionHeightStyle: BoxHeightStyle.max,
    );
  }
}

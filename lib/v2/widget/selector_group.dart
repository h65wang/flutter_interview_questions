import 'package:flutter/material.dart';

import 'selector.dart';

class SelectorGroup<T> extends StatelessWidget {
  /// Which items to display.
  final Iterable<T> items;

  /// Which items should be displayed as being selected.
  final Iterable<T> selected;

  /// What happens when user clicks on one of the items.
  final void Function(T) onTap;

  /// How to convert item `Type T` into a string to display.
  final String Function(T)? display;

  const SelectorGroup({
    super.key,
    required this.items,
    required this.selected,
    required this.onTap,
    this.display,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final it in items)
          Selector(
            content: display?.call(it) ?? '$it',
            selected: selected.contains(it),
            onTap: () => onTap(it),
          ),
      ],
    );
  }
}

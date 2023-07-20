import 'package:flutter/material.dart';

class Selector extends StatelessWidget {
  final String content;
  final bool selected;
  final VoidCallback onTap;

  const Selector({
    super.key,
    required this.content,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(content),
      selected: selected,
      selectedColor: Colors.black,
      selectedTileColor: Theme.of(context).colorScheme.inversePrimary,
      onTap: onTap,
      splashColor: Colors.transparent,
    );
  }
}

import 'package:flutter/material.dart';

class Selector extends StatelessWidget {
  final Widget child;
  final bool selected;
  final VoidCallback onTap;

  const Selector({
    super.key,
    required this.child,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: child,
      selected: selected,
      selectedColor: Colors.black,
      selectedTileColor: Theme.of(context).colorScheme.inversePrimary,
      onTap: onTap,
      splashColor: Colors.transparent,
    );
  }
}

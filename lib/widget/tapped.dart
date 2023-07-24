import 'package:flutter/material.dart';

/// Provide an opacity animation when tap child.
class Tapped extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget? child;
  const Tapped({
    super.key,
    this.onTap,
    this.child,
  });

  @override
  State<Tapped> createState() => _TappedState();
}

class _TappedState extends State<Tapped> {
  bool isTapDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isTapDown = true;
        });
      },
      onTapUp: (_) {
        widget.onTap?.call();
        setState(() {
          isTapDown = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isTapDown = false;
        });
      },
      child: AnimatedOpacity(
        curve: Curves.fastOutSlowIn,
        duration: isTapDown ? Duration.zero : Duration(milliseconds: 330),
        opacity: isTapDown ? 0.3 : 1,
        child: widget.child,
      ),
    );
  }
}

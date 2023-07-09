import 'package:flutter/material.dart';

class IndicatorWidget extends StatelessWidget {
  final int itemCount;
  final int current;

  final void Function(int index) onTap;
  final void Function() onTapThumbnail;
  final void Function() onTapSubmit;

  const IndicatorWidget({
    super.key,
    required this.itemCount,
    required this.onTap,
    required this.current,
    required this.onTapThumbnail,
    required this.onTapSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: NavigationToolbar(
        leading: _buildPrevious(),
        middle: _buildTextButton(context),
        trailing: _buildNext(),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        onTapThumbnail();
      },
      child: Text(
        '${current + 1}/ $itemCount',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _buildNext() {
    if (current == itemCount - 1) {
      return TextButton(
        onPressed: onTapSubmit,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('submit'),
            const Icon(Icons.done),
          ],
        ),
      );
    }
    return TextButton(
      onPressed: () => onTap(current + 1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Next'),
          Icon(Icons.arrow_forward),
        ],
      ),
    );
  }

  Widget _buildPrevious() {
    return Opacity(
      opacity: current == 0 ? 0 : 1,
      child: TextButton(
        onPressed: () => onTap(current - 1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back),
            Text('Previous'),
          ],
        ),
      ),
    );
  }
}

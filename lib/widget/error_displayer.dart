import 'package:flutter/material.dart';

class ErrorDisplayer extends StatefulWidget {
  const ErrorDisplayer({
    this.textAlign,
    this.errorText,
    this.errorStyle,
    this.errorMaxLines,
  });

  final TextAlign? textAlign;
  final String? errorText;
  final TextStyle? errorStyle;
  final int? errorMaxLines;

  @override
  _ErrorDisplayerState createState() => _ErrorDisplayerState();
}

class _ErrorDisplayerState extends State<ErrorDisplayer>
    with SingleTickerProviderStateMixin {
  static const Widget empty = SizedBox.shrink();

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 167),
      vsync: this,
    );
    if (widget.errorText != null) {
      _controller.value = 1.0;
    }
    _controller.addListener(_handleChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChange() => setState(() {});

  @override
  void didUpdateWidget(ErrorDisplayer old) {
    super.didUpdateWidget(old);

    final String? newErrorText = widget.errorText;
    final String? oldErrorText = old.errorText;

    final bool errorTextStateChanged =
        (newErrorText != null) != (oldErrorText != null);

    if (errorTextStateChanged) {
      if (newErrorText != null) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  Widget _buildError() {
    assert(widget.errorText != null);
    final theme = Theme.of(context);
    return Semantics(
      container: true,
      child: FadeTransition(
        opacity: _controller,
        child: FractionalTranslation(
          translation: Tween<Offset>(
            begin: const Offset(0.0, -0.25),
            end: Offset.zero,
          ).evaluate(_controller.view),
          child: Text(
            widget.errorText!,
            style: (theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.error) ??
                    TextStyle())
                .merge(widget.errorStyle),
            textAlign: widget.textAlign,
            overflow: TextOverflow.ellipsis,
            maxLines: widget.errorMaxLines,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isDismissed) {
      return empty;
    }

    if (_controller.isCompleted) {
      if (widget.errorText != null) {
        return _buildError();
      } else {
        return empty;
      }
    }

    if (widget.errorText != null) {
      return _buildError();
    }

    return empty;
  }
}

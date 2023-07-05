import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/config/constants.dart';
import 'package:flutter_interview_questions/model/quiz_model.dart';
import 'package:flutter_interview_questions/state/app_theme.dart';

import '../main.dart';

class Toast {
  static OverlayEntry? _entry;
  static Timer? _timer;

  static Future<void> show(String message) async {
    _timer?.cancel();
    _timer = null;
    _entry?.remove();
    _entry = null;

    final toast = _ToastWidget(message: message);
    _entry = OverlayEntry(builder: (context) => toast);

    OverlayState overlay = Navigator.of(
      navigatorKey.currentContext!,
      rootNavigator: true,
    ).overlay!;

    overlay.insert(_entry!);

    _timer = Timer(const Duration(milliseconds: 2800), () {
      _entry?.remove();
      _entry = null;
    });
  }
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({required this.message});

  final String message;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: k300MS,
    vsync: this,
  );

  late final Animation<double> _animationAlignmentY = Tween<double>(
    begin: -1,
    end: -.8,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCirc,
  ));

  late final Animation<double> _opacityAnimation = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCirc,
  ));

  StreamSubscription? _hideSubscription;

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        hide();
      }
    });
    _controller.forward();
  }

  void hide() {
    _hideSubscription = Stream.fromFuture(
      Future.delayed(const Duration(seconds: 2)),
    ).listen((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = context.watch<AppTheme>();
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Align(
          alignment: Alignment(0, _animationAlignmentY.value),
          child: FadeTransition(opacity: _opacityAnimation, child: child!),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: appTheme.themeData.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(kDefaultRadius),
          boxShadow: [
            BoxShadow(
              color: appTheme.themeData.colorScheme.shadow.withOpacity(.2),
              offset: const Offset(0, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: Text(
          widget.message,
          style: appTheme.themeData.textTheme.bodySmall?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: appTheme.themeData.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideSubscription?.cancel();
    super.dispose();
  }
}

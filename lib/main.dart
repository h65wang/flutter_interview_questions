import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/state/app_theme.dart';

import 'model/quiz_model.dart';
import 'pages/setup/setup_page.dart';

void main() {
  runApp(
    Provider(
      create: () => AppTheme(),
      child: const MyApp(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

/// First, we take users to [SetupPage], where they customize their questions.
/// Then we take them to [QuizPage] for the main thing.
/// Lastly we take them to [ResultPage] for victory!
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var appTheme = context.watch<AppTheme>();
    return Provider(
      create: () => QuizModel(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: appTheme.lightTheme(),
        darkTheme: appTheme.darkTheme(),
        home: const SetupPage(),
        scrollBehavior: _AppScrollBehavior(),
      ),
    );
  }
}

///方便web调试
class _AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

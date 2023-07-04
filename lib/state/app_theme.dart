import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/style/track_shape.dart';

class AppTheme with ChangeNotifier {
  late ThemeData _themeData;

  ThemeData get themeData => _themeData;

  ThemeData lightTheme() {
    _themeData = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
      dividerColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      sliderTheme: SliderThemeData(
        trackShape: CustomTrackShape(),
      ),
    );
    return _themeData;
  }

  ThemeData darkTheme() {
    _themeData = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
      dividerColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      sliderTheme: SliderThemeData(
        trackShape: CustomTrackShape(),
      ),
    );
    return _themeData;
  }
}

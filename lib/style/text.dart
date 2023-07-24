import 'dart:io';

import 'package:flutter/foundation.dart';

import 'color.dart';
import 'size.dart';
import 'package:flutter/material.dart';

/// let text align center of line.
double get oneLineH {
  if (kIsWeb) return 1.25;
  return Platform.isIOS ? 1.3 : 1.25;
}

class StandardTextStyle {
  static const TextStyle big = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: SysSize.big,
    color: ColorPlate.darkGray,
    inherit: true,
    height: 1.4,
  );
  static const TextStyle medium = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: SysSize.normal,
    color: ColorPlate.darkGray,
    inherit: true,
    height: 1.4,
  );
  static const TextStyle normal = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: SysSize.normal,
    color: ColorPlate.darkGray,
    inherit: true,
    height: 1.4,
  );
  static const TextStyle small = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: SysSize.small,
    color: ColorPlate.gray,
    inherit: true,
    height: 1.4,
  );
}

/// Standard text in project
/// Auto set StandardTextStyle and did not change the usage of `Text` widget.
class StText extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final TextStyle defaultStyle;
  final TextAlign? align;
  final int? maxLines;

  const StText({
    Key? key,
    this.text,
    this.style,
    required this.defaultStyle,
    this.maxLines,
    this.align,
  }) : super(key: key);

  const StText.small(
    String? text, {
    Key? key,
    TextStyle? style,
    TextAlign? align,
    int? maxLines,
  }) : this(
          key: key,
          text: text,
          style: style,
          defaultStyle: StandardTextStyle.small,
          maxLines: maxLines,
          align: align,
        );

  const StText.normal(
    String? text, {
    Key? key,
    TextStyle? style,
    TextAlign? align,
    int? maxLines,
  }) : this(
          key: key,
          text: text,
          style: style,
          defaultStyle: StandardTextStyle.normal,
          maxLines: maxLines,
          align: align,
        );

  const StText.medium(
    String? text, {
    Key? key,
    TextStyle? style,
    TextAlign? align,
    int? maxLines,
  }) : this(
          key: key,
          text: text,
          style: style,
          align: align,
          defaultStyle: StandardTextStyle.medium,
          maxLines: maxLines,
        );

  const StText.big(
    String? text, {
    Key? key,
    TextStyle? style,
    TextAlign? align,
    int? maxLines,
  }) : this(
          key: key,
          text: text,
          style: style,
          defaultStyle: StandardTextStyle.big,
          maxLines: maxLines,
          align: align,
        );

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: defaultStyle,
      child: Text(
        text ?? '',
        maxLines: maxLines ?? 50,
        textAlign: align,
        overflow: TextOverflow.ellipsis,
        style: style,
      ),
    );
  }
}

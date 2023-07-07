import 'dart:developer';

import 'package:flutter_interview_questions/util/stack_trace_utils.dart';

typedef Json = Map<String, dynamic>;

T? as<T>(dynamic value, [T? defaultValue]) {
  if (value is T) {
    return value;
  }
  if (value == null) {
    return defaultValue;
  }

  log(
    'Try to cast $value (${value.runtimeType}) to $T',
    level: 800,
    stackTrace: StackTrace.current.cast(3),
  );

  // num 强转
  if (value is num) {
    if (T == double) {
      return value.toDouble() as T;
    }
    if (T == int) {
      return value.toInt() as T;
    }
    if (T == BigInt) {
      return BigInt.from(value) as T;
    }
    if (T == bool) {
      return (value != 0) as T;
    }
  } else

  // String parse
  if (value is String) {
    if (T == int) {
      return int.tryParse(value) as T? ?? defaultValue;
    } else if (T == double) {
      return double.tryParse(value) as T? ?? defaultValue;
    } else if (T == BigInt) {
      return BigInt.tryParse(value) as T? ?? defaultValue;
    } else if (T == DateTime) {
      // DateTime.parse不支持 /
      if (value.contains('/')) {
        value = value.replaceAll('/', '-');
      }
      return DateTime.tryParse(value) as T? ?? defaultValue;
    } else if (T == bool) {
      return {'1', '-1', 'true', 'yes'}.contains(value.toLowerCase()) as T;
    }
  }

  // String 强转
  if (T == String) {
    return '$value' as T;
  }
  log(
    'Type $T cast error: $value (${value.runtimeType})',
    level: 900,
    stackTrace: StackTrace.current.cast(3),
  );

  return defaultValue;
}

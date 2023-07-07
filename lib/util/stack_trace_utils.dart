StackTrace? castStackTrace(StackTrace? trace, [int lines = 3]) {
  if (trace != null) {
    return StackTrace.fromString(
      trace.toString().split('\n').sublist(0, lines).join('\n'),
    );
  }
  return null;
}

extension StackTraceExt on StackTrace {
  StackTrace cast(int lines) {
    return castStackTrace(this, lines)!;
  }
}

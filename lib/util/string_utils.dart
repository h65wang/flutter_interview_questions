extension StringExtesnion on String? {
  bool get isEmptyOrNull =>
      this == null ||
      (this != null && this!.isEmpty) ||
      (this != null && this! == 'null');

  String validate({String value = ''}) {
    if (isEmptyOrNull) {
      return value;
    } else {
      return this!;
    }
  }

  bool get isEmpty {
    return validate().isEmpty;
  }

  bool get isNotEmpty {
    return validate().isNotEmpty;
  }

  ///Not perfect, English words may be split for newlines，waiting for improvement.
  String breakWord() {
    if (this == null || isEmpty) {
      return validate();
    }
    String breakWord = '';
    for (var element in this!.runes) {
      breakWord += String.fromCharCode(element);
      breakWord += '\u200B';
    }
    return breakWord;
  }
}

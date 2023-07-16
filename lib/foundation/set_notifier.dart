import 'package:flutter/material.dart';

class SetNotifier<T> extends ValueNotifier<Set<T>> {
  SetNotifier(super.value);

  void toggle(T item) {
    if (value.contains(item)) {
      value.remove(item);
    } else {
      value.add(item);
    }
    notifyListeners();
  }

  void add(T item) {
    if (!value.contains(item)) {
      value.add(item);
      notifyListeners();
    }
  }

  void remove(T item) {
    if (value.contains(item)) {
      value.remove(item);
      notifyListeners();
    }
  }

  bool contains(T item) => value.contains(item);
}

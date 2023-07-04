import 'package:flutter/widgets.dart';
import 'package:flutter_interview_questions/main.dart';

class Provider<T extends Listenable> extends StatefulWidget {
  final T Function() create;
  final Widget child;

  const Provider({
    Key? key,
    required this.create,
    required this.child,
  }) : super(key: key);

  static T of<T>(BuildContext context, {bool listen = false}) {
    final _InheritedWidget<T>? inherited;

    if (listen) {
      inherited =
          context.dependOnInheritedWidgetOfExactType<_InheritedWidget<T>>();
    } else {
      inherited = context.getInheritedWidgetOfExactType<_InheritedWidget<T>>();
    }
    if (inherited == null) throw Exception('$T not found.');
    return inherited.value;
  }

  @override
  State<Provider<T>> createState() => _ProviderState<T>();
}

class _ProviderState<T extends Listenable> extends State<Provider<T>> {
  late T _value;

  @override
  void initState() {
    super.initState();
    _value = widget.create();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _value,
      builder: (BuildContext context, Widget? child) {
        return _InheritedWidget<T>(
          value: _value,
          child: widget.child,
        );
      },
    );
  }
}

class _InheritedWidget<T> extends InheritedWidget {
  final T value;

  const _InheritedWidget({
    super.key,
    required super.child,
    required this.value,
  });

  @override
  bool updateShouldNotify(_InheritedWidget oldWidget) => true;
}

extension Consumer on BuildContext {
  T watch<T>() => Provider.of<T>(this, listen: true);

  T read<T>() => Provider.of<T>(this, listen: false);
}
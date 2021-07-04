import 'package:disposing/disposing.dart';
import 'package:flutter/material.dart';

mixin DisposableBagStateMixin<T extends StatefulWidget> on State<T> {
  final disposeBag = DisposableBag();

  @mustCallSuper
  void dispose() {
    _disposeInternal();
    super.dispose();
  }

  void _disposeInternal() async {
    await disposeBag.dispose();
  }
}

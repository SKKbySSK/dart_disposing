import 'dart:async';
import 'dart:collection';

import 'package:disposing/disposing.dart';

class DisposableBag extends ListBase<Disposable> {
  final _disposables = <Disposable>[];

  @override
  int get length => _disposables.length;

  @override
  Disposable operator [](int index) {
    return _disposables[index];
  }

  @override
  void operator []=(int index, Disposable value) {
    _disposables[index] = value;
  }

  @override
  set length(int newLength) {
    _disposables.length = newLength;
  }

  Future<void> dispose({bool concurrent = false}) async {
    if (concurrent) {
      await _concurrentDispose();
      return;
    }

    for (final d in _disposables) {
      await d.dispose();
    }
  }

  Future<void> _concurrentDispose() async {
    final fs = _disposables.map((e) => e.dispose());
    await Future.wait(fs);
  }
}

import 'dart:async';
import 'dart:collection';

import 'package:disposing/disposing.dart';

class DisposableBag extends ListBase<Disposable> implements Disposable {
  final _disposables = <Disposable>[];
  late final CallbackDisposable _cbDisposable;

  DisposableBag() {
    _cbDisposable = CallbackDisposable(_disposeInternal);
  }

  @override
  int get length => _disposables.length;

  @override
  Disposable operator [](int index) {
    return _disposables[index];
  }

  @override
  void operator []=(int index, Disposable value) {
    throwIfDisposed();
    _disposables[index] = value;
  }

  @override
  set length(int newLength) {
    throwIfDisposed();
    _disposables.length = newLength;
  }

  @override
  bool get isDisposing => _cbDisposable.isDisposing;

  @override
  bool get isDisposed => _cbDisposable.isDisposed;

  Future<void> dispose() {
    return _cbDisposable.dispose();
  }

  Future<void> _disposeInternal() async {
    for (final d in _disposables) {
      await d.dispose();
    }
  }
}

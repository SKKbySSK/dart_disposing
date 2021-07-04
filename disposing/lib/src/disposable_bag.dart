import 'dart:async';

import 'package:disposing/disposing.dart';
import 'package:quiver/collection.dart';

class DisposableBag extends DelegatingList<Disposable> implements Disposable {
  final _disposables = <Disposable>[];
  late final CallbackDisposable _cbDisposable;

  DisposableBag() {
    _cbDisposable = CallbackDisposable(_disposeInternal);
  }

  @override
  List<Disposable> get delegate => _disposables;

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

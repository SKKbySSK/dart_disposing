import 'dart:async';

import 'package:disposing/disposing.dart';
import 'package:disposing/src/disposables/async_disposables.dart';
import 'package:disposing/src/extensions.dart';

class _AsyncWrapperDisposable extends AsyncDisposable {
  _AsyncWrapperDisposable(Disposable disposable) {
    AsyncDisposable disp;
    if (disposable is SyncDisposable) {
      disp = disposable.asAsync();
    } else if (disposable is AsyncDisposable) {
      disp = disposable;
    } else {
      throw UnknownDisposableException(disposable);
    }

    this.disposable = disposable;
    this._asyncDisposable = disp;
  }

  late final Disposable disposable;
  late final AsyncDisposable _asyncDisposable;

  @override
  bool get isDisposing => _asyncDisposable.isDisposing;

  @override
  bool get isDisposed => _asyncDisposable.isDisposed;

  @override
  Future<void> dispose() {
    return _asyncDisposable.dispose();
  }
}

class DisposableBag extends Iterable<Disposable> implements AsyncDisposable {
  late final AsyncCallbackDisposable _disposable;
  final _disposables = <_AsyncWrapperDisposable>[];

  DisposableBag() {
    _disposable = AsyncCallbackDisposable(_disposeInternal);
  }

  @override
  bool get isDisposing => _disposable.isDisposing;

  @override
  bool get isDisposed => _disposable.isDisposed;

  @override
  Iterator<Disposable> get iterator =>
      _disposables.map((e) => e.disposable).iterator;

  @override
  void throwIfNotAvailable([String? target]) {
    _disposable.throwIfNotAvailable(target);
  }

  void add(Disposable disposable) {
    disposable.throwIfNotAvailable();
    throwIfNotAvailable('add');
    _disposables.add(_AsyncWrapperDisposable(disposable));
  }

  void remove(Disposable disposable) {
    throwIfNotAvailable('remove');
    for (final d in _disposables) {
      if (d.disposable == disposable) {
        _disposables.remove(d);
        return;
      }
    }
  }

  void removeAt(int index) {
    throwIfNotAvailable('removeAt');
    _disposables.removeAt(index);
  }

  void clear() {
    throwIfNotAvailable('clear');
    _disposables.clear();
  }

  Future<void> dispose() {
    return _disposable.dispose();
  }

  Future<void> _disposeInternal() async {
    for (final d in _disposables) {
      await d.dispose();
    }
    _disposables.clear();
  }
}

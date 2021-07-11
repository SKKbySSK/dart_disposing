import 'package:disposing/disposing.dart';
import 'package:flutter/material.dart';

mixin DisposableBagStateMixin<T extends StatefulWidget> on State<T> {
  final _syncBag = SyncDisposableBag();
  final _syncLateBag = SyncDisposableBag();

  final _asyncBag = DisposableBag();
  final _asyncLateBag = DisposableBag();

  bool _isDisposing = false;
  bool get isDisposing => _isDisposing;

  @mustCallSuper
  @override
  void dispose() async {
    _isDisposing = true;
    try {
      _syncBag.dispose();
      _syncLateBag.dispose();
    } catch (_) {
      _isDisposing = false;
      rethrow;
    } finally {
      super.dispose();
    }

    try {
      await _disposeAsync();
    } finally {
      _isDisposing = false;
    }
  }

  Future<void> _disposeAsync() async {
    await _asyncBag.dispose();
    await _asyncLateBag.dispose();
  }

  bool shouldLateDispose(Disposable disposable) {
    if (disposable is SyncValueDisposable<ChangeNotifier>) {
      return true;
    } else if (disposable is AsyncValueDisposable<ChangeNotifier>) {
      return true;
    }

    return false;
  }

  void autoDispose(Disposable disposable) {
    if (disposable is SyncDisposable) {
      _addSyncDisposable(disposable);
    } else if (disposable is AsyncDisposable) {
      _addAsyncDisposable(disposable);
    }
  }

  void _addSyncDisposable(SyncDisposable disposable) {
    if (shouldLateDispose(disposable)) {
      _syncLateBag.add(disposable);
    } else {
      _syncBag.add(disposable);
    }
  }

  void _addAsyncDisposable(AsyncDisposable disposable) {
    if (shouldLateDispose(disposable)) {
      _asyncLateBag.add(disposable);
    } else {
      _asyncBag.add(disposable);
    }
  }
}

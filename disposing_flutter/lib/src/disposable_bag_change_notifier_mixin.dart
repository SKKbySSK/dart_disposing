import 'package:disposing/disposing.dart';
import 'package:flutter/material.dart';

mixin DisposableBagChangeNotifierMixin on ChangeNotifier {
  final _syncBag = SyncDisposableBag();
  final _asyncBag = AsyncDisposableBag();

  @mustCallSuper
  @override
  void dispose() {
    _syncBag.dispose();
    _asyncBag.dispose();
    super.dispose();
  }

  void autoDispose(Disposable disposable) {
    if (disposable is SyncDisposable) {
      _syncBag.add(disposable);
    } else if (disposable is AsyncDisposable) {
      _asyncBag.add(disposable);
    }
  }
}

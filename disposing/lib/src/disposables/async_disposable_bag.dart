import 'dart:async';

import 'package:disposing/src/disposables/async_disposables.dart';
import 'package:disposing/src/disposables/disposable_bag_base.dart';

class AsyncDisposableBag extends DisposableBagBase<AsyncDisposable>
    implements AsyncDisposable {
  AsyncCallbackDisposable? _disposable;

  @override
  bool get isDisposing => _disposable?.isDisposing ?? false;

  @override
  bool get isDisposed => _disposable?.isDisposed ?? false;

  Future<void> dispose() async {
    final disposables = toList();
    clear();
    final disp = AsyncCallbackDisposable(() => _disposeInternal(disposables));

    if (_disposable != null) {
      return;
    }
    _disposable = disp;

    await disp.dispose();
  }

  Future<void> _disposeInternal(List<AsyncDisposable> items) async {
    for (final d in this) {
      await d.dispose();
    }
  }
}

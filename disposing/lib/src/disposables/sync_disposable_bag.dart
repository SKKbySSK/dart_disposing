import 'package:disposing/src/disposables/disposable_bag_base.dart';
import 'package:disposing/src/disposables/sync_disposables.dart';

class SyncDisposableBag extends DisposableBagBase<SyncDisposable>
    implements SyncDisposable {
  SyncCallbackDisposable? _disposable;

  @override
  bool get isDisposed => _disposable?.isDisposed ?? false;

  void dispose() {
    final disposables = toList();
    clear();
    final disp = SyncCallbackDisposable(() => _disposeInternal(disposables));

    if (_disposable != null) {
      return;
    }
    _disposable = disp;

    disp.dispose();
  }

  void _disposeInternal(List<SyncDisposable> items) {
    for (final d in this) {
      d.dispose();
    }
  }
}

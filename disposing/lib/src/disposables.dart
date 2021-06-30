import 'dart:async';

abstract class Disposable {
  bool get isDisposing;
  bool get isDisposed;
  Future<void> dispose();
}

class CallbackDisposable extends Disposable {
  CallbackDisposable(this._callback);

  final Future<void> Function() _callback;
  bool _isDisposing = false;
  bool _isDisposed = false;

  @override
  bool get isDisposing => _isDisposing;

  @override
  bool get isDisposed => _isDisposed;

  @override
  Future<void> dispose() async {
    if (isDisposed || _isDisposing) {
      return;
    }
    _isDisposing = true;

    try {
      await _callback();
      _isDisposed = true;
    } catch (_) {
      rethrow;
    } finally {
      _isDisposing = false;
    }
  }
}

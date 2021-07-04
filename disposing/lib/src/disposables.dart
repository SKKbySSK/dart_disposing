import 'dart:async';

abstract class Disposable {
  bool get isDisposing;
  bool get isDisposed;
  Future<void> dispose();

  @override
  String toString() {
    var text = '${this.runtimeType.toString()}';

    if (isDisposing || isDisposed) {
      text += ' (';
      if (isDisposing) {
        text += 'disposing';
      } else {
        text += 'disposed';
      }
      text += ')';
    }

    return text;
  }
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

class ValueDisposable<T> extends CallbackDisposable {
  ValueDisposable(
    this.value,
    Future<void> Function() _callback,
  ) : super(_callback);

  final T value;

  @override
  String toString() {
    var text = '${this.runtimeType.toString()} ($value';

    if (isDisposing || isDisposed) {
      if (isDisposing) {
        text += ', disposing';
      } else {
        text += ', disposed';
      }
    }

    text += ')';

    return text;
  }
}

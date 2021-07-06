import 'package:disposing/src/disposable.dart';

abstract class SyncDisposable extends Disposable {
  bool get isDisposed;
  void dispose();

  @override
  String toString() {
    var text = '${this.runtimeType.toString()}';

    if (isDisposed) {
      text += ' (disposed)';
    }

    return text;
  }
}

class SyncCallbackDisposable extends SyncDisposable {
  SyncCallbackDisposable(this._callback);
  final void Function() _callback;
  bool _isDisposed = false;

  @override
  bool get isDisposed => _isDisposed;

  @override
  void dispose() {
    if (isDisposed) {
      return;
    }

    _callback();
    _isDisposed = true;
  }
}

class SyncValueDisposable<T> extends SyncCallbackDisposable {
  SyncValueDisposable(
    this.value,
    void Function() _callback,
  ) : super(_callback);

  final T value;

  @override
  String toString() {
    var text = '${this.runtimeType.toString()} ($value';

    if (isDisposed) {
      text += ', disposed';
    }

    text += ')';

    return text;
  }
}

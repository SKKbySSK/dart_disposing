import 'package:disposing/disposing.dart';
import 'package:disposing/src/disposable.dart';

abstract class AsyncDisposable extends Disposable {
  bool get isDisposing;
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

  @override
  void throwIfNotAvailable([String? target]) {
    if (isDisposing) {
      throw DisposingException(this, target);
    }

    if (isDisposed) {
      throw DisposedException(this, target);
    }
  }
}

class AsyncCallbackDisposable extends AsyncDisposable {
  AsyncCallbackDisposable(this._callback);

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
    } finally {
      _isDisposing = false;
    }
  }
}

class AsyncValueDisposable<T> extends AsyncCallbackDisposable {
  AsyncValueDisposable(
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

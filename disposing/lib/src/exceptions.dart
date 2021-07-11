import 'package:disposing/src/disposable.dart';

String _getDisposableExceptionMsgPrefix(String? target) {
  return target == null ? '' : 'Can not access $target because ';
}

class DisposingException implements Exception {
  DisposingException._(this.message);

  factory DisposingException(Disposable disposable, [String? target]) {
    final prefix = _getDisposableExceptionMsgPrefix(target);
    return DisposingException._('$prefix$disposable is disposing');
  }

  final String message;

  @override
  String toString() {
    return message;
  }
}

class DisposedException implements Exception {
  DisposedException._(this.message);

  factory DisposedException(Disposable disposable, [String? target]) {
    final prefix = _getDisposableExceptionMsgPrefix(target);
    return DisposedException._('$prefix$disposable was disposed');
  }

  final String message;

  @override
  String toString() {
    return message;
  }
}

class UnknownDisposableException implements Exception {
  UnknownDisposableException._(this.message);

  factory UnknownDisposableException(Disposable disposable) {
    return UnknownDisposableException._(
      '$disposable is not subtype of AsyncDisposable or SyncDisposable',
    );
  }

  final String message;

  @override
  String toString() {
    return message;
  }
}

class BagAggregateException implements Exception {
  BagAggregateException(this.exceptions);
  final Map<Disposable, Object> exceptions;

  @override
  String toString() {
    var lines = 'One or more exceptions has been occured while disposing bag\n';
    var i = 0;
    for (final ex in exceptions.entries) {
      lines += '$i ${ex.key}\n${ex.value}\n';
      i++;
    }

    return lines;
  }
}

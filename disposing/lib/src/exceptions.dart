import 'package:disposing/disposing.dart';

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
import 'package:disposing/src/exceptions.dart';

abstract class Disposable {
  bool get isDisposed;

  void throwIfNotAvailable([String? target]) {
    if (isDisposed) {
      throw DisposedException(this, target);
    }
  }
}

import 'dart:async';

import 'package:disposing/disposing.dart';

typedef UsingBody<T, R> = FutureOr<R> Function(T value);

Future<R> using<T extends Disposable, R>(T value, UsingBody<T, R> body) async {
  value.throwIfDisposed();
  try {
    return await body(value);
  } finally {
    await value.dispose();
  }
}

Future<R> usingValue<T, R>(
  ValueDisposable<T> disposable,
  UsingBody<T, R> body,
) async {
  return using(disposable, (value) {
    return body(disposable.value);
  });
}

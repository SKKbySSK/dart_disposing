import 'dart:async';

import 'package:disposing/src/disposables/async_disposables.dart';
import 'package:disposing/src/disposable.dart';
import 'package:disposing/src/exceptions.dart';
import 'package:disposing/src/extensions.dart';
import 'package:disposing/src/disposables/sync_disposables.dart';

typedef UsingBody<T, R> = FutureOr<R> Function(T value);

Future<R> using<T extends Disposable, R>(T value, UsingBody<T, R> body) async {
  AsyncDisposable _disp;
  if (value is SyncDisposable) {
    value.throwIfNotAvailable();
    _disp = value.asAsync();
  } else if (value is AsyncDisposable) {
    value.throwIfNotAvailable();
    _disp = value;
  } else {
    throw UnknownDisposableException(value);
  }

  try {
    return await body(value);
  } finally {
    await _disp.dispose();
  }
}

Future<R> usingValue<T, R>(
  AsyncValueDisposable<T> disposable,
  UsingBody<T, R> body,
) async {
  return using(disposable, (value) {
    return body(disposable.value);
  });
}

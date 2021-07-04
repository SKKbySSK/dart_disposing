import 'dart:async';

import 'package:disposing/disposing.dart';
import 'package:disposing/src/exceptions.dart';

extension DisposableBagExtension on DisposableBag {
  void addCallback(Future<void> callback()) {
    add(CallbackDisposable(callback));
  }
}

extension DisposableExtension on Disposable {
  void disposeOn(DisposableBag bag) {
    bag.add(this);
  }

  void throwIfDisposed([String? target]) {
    if (isDisposing) {
      throw DisposingException(this, target);
    }

    if (isDisposed) {
      throw DisposedException(this, target);
    }
  }
}

extension StreamSubscriptionExtension<T> on StreamSubscription<T> {
  void disposeOn(DisposableBag bag) {
    bag.add(this.asDisposable());
  }

  ValueDisposable<StreamSubscription<T>> asDisposable() {
    return ValueDisposable(this, this.cancel);
  }
}

extension StreamControllerExtension<T> on StreamController<T> {
  void disposeOn(DisposableBag bag) {
    bag.add(this.asDisposable());
  }

  ValueDisposable<StreamController<T>> asDisposable() {
    return ValueDisposable(this, this.close);
  }
}

extension TimerExtension on Timer {
  void disposeOn(DisposableBag bag) {
    bag.add(this.asDisposable());
  }

  ValueDisposable<Timer> asDisposable() {
    return ValueDisposable(this, () async => this.cancel());
  }
}

import 'dart:async';

import 'package:disposing/disposing.dart';
import 'package:disposing/src/disposable_bag.dart';

extension DisposableBagExtension on DisposableBag {
  void addCallback(Future<void> callback()) {
    add(CallbackDisposable(callback));
  }
}

extension StreamSubscriptionExtension<T> on StreamSubscription<T> {
  void addTo(DisposableBag bag) {
    bag.add(CallbackDisposable(this.cancel));
  }
}

extension StreamControllerExtension<T> on StreamController<T> {
  void addTo(DisposableBag bag) {
    bag.add(CallbackDisposable(this.close));
  }
}

import 'package:disposing/disposing.dart';
import 'package:flutter/foundation.dart';

extension LitenableExtension on Listenable {
  AsyncDisposable addDisposableListener(VoidCallback callback) {
    addListener(callback);
    return AsyncCallbackDisposable(() async => removeListener(callback));
  }
}

extension ChangeNotifierExtension on ChangeNotifier {
  void disposeOn(AsyncDisposableBag bag) {
    bag.add(this.asDisposable());
  }

  AsyncValueDisposable<T> asDisposable<T extends ChangeNotifier>() {
    return AsyncValueDisposable<T>(this as T, () async => dispose());
  }
}

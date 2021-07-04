import 'package:disposing/disposing.dart';
import 'package:flutter/foundation.dart';

extension LitenableExtension on Listenable {
  Disposable addDisposableListener(VoidCallback callback) {
    addListener(callback);
    return CallbackDisposable(() async => removeListener(callback));
  }
}

extension ChangeNotifierExtension on ChangeNotifier {
  void disposeOn(DisposableBag bag) {
    bag.add(this.asDisposable());
  }

  ValueDisposable<T> asDisposable<T extends ChangeNotifier>() {
    return ValueDisposable<T>(this as T, () async => dispose());
  }
}

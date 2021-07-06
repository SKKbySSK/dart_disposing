import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:disposing_flutter/disposing_flutter.dart';

class _TestChangeNotifier extends ChangeNotifier {}

void main() async {
  group('Listenable', () {
    test('listener will be removed', () async {
      var callCount = 0;
      final notifier = _TestChangeNotifier();
      final disp = notifier.addDisposableListener(() => callCount++);

      notifier.notifyListeners();
      expect(callCount, 1);

      disp.dispose();
      notifier.notifyListeners();

      expect(callCount, 1);
    });

    test('can use ChangeNotifier value', () async {
      final notifier = _TestChangeNotifier();
      final disp = notifier.asDisposable<_TestChangeNotifier>();
      expect(disp.value, notifier);
    });
  });
}

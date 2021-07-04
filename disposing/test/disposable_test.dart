import 'package:disposing/disposing.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() async {
  group('CallbackDisposable', () {
    test('correct lifecycle', () async {
      final disp =
          CallbackDisposable(() => Future.delayed(Duration(milliseconds: 100)));
      await _testLifecycle(disp);
    });

    test('call callback when disposing', () async {
      var called = false;
      final disp = CallbackDisposable(() async => called = true);
      await disp.dispose();

      expect(called, true);
    });
  });

  group('ValueDisposable', () {
    const value = 'TEST_VALUE';

    test('correct lifecycle', () async {
      final disp = ValueDisposable(
        value,
        () => Future.delayed(Duration(milliseconds: 100)),
      );
      await _testLifecycle(disp);
    });

    test('call callback when disposing', () async {
      var called = false;
      final disp = ValueDisposable(value, () async => called = true);
      await disp.dispose();

      expect(called, true);
    });

    test('has correct value', () async {
      final disp = ValueDisposable(value, () async => {});
      expect(disp.value, value);
    });
  });
}

Future<void> _testLifecycle(Disposable disposable) async {
  print(disposable);
  expect(disposable.isDisposing, false);
  expect(disposable.isDisposed, false);

  final dispFuture = disposable.dispose();
  print(disposable);
  expect(disposable.isDisposing, true);
  expect(disposable.isDisposed, false);

  await dispFuture;
  print(disposable);
  expect(disposable.isDisposing, false);
  expect(disposable.isDisposed, true);
}

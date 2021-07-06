import 'package:disposing/disposing.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() async {
  group('CallbackDisposable', () {
    test('correct lifecycle', () async {
      final disp = AsyncCallbackDisposable(
          () => Future.delayed(Duration(milliseconds: 100)));
      await _testAsyncLifecycle(disp);
    });

    test('call callback when disposing', () async {
      var called = false;
      final disp = AsyncCallbackDisposable(() async => called = true);
      await disp.dispose();

      expect(called, true);
    });
  });

  group('ValueDisposable', () {
    const value = 'TEST_VALUE';

    test('correct lifecycle', () async {
      final disp = AsyncValueDisposable(
        value,
        () => Future.delayed(Duration(milliseconds: 100)),
      );
      await _testAsyncLifecycle(disp);
    });

    test('call callback when disposing', () async {
      var called = false;
      final disp = AsyncValueDisposable(value, () async => called = true);
      await disp.dispose();

      expect(called, true);
    });

    test('has correct value', () async {
      final disp = AsyncValueDisposable(value, () async => {});
      expect(disp.value, value);
    });
  });
}

Future<void> _testAsyncLifecycle(AsyncDisposable disposable) async {
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

void _testSyncLifecycle(SyncDisposable disposable) {
  print(disposable);
  expect(disposable.isDisposed, false);

  disposable.dispose();
  print(disposable);
  expect(disposable.isDisposed, false);
}

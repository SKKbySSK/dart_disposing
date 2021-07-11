import 'package:disposing/disposing.dart';
import 'package:test/expect.dart';
import 'package:test/test.dart';

class ErrorDisposable extends SyncDisposable {
  @override
  bool get isDisposed => false;

  @override
  void dispose() {
    throw Exception();
  }
}

void main() async {
  group('SyncDisposableBag', () {
    test('dispose all disposables', () async {
      final disposables = <Disposable>[];
      final bag = SyncDisposableBag();
      for (var i = 0; i < 100; i++) {
        final d = SyncCallbackDisposable(() => {});
        disposables.add(d);
        bag.add(d);
      }

      bag.dispose();
      for (final disp in disposables) {
        expect(disp.isDisposed, true);
      }
    });

    test('throw an aggregate exception', () async {
      final disposables = <Disposable>[];
      final bag = SyncDisposableBag();
      final error = ErrorDisposable();
      bag.add(error);

      for (var i = 0; i < 100; i++) {
        final d = SyncCallbackDisposable(() => {});
        disposables.add(d);
        bag.add(d);
      }

      expect(bag.dispose, throwsA(isA<BagAggregateException>()));
      for (final disp in disposables) {
        if (disp == error) {
          continue;
        }

        expect(disp.isDisposed, true);
      }
    });
  });

  group('DisposableBag', () {
    test('dispose all disposables', () async {
      final disposables = <Disposable>[];
      final bag = DisposableBag();
      for (var i = 0; i < 100; i++) {
        final d = SyncCallbackDisposable(() => {});
        disposables.add(d);
        bag.add(d);
      }

      await bag.dispose();
      for (final disp in disposables) {
        expect(disp.isDisposed, true);
      }
    });

    test('throw an aggregate exception', () async {
      final disposables = <Disposable>[];
      final bag = DisposableBag();
      final error = ErrorDisposable();
      bag.add(error);

      for (var i = 0; i < 100; i++) {
        final d = SyncCallbackDisposable(() => {});
        disposables.add(d);
        bag.add(d);
      }

      await expectLater(bag.dispose, throwsA(isA<BagAggregateException>()));
      for (final disp in disposables) {
        if (disp == error) {
          continue;
        }

        expect(disp.isDisposed, true);
      }
    });
  });
}

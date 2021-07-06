import 'package:disposing/src/disposable.dart';

abstract class DisposableBagBase<T extends Disposable> extends Iterable<T>
    with Disposable {
  final _disposables = <T>[];

  void add(T disposable) {
    _disposables.add(disposable);
  }

  void addAll(Iterable<T> disposables) {
    throwIfNotAvailable();
    _disposables.addAll(disposables);
  }

  void remove(T disposable) {
    throwIfNotAvailable();
    _disposables.remove(disposable);
  }

  void removeAt(int index) {
    throwIfNotAvailable();
    _disposables.removeAt(index);
  }

  void clear() {
    throwIfNotAvailable();
    _disposables.clear();
  }

  int get length => _disposables.length;

  @override
  Iterator<T> get iterator => _disposables.iterator;
}

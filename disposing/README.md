# disposing

Disposing is a flutter package adds dispose method on many classes.
It also provides Disposable and DisposableBag to easy to manage disposable instances.

## Installation
Add dependencies to your pubspec.yaml

### Dart only
```yaml
dependencies:
  disposing: ^1.0.1
```

### Flutter
```yaml
dependencies:
  flutter_disposing: ^1.0.0+6
```

## How to Use

1. First, you need to import disposing.dart file

```dart
import 'package:disposing/disposing.dart';
```

2. Convert instance to disposable

```dart
// You can convert StreamSubscription, StreamController, Timer and so on.
final streamDisp = stream.listen((v) => {}).asDisposable();
final timerDisp = timer.asDisposable();
```

3. (Optional) Add disposable instances to DisposableBag

```dart
final bag = DisposableBag();
bag.add(streamDisp);
bag.add(timerDisp);
```

Or you can add disposable directly
```dart
stream.listen((v) => {}).disposeOn(bag);
timer.disposeOn(bag);
```

4. Dispose them!

```dart
// Without DisposeBag
await streamDisp.dispose();
await timerDisp.dispose();

// With DisposeBag
await bag.dispose();
```

### For Flutter
flutter_disposing adds Listenable extension methods and DisposableBagStateMixin class.

#### Listenable
Listenable is a base class of ChangeNotifier which is used by TextEditingController, FocusNode, ValueNotifier and many other flutter classes.

Use `addDisposableListener` to adds a listener function and returns disposable instance.
```dart
final controller = TextEditingController();
final disp = controller.addDisposableListener(() => print(controller.text));
```

#### DisposableBagStateMixin
This mixin adds `disposeBag` variable and dispose it when the widget's state is being disposed.

```dart
class ExampleWidget extends StatefulWidget {
  ExampleWidget({Key? key}) : super(key: key);

  @override
  _ExampleWidgetState createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget>
    with DisposableBagStateMixin {
  final controller = TextEditingController();

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (t) => {}).disposeOn(disposeBag);
    controller.addDisposableListener(() => print(controller.text)).disposeOn(disposeBag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
    );
  }
}
```

### using
`using` is an utility method which will dispose disposable instance automatically after the callback execution is finished (like [C# using statement](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/using-statement)).

```dart
await using(someDisposable, (disposable) async {
  // do something...
});
assert(someDisposable.isDisposed, true);
```

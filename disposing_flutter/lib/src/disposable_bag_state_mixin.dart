import 'package:disposing/disposing.dart';
import 'package:flutter/material.dart';

mixin DisposableBagStateMixin {
  final disposeBag = DisposableBag();

  @mustCallSuper
  void dispose() {
    disposeBag.dispose();
  }
}

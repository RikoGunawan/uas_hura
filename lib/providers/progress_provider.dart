import 'package:flutter/material.dart';

class ProgressProvider extends ChangeNotifier {
  double _progress = 0.3;

  double get progress => _progress;

  void updateProgress(double value) {
    _progress = value;
    notifyListeners();
  }
}

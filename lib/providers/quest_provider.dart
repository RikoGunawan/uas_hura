import 'package:flutter/material.dart';

import '../models/quest.dart';

class QuestProvider with ChangeNotifier {
  Quest _task = Quest(name: 'Default Task', progress: 0.0);

  Quest get task => _task;

  void updateTask(String name, double progress) {
    _task = Quest(name: name, progress: progress);
    notifyListeners();
  }
}

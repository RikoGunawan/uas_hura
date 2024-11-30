import 'package:flutter/material.dart';
import '../models/quest.dart';

class QuestProvider with ChangeNotifier {
  List<Quest> _quests = [];
  int _nextId = 1;

  List<Quest> get quests => _quests;

  List<Quest> getQuests() {
    if (_quests.isEmpty) {
      _quests = [
        Quest(id: _nextId++, name: 'Quest 1', progress: 0.0),
        Quest(id: _nextId++, name: 'Quest 2', progress: 0.0),
        Quest(id: _nextId++, name: 'Quest 3', progress: 0.0),
      ];
      notifyListeners();
    }
    return _quests;
  }

  void addQuest(String name, double progress) {
    _quests.add(Quest(id: _nextId++, name: name, progress: progress));
    notifyListeners();
  }

  void updateQuest(int id, String name, double progress) {
    final quest = _quests.firstWhere((q) => q.id == id);
    quest.name = name;
    quest.progress = progress;
    notifyListeners();
  }

  void removeQuest(int id) {
    _quests.removeWhere((quest) => quest.id == id);
    notifyListeners();
  }

  void resetQuests() {
    _quests.clear();
    notifyListeners();
  }
}

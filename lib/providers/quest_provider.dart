import 'package:flutter/material.dart';
import '../models/quest.dart';

class QuestProvider with ChangeNotifier {
  // List of quests, initially empty
  List<Quest> _quests = [];
  int _nextId = 1; // Variable to track the next unique ID

  // Getter for the quests list
  List<Quest> get quests => _quests;

  // Fetch initial set of quests (this could be replaced by an API or database call)
  List<Quest> getQuests() {
    // Initialize quests if not already initialized
    if (_quests.isEmpty) {
      _quests = [
        Quest(id: _nextId++, name: 'Quest 1', progress: 0.0),
        Quest(id: _nextId++, name: 'Quest 2', progress: 0.0),
        Quest(id: _nextId++, name: 'Quest 3', progress: 0.0),
      ];
      notifyListeners(); // Notify listeners when quests are loaded or updated
    }
    return _quests;
  }

  // Method to add a new quest with a unique ID
  void addQuest(String name, double progress) {
    final newQuest = Quest(id: _nextId++, name: name, progress: progress);
    _quests.add(newQuest);
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // Method to update an existing quest
  void updateQuest(int id, String name, double progress) {
    final quest = _quests.firstWhere((q) => q.id == id);
    quest.name = name;
    quest.progress = progress;
    notifyListeners();
  }

  // Remove a quest by its ID
  void removeQuest(int id) {
    _quests.removeWhere((quest) => quest.id == id);
    notifyListeners(); // Notify listeners when a quest is removed
  }

  // Optionally, you can add methods for resetting quests if needed
  void resetQuests() {
    _quests.clear();
    notifyListeners(); // Notify listeners when the quests are reset
  }
}

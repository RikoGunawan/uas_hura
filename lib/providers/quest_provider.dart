import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quest.dart';

class QuestProvider with ChangeNotifier {
  List<Quest> _quests = [];
  int _nextId = 1;
  DateTime? _lastLoginDate;

  List<Quest> get quests => _quests;

  QuestProvider() {
    getQuests(); // Memuat data awal saat provider diinisialisasi
    loadLastLoginDate(); // Memuat tanggal login terakhir
  }

  List<Quest> getQuests() {
    if (_quests.isEmpty) {
      _quests = [
        Quest(id: _nextId++, name: 'Kenali Flora dan Fauna', progress: 0.0),
        Quest(id: _nextId++, name: 'Fotografi Alam', progress: 0.0),
        Quest(id: _nextId++, name: 'Tanam Pohon', progress: 0.0),
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

  // Fungsi untuk menambah progress quest
  void addProgressToQuest(int id, double progressToAdd) {
    final quest = _quests.firstWhere((q) => q.id == id);
    quest.progress += progressToAdd;

    // Cegah progress melebihi 100%
    if (quest.progress > 100.0) {
      quest.progress = 100.0;
    }

    notifyListeners();
  }

  // Fungsi untuk menurunkan progress quest
  void subtractProgressFromQuest(int id, double progressToSubtract) {
    final quest = _quests.firstWhere((q) => q.id == id);
    quest.progress -= progressToSubtract;

    // Cegah progress menjadi negatif
    if (quest.progress < 0.0) {
      quest.progress = 0.0;
    }

    notifyListeners();
  }

  // Mengatur ulang progress quest ke 0
  void resetProgress(int id) {
    final quest = _quests.firstWhere((q) => q.id == id);
    quest.progress = 0.0;
    notifyListeners();
  }

  // Menyimpan data tanggal login terakhir
  Future<void> updateDailyProgressOnLogin() async {
    final today = DateTime.now();
    if (_lastLoginDate == null || !_isSameDay(_lastLoginDate!, today)) {
      addProgressToQuest(
          1, 5.0); // Misalnya menambah 5% progress pada quest pertama
      _lastLoginDate = today;

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('lastLoginDate', today.toIso8601String());

      notifyListeners();
    }
  }

  // Memuat tanggal login terakhir dari SharedPreferences
  Future<void> loadLastLoginDate() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('lastLoginDate');
    if (savedDate != null) {
      _lastLoginDate = DateTime.parse(savedDate);
    }
  }

  // Fungsi untuk mengecek apakah dua tanggal itu sama
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

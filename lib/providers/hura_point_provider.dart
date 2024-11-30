import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/hura_point.dart';

class HuraPointProvider extends ChangeNotifier {
  HuraPointModel huraPoint = HuraPointModel(
    currentPoints: 10,
    dailyLimit: 20,
    totalPoints: 100,
  );

  DateTime? _lastLoginDate;

  // Getter untuk progress
  double get progress {
    return (huraPoint.dailyLimit > 0)
        ? huraPoint.currentPoints / huraPoint.dailyLimit
        : 0.0;
  }

  // Update poin harian
  void updateCurrentPoints(int newPoints) {
    if (newPoints <= huraPoint.dailyLimit) {
      huraPoint.currentPoints = newPoints;
      notifyListeners();
    } else {
      throw Exception("Current points cannot exceed the daily limit!");
    }
  }

  void updateDailyLimit(int newLimit) {
    huraPoint.dailyLimit = newLimit;
    notifyListeners();
  }

  void updateTotalPoints(int newTotal) {
    huraPoint.totalPoints = newTotal;
    notifyListeners();
  }

  // Tambah poin harian
  void addDailyPoints(int points) {
    huraPoint.addPoints(points);
    notifyListeners();
  }

  void resetDailyPoints() {
    huraPoint.currentPoints = 0;
    notifyListeners();
  }

  void claimPoints(int missionPoints) {
    huraPoint.totalPoints += missionPoints;
    notifyListeners();
  }

  // Login harian: update poin dan simpan tanggal
  Future<void> updateDailyPointsOnLogin() async {
    final today = DateTime.now();
    if (_lastLoginDate == null || !_isSameDay(_lastLoginDate!, today)) {
      addDailyPoints(1);
      _lastLoginDate = today;

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('lastLoginDate', today.toIso8601String());

      notifyListeners();
    }
  }

  // Load tanggal login terakhir dari SharedPreferences
  Future<void> loadLastLoginDate() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('lastLoginDate');
    if (savedDate != null) {
      _lastLoginDate = DateTime.parse(savedDate);
    }
  }

  // Fungsi helper untuk cek apakah dua tanggal sama
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

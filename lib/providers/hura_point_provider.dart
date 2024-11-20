import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/hura_point.dart';

class HuraPointProvider extends ChangeNotifier {
  HuraPointModel huraPoint = HuraPointModel(
    currentPoints: 0,
    dailyLimit: 10,
    totalPoints: 0,
  );

  DateTime? _lastLoginDate; // Tanggal login terakhir (null jika belum login)

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

  // Cek apakah login di hari yang sama
  void updateDailyPointsOnLogin() async {
    final today = DateTime.now();
    if (_lastLoginDate == null || !_isSameDay(_lastLoginDate!, today)) {
      addDailyPoints(1);
      _lastLoginDate = today;

      // Simpan tanggal ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('lastLoginDate', today.toIso8601String());

      notifyListeners();
    }
  }

  Future<void> loadLastLoginDate() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('lastLoginDate');
    if (savedDate != null) {
      _lastLoginDate = DateTime.parse(savedDate);
    }
  }

  // Fungsi helper untuk mengecek apakah dua tanggal ada di hari yang sama
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

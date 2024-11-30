class HuraPointModel {
  int _currentPoints;
  int _dailyLimit;
  int _totalPoints;

  HuraPointModel({
    required int currentPoints,
    required int dailyLimit,
    required int totalPoints,
  })  : _currentPoints = currentPoints,
        _dailyLimit = dailyLimit,
        _totalPoints = totalPoints;

  // Getter and Setter for currentPoints
  int get currentPoints => _currentPoints;
  set currentPoints(int value) {
    if (value >= 0) {
      _currentPoints = value;
    } else {
      throw ArgumentError("currentPoints cannot be negative");
    }
  }

  // Getter and Setter for dailyLimit
  int get dailyLimit => _dailyLimit;
  set dailyLimit(int value) {
    if (value > 0) {
      _dailyLimit = value;
    } else {
      throw ArgumentError("dailyLimit must be greater than 0");
    }
  }

  // Getter and Setter for totalPoints
  int get totalPoints => _totalPoints;
  set totalPoints(int value) {
    if (value >= 0) {
      _totalPoints = value;
    } else {
      throw ArgumentError("totalPoints cannot be negative");
    }
  }

  void addPoints(int points) {
    if (currentPoints + points <= dailyLimit) {
      currentPoints += points;
      totalPoints += points;
    }
  }

  bool canClaim() {
    return currentPoints < dailyLimit;
  }
}

class HuraPointModel {
  int currentPoints;
  int dailyLimit;
  int totalPoints;

  HuraPointModel({
    required this.currentPoints,
    required this.dailyLimit,
    required this.totalPoints,
  });

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

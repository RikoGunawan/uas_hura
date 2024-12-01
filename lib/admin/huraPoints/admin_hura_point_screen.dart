import 'package:flutter/material.dart';

class AdminHuraPointScreen extends StatefulWidget {
  const AdminHuraPointScreen({super.key});

  @override
  State<AdminHuraPointScreen> createState() => _AdminHuraPointScreenState();
}

class _AdminHuraPointScreenState extends State<AdminHuraPointScreen> {
  int _currentIndex = 0;

  // Fungsi untuk mengubah tab
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 16.0),
          // Tombol kategori
          _buildCategoryButtons(),
          const SizedBox(height: 16.0),
          // Konten kategori
          Expanded(
            child: Center(
              child: _buildCategoryContent(context),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk kategori tombol
  Widget _buildCategoryButtons() {
    const categories = ['Rank', 'Quest', 'Reward'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: categories.map((category) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: _buildButton(category, categories.indexOf(category)),
        );
      }).toList(),
    );
  }

  // Tombol kategori
  Widget _buildButton(String text, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red, width: 1.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Konten kategori berdasarkan tab yang dipilih
  Widget _buildCategoryContent(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        return buildContainerLeader(context, "Leaderboard");
      case 1:
        return buildContainerQuest(context, "Quest", []);
      case 2:
        return buildContainerReward(context, "Reward", 0);
      default:
        return const SizedBox.shrink();
    }
  }
}

// Fungsi untuk membangun tampilan leaderboard
Widget buildContainerLeader(BuildContext context, String type) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(10.0),
    ),
    padding: const EdgeInsets.all(16.0),
    width: MediaQuery.of(context).size.width * 0.85,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.5,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        Expanded(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 12.0,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'Username ${index + 1}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const Spacer(),
                    Text(
                      '${1000 - index}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

// Fungsi untuk membangun tampilan quest (dummy)
Widget buildContainerQuest(BuildContext context, String type, List quests) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(10.0),
    ),
    padding: const EdgeInsets.all(16.0),
    width: MediaQuery.of(context).size.width * 0.85,
    child: Center(
      child: Text(
        type,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

// Fungsi untuk membangun tampilan reward (dummy)
Widget buildContainerReward(BuildContext context, String type, int rewardCount) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(10.0),
    ),
    padding: const EdgeInsets.all(16.0),
    width: MediaQuery.of(context).size.width * 0.85,
    child: Center(
      child: Text(
        type,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

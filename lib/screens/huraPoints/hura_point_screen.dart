import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/progress_provider.dart';
import 'leaderboard_widget.dart';
import 'quest_widget.dart';
import 'reward_widget.dart';

class HuraPointScreen extends StatefulWidget {
  const HuraPointScreen({super.key});

  @override
  State<HuraPointScreen> createState() => _HuraPointScreenState();
}

class _HuraPointScreenState extends State<HuraPointScreen> {
  int _currentIndex = 0;
  final PointProvider pointProvider = PointProvider();

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      pointProvider.selectedCategory = pointProvider.categories[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressProvider = context.watch<ProgressProvider>();
    final progress = progressProvider.progress;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressBar(context, progress),
              const SizedBox(height: 14.0),
              _buildCategoryButtons(),
              const SizedBox(height: 14.0),
              _buildCategoryContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, double progress) {
    return Container(
      height: 100.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 10.0,
            top: 15.0,
            child: CircleAvatar(
              radius: 17.0,
              backgroundColor: Colors.white,
            ),
          ),
          // Garis putih latar belakang
          Positioned(
            left: 10.0,
            top: 55.0,
            child: Container(
              height: 10.0, // Tinggi garis putih
              width: MediaQuery.of(context).size.width - 40.0, // Lebar penuh
              decoration: BoxDecoration(
                color: Colors.white, // Garis putih
                borderRadius: BorderRadius.circular(7.0),
              ),
            ),
          ),
          // Linear progress bar
          Positioned(
            left: 10.0,
            top: 55.0,
            child: Container(
              height: 10.0, // Tinggi progress bar
              width: (MediaQuery.of(context).size.width - 40.0) *
                  progress, // Sesuai progress
              decoration: BoxDecoration(
                color: Colors.grey, // Warna progress
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pointProvider.categories.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: _buildButton(pointProvider.categories[index], index),
        );
      }),
    );
  }

  Widget _buildButton(String text, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Widget untuk menyimpan isi dari setiap category content
  Widget _buildCategoryContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pointProvider.getPostWidgets(context),
    );
  }
}

class PointProvider {
  String selectedCategory = 'Rank';

  final List<String> categories = ['Rank', 'Quest', 'Reward'];

  List<Widget> getPostWidgets(BuildContext context) {
    switch (selectedCategory) {
      case 'Rank':
        return [buildContainerLeader(context, "Leaderboard")];
      case 'Quest':
        return [buildContainerQuest(context, "Quest", 0)];
      case 'Reward':
        return [buildContainerReward(context, "Reward", 0)];
      default:
        return [];
    }
  }
}

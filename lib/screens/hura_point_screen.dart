import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/progress_provider.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16.0),
            _buildProgressBar(context, progress),
            const SizedBox(height: 16.0),
            _buildCategoryButtons(),
            const SizedBox(height: 16.0),
            _buildCategoryContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Hura Point',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.grey,
        ),
      ],
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
              height: 10.0, // Lebar garis putih lebih besar
              width: 450, // Lebar penuh
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
              height: 10.0, // Tinggi progress bar lebih kecil
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
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  //widget untuk menyimpan isi dari setiap category content
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
        return [_buildContainerLeader(context, "Leaderboard")];
      case 'Quest':
        return [_buildContainerQuest(context, "Quest", 0)];
      case 'Reward':
        return [_buildContainerReward(context, "Reward", 0)];
      default:
        return [];
    }
  }

  Widget _buildContainerQuest(
      BuildContext context, String type, double progress) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        height: 370.0,
        width: 460.0,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hura Point',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 15.0,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(width: 8.0),
                          Positioned(
                            left: 10.0,
                            top: 55.0,
                            child: Container(
                              height: 10.0, // Lebar garis putih lebih besar
                              width: 350, // Lebar penuh
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
                              height: 10.0, // Tinggi progress bar lebih kecil
                              width: 0 * progress, // Sesuai progress
                              decoration: BoxDecoration(
                                color: Colors.grey, // Warna progress
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0), // Gap between players
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerReward(
      BuildContext context, String type, double progress) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        height: 370.0,
        width: 460.0,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              type,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 15.0,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(width: 8.0),
                          Positioned(
                            left: 10.0,
                            top: 55.0,
                            child: Container(
                              height: 10.0, // Lebar garis putih lebih besar
                              width: 350, // Lebar penuh
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
                              height: 10.0, // Tinggi progress bar lebih kecil
                              width: 0 * progress, // Sesuai progress
                              decoration: BoxDecoration(
                                color: Colors.grey, // Warna progress
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0), // Gap between players
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerLeader(BuildContext context, String type) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        height: 370.0,
        width: 460.0,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              type,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 15.0,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(width: 8.0),
                          Text('Pengguna ${index + 1}'),
                        ],
                      ),
                      const SizedBox(height: 8.0), // Gap between players
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

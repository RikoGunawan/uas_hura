import 'package:flutter/material.dart';
import 'package:myapp/admin/huraPoints/add_point_screen.dart';
import 'package:myapp/admin/huraPoints/edit_leaderboard_widget.dart';
import 'package:myapp/admin/huraPoints/edit_point_screen.dart';
import 'package:myapp/admin/huraPoints/edit_quest_widget.dart';
import 'package:myapp/providers/quest_provider.dart';
import 'package:myapp/screens/huraPoints/reward_widget.dart';
import 'package:provider/provider.dart';

class AdminHuraPointScreen extends StatefulWidget {
  const AdminHuraPointScreen({super.key});

  @override
  State<AdminHuraPointScreen> createState() => _AdminHuraPointScreenState();
}

class _AdminHuraPointScreenState extends State<AdminHuraPointScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final progressProvider = context.watch<ProgressProvider>();
    // final progress = progressProvider.progress;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14.0),
              _buildCategoryButtons(),
              const SizedBox(height: 14.0),
              _buildCategoryContent(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "Hura Point",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      actions: [
        // Edit icon
        IconButton(
          icon: const Icon(Icons.edit_square, color: Colors.green),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditPointScreen(),
              ),
            );
          },
        ),
        // Add icon
        IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.red),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPointScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

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

  Widget _buildCategoryContent(BuildContext context) {
    return Consumer<QuestProvider>(
      builder: (context, questProvider, child) {
        final quests = questProvider.quests;

        switch (_currentIndex) {
          case 0:
            return buildContainerLeader(context, "Leaderboard");
          case 1:
            return buildContainerQuest(context, "Quest", quests); // Pass quests directly
          case 2:
            return buildContainerReward(context, "Reward", 0);
          default:
            return Container();
        }
      },
    );
  }
}

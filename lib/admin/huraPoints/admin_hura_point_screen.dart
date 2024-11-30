import 'package:flutter/material.dart';
import 'package:myapp/admin/huraPoints/add_point_screen.dart';
import 'package:myapp/admin/huraPoints/edit_point_screen.dart';
import 'package:myapp/screens/huraPoints/reward_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/progress_provider.dart';
import 'leaderboard_widget.dart';
import 'quest_widget.dart';
import 'edit_point_screen.dart'; // Assuming this is the screen for editing quests
import 'add_point_screen.dart'; // Assuming this is the screen for adding quests

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
    final progressProvider = context.watch<ProgressProvider>();
    final progress = progressProvider.progress;

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
        style: TextStyle(color: Colors.black, fontSize: 14),
      ),
      actions: [
        // Edit icon
        IconButton(
          icon: const Icon(Icons.edit_square, color: Colors.green),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditPointScreen()),
            );
          },
        ),
        // Add icon
        IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.red),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddPointScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['Rank', 'Quest', 'Reward'].map((category) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: _buildButton(category),
        );
      }).toList(),
    );
  }

  Widget _buildButton(String text) {
    final isSelected =
        _currentIndex == ['Rank', 'Quest', 'Reward'].indexOf(text);
    return GestureDetector(
      onTap: () => _onTabTapped(['Rank', 'Quest', 'Reward'].indexOf(text)),
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
    return Consumer<QuestProvider>(builder: (context, questProvider, child) {
      var quests = questProvider.quests;

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
    });
  }
}

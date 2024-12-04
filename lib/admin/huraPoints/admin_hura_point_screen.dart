import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/profile.dart';
import '../../screens/huraPoints/leaderboard_widget.dart';
import '../../screens/huraPoints/quest_widget.dart';
import '../../screens/huraPoints/reward_widget.dart';
import '../../services/supabase_service.dart';

class AdminHuraPointScreen extends StatefulWidget {
  final String? userId;

  const AdminHuraPointScreen({Key? key, this.userId}) : super(key: key);

  @override
  _AdminHuraPointScreenState createState() => _AdminHuraPointScreenState();
}

class _AdminHuraPointScreenState extends State<AdminHuraPointScreen> {
  int _currentIndex = 0;
  Profile? profile;
  final HuraPointCategory huraPointCategory = HuraPointCategory();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await SupabaseService.loadProfile(
        widget.userId ?? Supabase.instance.client.auth.currentUser!.id,
      );
      if (data != null) {
        setState(() {
          profile = Profile.fromJson(
            data,
          );
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      huraPointCategory.selectedCategory = huraPointCategory.categories[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

  Widget _buildCategoryButtons() {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth * 0.015;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(huraPointCategory.categories.length, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: _buildButton(huraPointCategory.categories[index], index),
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
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Widget for content under each category
  Widget _buildCategoryContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: huraPointCategory.getPostWidgets(context),
    );
  }
}

class HuraPointCategory {
  String selectedCategory = 'Rank';
  final List<String> categories = ['Rank', 'Quest', 'Reward'];

  List<Widget> getPostWidgets(BuildContext context) {
    switch (selectedCategory) {
      case 'Rank':
        return [buildContainerLeader(context, "Leaderboard")];
      case 'Quest':
        return [buildContainerQuest(context)];
      case 'Reward':
        return [buildContainerReward(context, "Reward", 0, 0, 0)];
      default:
        return [];
    }
  }
}

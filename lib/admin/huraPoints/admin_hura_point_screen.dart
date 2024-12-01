import 'package:flutter/material.dart';
import 'package:myapp/admin/huraPoints/edit_leaderboard_widget.dart';
import 'package:myapp/admin/huraPoints/edit_quest_widget.dart';
import 'package:myapp/admin/huraPoints/edit_reward_widget.dart';
import 'package:myapp/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/profile.dart';
import '../../providers/hura_point_provider.dart';
import '../../services/supabase_service.dart';


class AdminHuraPointScreen extends StatefulWidget {
  final String? userId;
  const AdminHuraPointScreen({super.key, this.userId});

  @override
  State<AdminHuraPointScreen> createState() => _AdminHuraPointScreenState();
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
          widget.userId ?? Supabase.instance.client.auth.currentUser!.id);
      if (data != null) {
        setState(() {
          profile = Profile.fromJson(data);
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
    // Ambil HuraPointProvider dari context
    final huraPointProvider = Provider.of<HuraPointProvider>(context);

    // Sederhanakan akses atribut dengan variabel lokal
    final currentPoints = huraPointProvider.huraPoint.currentPoints;
    final dailyLimit = huraPointProvider.huraPoint.dailyLimit;
    final progress = huraPointProvider.progress;

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
    double horizontalPadding = screenWidth *
        0.015; // Mengatur padding antar tombol berdasarkan lebar layar

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

  // Widget untuk menyimpan isi dari setiap category content
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
        return [buildContainerQuest(context, "Quest", 0)];
      case 'Reward':
        return [buildContainerReward(context, "Reward", 0)];
      default:
        return [];
    }
  }
}
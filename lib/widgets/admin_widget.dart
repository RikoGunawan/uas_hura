import 'package:flutter/material.dart';
import 'package:myapp/admin/admin_profile.dart';
import 'package:myapp/admin/data_pengunjung.dart';
import 'package:myapp/admin/huraEvents/add_hura_event.dart';
import 'package:myapp/admin/huraEvents/admin_hura_event_screen.dart';
import 'package:myapp/admin/huraPoints/add_point_screen.dart';
import 'package:myapp/admin/huraPoints/admin_hura_point_screen.dart';
import 'package:myapp/admin/huraPoints/edit_point_screen.dart';
import 'package:myapp/providers/event_provider.dart';
import 'package:myapp/providers/quest_provider.dart';
import 'package:provider/provider.dart';

class AdminWidget extends StatefulWidget {
  const AdminWidget({super.key});

  @override
  State<AdminWidget> createState() => _AdminWidgetState();
}

class _AdminWidgetState extends State<AdminWidget> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AdminHuraEventScreen(),
    const AdminHuraPointScreen(),
    const DataPengunjung(),
    const AdminProfileScreen(),
  ];

  final List<String> _titles = [
    'Hura Event',
    'Hura Point',
    'Data Pengunjung',
    'Profile',
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainWidgetTemplate(
      body: _pages[_currentIndex],
      currentIndex: _currentIndex,
      onTabTapped: _onTabTapped,
      title: _titles[_currentIndex],
    );
  }
}

class MainWidgetTemplate extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final Function(int) onTabTapped;
  final String title;

  const MainWidgetTemplate({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTabTapped,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: body,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      titleSpacing: 20.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title Text
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Conditional Actions for specific titles
          if (title == 'Hura Event') ...[
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.red),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddHuraEvent(
                      events: Provider.of<EventProvider>(context, listen: false)
                          .events,
                    ),
                  ),
                );
              },
            ),
          ],
          if (title == 'Hura Point') ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                IconButton(
                  icon: const Icon(Icons.edit_square, color: Colors.green),
                  onPressed: () {
                    final questProvider =
                        Provider.of<QuestProvider>(context, listen: false);

                    // Pastikan ada quest untuk diedit
                    if (questProvider.quests.isNotEmpty) {
                      final quest =
                          questProvider.quests.first; // Edit quest pertama
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditHuraQuest(quests: questProvider.quests),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No quest available to edit'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 50,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildBottomNavigationItem(Icons.event, 0),
          _buildBottomNavigationItem(Icons.point_of_sale, 1),
          _buildBottomNavigationItem(Icons.people, 2),
          _buildBottomNavigationItem(Icons.person, 3),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationItem(IconData icon, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? const Color.fromARGB(255, 42, 62, 35)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.black,
          size: 20,
        ),
      ),
    );
  }
}

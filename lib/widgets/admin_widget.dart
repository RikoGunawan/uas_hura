import 'package:flutter/material.dart';
import 'package:myapp/admin/admin_profile.dart';
import 'package:myapp/admin/data_pengunjung.dart';
import 'package:myapp/admin/huraEvents/admin_hura_event_screen.dart';
import 'package:myapp/admin/huraPoints/admin_hura_point_screen.dart';
import 'package:myapp/main_widget.dart';

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
    'Hura Event Admin',
    'Hura Point Admin',
    'Data Pengunjung',
    'Admin Profile',
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _titles[_currentIndex],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}

// Custom Bottom Navigation Bar
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
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabTapped,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Hura Event',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.point_of_sale),
          label: 'Hura Point',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Data Pengunjung',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

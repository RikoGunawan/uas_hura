import 'package:flutter/material.dart';
import 'package:myapp/screens/creativeHura/creative_hura_screen.dart';

import 'package:provider/provider.dart';

import 'providers/event_provider.dart';

import 'screens/huraEvents/event_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/huraPoints/hura_point_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/profile/profile_screen.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const EventScreen(),
    const CreativeHuraScreen(),
    // const HuraPointScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    'Home',
    'Events',
    'Hura',
    'Hura Point',
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
      title: _titles[_currentIndex], // Kirim judul sesuai halaman
    );
  }
}

//---------------------------------------- Kontrol Main Widget

class MainWidgetTemplate extends StatelessWidget {
  final Widget body; // Konten layar
  final int currentIndex; // Indeks tab yang dipilih
  final Function(int) onTabTapped; // Callback untuk navigasi tab
  final String title; // Judul AppBar

  const MainWidgetTemplate({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTabTapped,
    required this.title, // Parameter judul
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(), // Kondisional untuk AppBar
      body: body,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }

  _buildAppBar() {
    if (currentIndex == 2 || currentIndex == 4) {
      // Halaman Hura
      return null;
    } else {
      // AppBar default
      return CustomAppBar(title: title);
    }
  }
}

// ----------------------------------------- AppBar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      flexibleSpace: Stack(
        children: [
          Positioned(
            left: 20,
            top: 18,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              width: 35.0,
              height: 35.0,
              decoration: const BoxDecoration(
                color: Color.fromARGB(40, 255, 255, 255),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(),
                        ),
                      );
                    },
                  ),
                  Consumer<EventProvider>(
                    builder: (context, eventProvider, child) {
                      final notificationCount =
                          eventProvider.eventsWithNotification.length;
                      return notificationCount > 0
                          ? Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '$notificationCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Size get preferredSize => const Size.fromHeight(56.0);
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

//-------------------------------- Bottom Navigation Bar

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
      // notchMargin: 12.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildBottomNavigationItem(Icons.home, 0),
          _buildBottomNavigationItem(Icons.event, 1),
          _buildBottomNavigationItem(Icons.forest, 2),
          _buildBottomNavigationItem(Icons.star, 3),
          _buildBottomNavigationItem(Icons.person, 4),
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

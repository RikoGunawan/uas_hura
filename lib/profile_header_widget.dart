import 'package:flutter/material.dart';

import 'screens/profile/settings_screen.dart';
import 'utils/app_colors.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.0, // Set a fixed height for the header
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 18,
            child: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w200,
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
                      Icons.settings,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(),
                        ),
                      );
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
}

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 16),
          Text('Under Development..')
        ]);
  }
}

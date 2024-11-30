import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../screens/notification_screen.dart';
import 'notification_icon.dart';

class CreativeHuraHeaderWidget extends StatelessWidget {
  const CreativeHuraHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kIsWeb ? 45 : 70.0, // Set a fixed height for the header
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: kIsWeb ? 18 : 40,
            child: const Text(
              'Creative Hura',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
              right: 20,
              top: kIsWeb ? 10 : 32, // Sesuaikan posisi untuk web dan non-web
              child: NotificationIcon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}
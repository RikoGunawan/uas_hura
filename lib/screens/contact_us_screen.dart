import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Us ^_^',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 16),
          Text('Made by Riko Gunawan rikogunawan100@gmail.com')
        ]);
  }
}

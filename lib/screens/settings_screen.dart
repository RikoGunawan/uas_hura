// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:test/providers/profile_provider.dart';
// import 'edit_profile_screen.dart'; // Pastikan untuk membuat file ini
// import 'about_us_screen.dart'; // Pastikan untuk membuat file ini

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Settings'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             ListTile(
//               title: const Text('Edit Profile'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const EditProfileScreen()),
//                 );
//               },
//             ),
//             const Divider(),
//             ListTile(
//               title: const Text('About Us'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const AboutUsScreen()),
//                 );
//               },
//             ),
//             const Divider(),
//             // Tambahkan lebih banyak opsi di sini jika diperlukan
//           ],
//         ),
//       ),
//     );
//   }
// }
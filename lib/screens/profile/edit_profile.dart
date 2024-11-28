// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/profile_provider.dart';

// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   String? _profileImage; // Placeholder for profile image URL

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the controller with the current name
//     _nameController.text = context.read<ProfileProvider>().name;
//   }

//   void _saveChanges() {
//     final profileProvider = context.read<ProfileProvider>();
//     profileProvider.updateName(_nameController.text);
//     // Optionally, you can also update the profile image here
//     Navigator.pop(context);
//   }

//   Future<void> _selectImage() async {
//     // Implement image selection logic here (e.g., using image_picker package)
//     // For now, we'll just simulate selecting an image
//     setState(() {
//       _profileImage =
//           'https://example.com/profile_image.png'; // Placeholder image URL
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: _selectImage,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.grey[300],
//                 backgroundImage:
//                     _profileImage != null ? NetworkImage(_profileImage!) : null,
//                 child: _profileImage == null
//                     ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
//                     : null,
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _saveChanges,
//               child: const Text('Save Changes'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../providers/post_provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _description = '';
  File? _selectedImage; // To store the selected image file

  final ImagePicker _picker = ImagePicker(); // Instance of ImagePicker

  // Method to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery); // Pick from gallery
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Store the picked image file
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Post',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name input field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 10),

              // Description input field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 10),

              // Image selection section
              Row(
                children: [
                  _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : const Text('No image selected'),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Choose Image'),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Save button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final newPost = Post(
                      name: _name,
                      description: _description,
                      like: "0", // Default "like" value
                      imageFile: _selectedImage, // Add selected local image
                    );

                    // Add post to provider
                    Provider.of<PostProvider>(context, listen: false)
                        .addPost(newPost);

                    // Return to the previous screen
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Save Post',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

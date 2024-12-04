import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myapp/models/event.dart';

class AddHuraEvent extends StatefulWidget {
  final List<Event> events;

  const AddHuraEvent({
    super.key,
    required this.events,
  });

  @override
  State<AddHuraEvent> createState() => _AddHuraEventState();
}

class _AddHuraEventState extends State<AddHuraEvent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Uint8List? _imageBytes;
  DateTime? _selectedDate;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _imageBytes = result.files.single.bytes!;
      });
    }
  }

  Future<String?> _uploadImage(Uint8List imageBytes, String fileName) async {
    const bucketName = 'creative_hura';
    final path = 'uploads/${DateTime.now().millisecondsSinceEpoch}_$fileName';

    try {
      await Supabase.instance.client.storage.from(bucketName).uploadBinary(
            path,
            imageBytes,
          );

      return Supabase.instance.client.storage
          .from(bucketName)
          .getPublicUrl(path);
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_imageBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image.')),
        );
        return;
      }

      final imageUrl = await _uploadImage(_imageBytes!, _nameController.text);
      if (imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image.')),
        );
        return;
      }

      final newEvent = Event(
        id: widget.events.length + 1,
        name: _nameController.text,
        price: double.parse(_priceController.text),
        image: imageUrl,
        description: _descriptionController.text,
        eventDate: _selectedDate!,
      );

      setState(() {
        widget.events.add(newEvent);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event has been added successfully!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Event Name',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter event name.'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _priceController,
                label: 'Price',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildDateField(),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a description.'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildImagePicker(),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Event Date',
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            setState(() {
              _selectedDate = pickedDate;
              _dateController.text =
                  '${pickedDate?.day}/${pickedDate?.month}/${pickedDate?.year}';
            });
          },
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please pick a date.' : null,
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Event Image'),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Choose Image'),
            ),
            const SizedBox(width: 16),
            if (_imageBytes != null)
              const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ],
    );
  }
}

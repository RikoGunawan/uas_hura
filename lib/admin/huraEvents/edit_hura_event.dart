import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:myapp/models/event.dart';

class EditHuraEvent extends StatefulWidget {
  final Event event; // Event yang akan diedit
  final List<Event> events; // Referensi list event

  const EditHuraEvent({
    super.key,
    required this.event,
    required this.events,
  });

  @override
  State<EditHuraEvent> createState() => _EditHuraEventState();
}

class _EditHuraEventState extends State<EditHuraEvent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  File? _imageFile; // Untuk menyimpan gambar yang dipilih

  @override
  void initState() {
    super.initState();
    _preFillForm();
  }

  void _preFillForm() {
    _nameController.text = widget.event.name;
    _priceController.text = widget.event.price.toString();
    _dateController.text =
        '${widget.event.eventDate.day}/${widget.event.eventDate.month}/${widget.event.eventDate.year}';
    _imageController.text = widget.event.image;
    _descriptionController.text = widget.event.description;
    _selectedDate = widget.event.eventDate;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final updatedEvent = Event(
        id: widget.event.id,
        name: _nameController.text,
        price: double.parse(_priceController.text),
        image: _imageController.text,
        description: _descriptionController.text,
        eventDate: _selectedDate!,
      );

      final index = widget.events.indexWhere((e) => e.id == widget.event.id);
      if (index != -1) {
        setState(() {
          widget.events[index] = updatedEvent;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event has successfully updated!'),
        ),
      );

      Navigator.pop(context);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageController.text =
            _imageFile!.path; // Menyimpan path gambar di text controller
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
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
              // Tombol untuk memilih gambar
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 8),
              // Menampilkan gambar yang dipilih
              if (_imageFile != null)
                SizedBox(
                  height: 150,
                  child: Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(fontSize: 16),
                ),
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
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
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
}

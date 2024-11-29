import 'package:flutter/material.dart';

class EditHuraEventAdmin extends StatefulWidget {
  const EditHuraEventAdmin({super.key});

  @override
  State<EditHuraEventAdmin> createState() => _EditHuraEventAdminState();
}

class _EditHuraEventAdminState extends State<EditHuraEventAdmin> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDate;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Simulasi pendaftaran berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event Has Successfully Added!'),
        ),
      );

      // Anda dapat menambahkan logika untuk menyimpan event di sini
    }
  }

  String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the price.';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid price.';
    }
    return null;
  }

  String? validateImage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an image URL.';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description.';
    }
    return null;
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create New Event',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 32),
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
                validator: validatePrice,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildDateField(),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                validator: validateDescription,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _imageController,
                label: 'Image URL',
                validator: validateImage,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
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
      decoration: InputDecoration(
        labelText: 'Event Date',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              setState(() {
                _selectedDate = selectedDate;
                _dateController.text =
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
              });
            }
          },
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter event date.' : null,
    );
  }
}

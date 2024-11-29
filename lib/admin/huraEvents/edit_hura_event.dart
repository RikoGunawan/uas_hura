import 'package:flutter/material.dart';
import 'package:myapp/providers/event_provider.dart';
import 'package:provider/provider.dart';

// Model Event
class Event {
  final int id;
  final String name;
  final double price;
  final String image;
  final String description;
  final DateTime eventDate;

  Event({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.eventDate,
  });

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json['price']?.toDouble() ?? 0.0,
        image = json['image'],
        description = json['description'],
        eventDate = DateTime.parse(json['eventDate']);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
    };
  }
}

// Halaman untuk mengedit event
class EditHuraEventAdmin extends StatefulWidget {
  final Event? event;

  const EditHuraEventAdmin({super.key, this.event});

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

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _nameController.text = widget.event!.name;
      _priceController.text = widget.event!.price.toString();
      _imageController.text = widget.event!.image;
      _descriptionController.text = widget.event!.description;
      _dateController.text =
          '${widget.event!.eventDate.day}/${widget.event!.eventDate.month}/${widget.event!.eventDate.year}';
      _selectedDate = widget.event!.eventDate;
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Event editEvent = Event(
        id: widget.event?.id ?? 0,
        name: _nameController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        image: _imageController.text,
        description: _descriptionController.text,
        eventDate: _selectedDate ?? DateTime.now(),
      );

      Provider.of<EventProvider>(context, listen: false).editEvent;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event has been successfully updated!')),
      );
    }
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) return 'Please enter the price.';
    if (double.tryParse(value) == null) return 'Please enter a valid price.';
    return null;
  }

  String? _validateImage(String? value) {
    if (value == null || value.isEmpty) return 'Please enter an image URL.';
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a description.';
    return null;
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
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Edit Event',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                validator: _validatePrice,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildDateField(),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                validator: _validateDescription,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _imageController,
                label: 'Image URL',
                validator: _validateImage,
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
                  'Update',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../providers/event_provider.dart';
import '../utils/app_colors.dart';

class EventFormScreen extends StatefulWidget {
  final Event? existingEvent;

  const EventFormScreen({Key? key, this.existingEvent}) : super(key: key);

  @override
  _EventFormScreenState createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller berdasarkan existing event atau kosong
    _nameController =
        TextEditingController(text: widget.existingEvent?.name ?? '');
    _priceController = TextEditingController(
        text: widget.existingEvent?.price.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.existingEvent?.description ?? '');
    _dateController = TextEditingController(
        text: widget.existingEvent?.eventDate.toString().split(' ')[0] ?? '');
  }

  @override
  void dispose() {
    // Bersihkan controller
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.existingEvent?.eventDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Proses upload gambar (jika ada)
      String imageUrl = widget.existingEvent?.image ?? '';

      if (_imageFile != null) {
        // Tambahkan logika upload gambar ke Supabase storage
        // imageUrl = await uploadImageToSupabase(_imageFile!);
      }

      // Persiapkan data event
      final event = Event(
        id: widget.existingEvent?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        price: double.parse(_priceController.text),
        image: imageUrl,
        description: _descriptionController.text,
        eventDate: DateTime.parse(_dateController.text),
      );

      // Gunakan provider untuk tambah/edit event
      final eventProvider = context.read<EventProvider>();

      try {
        if (widget.existingEvent == null) {
          // Tambah event baru
          await eventProvider.addEvent(event);
        } else {
          // Edit event existing
          await eventProvider.editEvent(event);
        }

        // Kembali ke layar sebelumnya
        Navigator.of(context).pop();

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingEvent == null
                ? 'Event berhasil ditambahkan'
                : 'Event berhasil diperbarui'),
          ),
        );
      } catch (e) {
        // Tampilkan pesan error jika gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan event: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.existingEvent == null ? 'Tambah Event Baru' : 'Edit Event'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : (widget.existingEvent?.image != null
                          ? Image.network(widget.existingEvent!.image,
                              fit: BoxFit.cover)
                          : Center(child: Icon(Icons.add_a_photo, size: 50))),
                ),
              ),
              SizedBox(height: 16),

              // Input Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Event',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama event tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Input Price
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Harga Event',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga event tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Input Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Event',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi event tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Input Date
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Tanggal Event',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal event tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.existingEvent == null
                    ? 'Tambah Event'
                    : 'Perbarui Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

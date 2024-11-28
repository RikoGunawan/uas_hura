import 'package:flutter/material.dart';

// Model untuk event
class Event {
  int id;
  String name;
  double price;
  String image;
  String description;
  DateTime eventDate;

  Event({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.eventDate,
  });
}

class AddHuraEvent extends StatefulWidget {
  const AddHuraEvent({super.key});

  @override
  State<AddHuraEvent> createState() => _AddHuraEventState();
}

class _AddHuraEventState extends State<AddHuraEvent> {
  // List untuk menyimpan data event
  final List<Event> events = [];

  // Controller untuk input teks
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  // Menampilkan dialog untuk menambah atau mengedit event
  void _showEventDialog({Event? event}) {
    if (event != null) {
      // Jika mengedit, isi controller dengan data event yang ada
      nameController.text = event.name;
      priceController.text = event.price.toString();
    } else {
      // Jika menambah, kosongkan controller
      nameController.clear();
      priceController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(event == null ? 'Add Event' : 'Edit Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Event Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newEvent = Event(
                  id: event?.id ?? events.length + 1,
                  name: nameController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  image: '', // Placeholder for now
                  description: '', // Placeholder for now
                  eventDate: DateTime.now(), // Default value
                );

                if (event == null) {
                  _addEvent(newEvent);
                } else {
                  _editEvent(event, newEvent);
                }

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addEvent(Event event) {
    setState(() {
      events.add(event);
    });
  }

  void _editEvent(Event oldEvent, Event newEvent) {
    setState(() {
      final index = events.indexOf(oldEvent);
      if (index != -1) {
        events[index] = newEvent;
      }
    });
  }

  void _deleteEvent(Event event) {
    setState(() {
      events.remove(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Events'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                  title: Text(event.name),
                  subtitle: Text('Price: \$${event.price.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEventDialog(event: event),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteEvent(event),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _showEventDialog(),
              child: const Text('Add Event'),
            ),
          ),
        ],
      ),
    );
  }
}

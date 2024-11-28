import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/event.dart';

class EditHuraEvent extends StatefulWidget {
  const EditHuraEvent({super.key});

  @override
  State<EditHuraEvent> createState() => _EditHuraEventState();
}

class _EditHuraEventState extends State<EditHuraEvent> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final response = await supabase
        .from('events')
        .select()
        .order('event_date', ascending: true);

    setState(() {
      events = (response as List<dynamic>)
          .map((json) => Event.fromJson(json))
          .toList();
    });
    }

  Future<void> _addEvent(Event event) async {
    await supabase.from('events').insert(event.toJson());
    _fetchEvents();
  }

  Future<void> _editEvent(Event event) async {
    await supabase.from('events').update(event.toJson()).eq('id', event.id);
    _fetchEvents();
  }

  Future<void> _deleteEvent(int id) async {
    await supabase.from('events').delete().eq('id', id);
    _fetchEvents();
  }

  void _showEventDialog({Event? event}) {
    final nameController = TextEditingController(text: event?.name);
    final priceController =
        TextEditingController(text: event?.price.toString() ?? '');
    final imageController = TextEditingController(text: event?.image);
    final descriptionController =
        TextEditingController(text: event?.description);
    final dateController =
        TextEditingController(text: event?.eventDate.toIso8601String() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(event == null ? 'Add Event' : 'Edit Event'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Event Date'),
                  keyboardType: TextInputType.datetime,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newEvent = Event(
                  id: event?.id ?? 0, // ID hanya diperlukan saat update
                  name: nameController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  image: imageController.text,
                  description: descriptionController.text,
                  eventDate: DateTime.parse(dateController.text),
                );
                if (event == null) {
                  _addEvent(newEvent);
                } else {
                  _editEvent(newEvent);
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
                  leading: Image.network(
                    event.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported),
                  ),
                  title: Text(event.name),
                  subtitle: Text(
                      'Price: \$${event.price.toStringAsFixed(2)}\nDate: ${event.eventDate.toLocal()}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEventDialog(event: event),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteEvent(event.id),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';
import 'event_form_screen.dart';

class AdminEventListScreen extends StatelessWidget {
  const AdminEventListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin - Daftar Event'),
      ),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          return ListView.builder(
            itemCount: eventProvider.events.length,
            itemBuilder: (context, index) {
              final event = eventProvider.events[index];
              return ListTile(
                title: Text(event.name),
                subtitle: Text(event.eventDate.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                EventFormScreen(existingEvent: event),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Konfirmasi penghapusan
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Hapus Event'),
                              content: Text(
                                  'Apakah Anda yakin ingin menghapus event ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    eventProvider.deleteEvent(event.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Hapus'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventFormScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

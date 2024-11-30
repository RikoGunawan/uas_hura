import 'package:flutter/material.dart';
import 'package:myapp/admin/huraEvents/edit_hura_event.dart';
import 'package:myapp/providers/event_provider.dart';
import 'package:myapp/screens/huraEvents/edit_hura_event.dart';
import 'package:provider/provider.dart';

class AdminWidget extends StatelessWidget {
  const AdminWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Pastikan `event` dipilih dengan benar.
            final event = eventProvider.events.isNotEmpty
                ? eventProvider.events.first
                : null;

            if (event != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditHuraEvent(
                    event: event,
                    events: eventProvider.events,
                  ),
                ),
              );
            } else {
              // Tampilkan pesan jika tidak ada event
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No events available to edit.'),
                ),
              );
            }
          },
          child: const Text('Manage Hura Events'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'admin/huraEvents/edit_hura_event.dart';

class AdminWidget extends StatelessWidget {
  const AdminWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EditHuraEventAdmin()),
            );
          },
          child: const Text('Manage Hura Events'),
        ),
      ),
    );
  }
}
